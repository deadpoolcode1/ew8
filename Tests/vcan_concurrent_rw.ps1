# Reproduce the backend's pattern: concurrent reader + writer on the SAME handle.
$ErrorActionPreference = 'Stop'
$code = @"
using System;
using System.Runtime.InteropServices;
using System.Threading;
public static class Can {
  [DllImport("canlib32.dll")] public static extern void canInitializeLibrary();
  [DllImport("canlib32.dll")] public static extern int  canOpenChannel(int ch, int flags);
  [DllImport("canlib32.dll")] public static extern int  canSetBusParams(int hnd, long freq, uint t1, uint t2, uint sjw, uint nos, uint sm);
  [DllImport("canlib32.dll")] public static extern int  canBusOn(int hnd);
  [DllImport("canlib32.dll")] public static extern int  canBusOff(int hnd);
  [DllImport("canlib32.dll")] public static extern int  canClose(int hnd);
  [DllImport("canlib32.dll")] public static extern int  canWriteWait(int hnd, long id, byte[] msg, uint dlc, uint flag, uint timeout);
  [DllImport("canlib32.dll")] public static extern int  canReadWait(int hnd, out long id, byte[] msg, out uint dlc, out uint flag, out ulong time, uint timeout);
  public const int OPEN_ACCEPT_VIRTUAL = 0x0020;
  public const int MSG_STD = 0x0002;
  public const long BITRATE_500K = -2;
}
"@
Add-Type -TypeDefinition $code
[Can]::canInitializeLibrary()
$h = [Can]::canOpenChannel(0, [Can]::OPEN_ACCEPT_VIRTUAL); if ($h -lt 0) { throw "open: $h" }
[void][Can]::canSetBusParams($h, [Can]::BITRATE_500K, 0,0,0,0,0)
[void][Can]::canBusOn($h)

# Reader thread: tight canReadWait loop on the SAME handle (matches process() in canmanager.cpp)
$readerScript = {
  param($h)
  Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public static class CanR {
  [DllImport("canlib32.dll")] public static extern int canReadWait(int hnd, out long id, byte[] msg, out uint dlc, out uint flag, out ulong time, uint timeout);
}
"@
  $end = (Get-Date).AddSeconds(7)
  while ((Get-Date) -lt $end) {
    $rid = [long]0; $rdlc = [uint32]0; $rflag = [uint32]0; $rtime = [uint64]0
    $buf = New-Object byte[] 8
    [void][CanR]::canReadWait($h, [ref]$rid, $buf, [ref]$rdlc, [ref]$rflag, [ref]$rtime, 10)
  }
}
$readerJob = Start-Job -ScriptBlock $readerScript -ArgumentList $h
Start-Sleep -Milliseconds 200

# Writer: 5 writes/sec for 5 seconds (matches keepalive cadence + timeout=10ms)
$payload = [byte[]](1,2,3,4,5,6,7,8)
$ok = 0; $fail = 0; $firstFailStat = 0
$end = (Get-Date).AddSeconds(5)
while ((Get-Date) -lt $end) {
  $stat = [Can]::canWriteWait($h, 0x7E0, $payload, 8, [Can]::MSG_STD, 10)
  if ($stat -eq 0) { $ok++ } else { $fail++; if ($firstFailStat -eq 0) { $firstFailStat = $stat } }
  Start-Sleep -Milliseconds 200
}
Write-Host ("concurrent-rw: ok={0} fail={1} firstFailStat={2}" -f $ok, $fail, $firstFailStat)

Stop-Job $readerJob; Remove-Job $readerJob -Force
[void][Can]::canBusOff($h); [void][Can]::canClose($h)
