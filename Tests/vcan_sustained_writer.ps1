# Sustained-write test: writes for ~5s on ch 0 alone, reports first-failure index.
$ErrorActionPreference = 'Stop'
$code = @"
using System;
using System.Runtime.InteropServices;
public static class Can {
  [DllImport("canlib32.dll")] public static extern void canInitializeLibrary();
  [DllImport("canlib32.dll")] public static extern int  canOpenChannel(int ch, int flags);
  [DllImport("canlib32.dll")] public static extern int  canSetBusParams(int hnd, long freq, uint t1, uint t2, uint sjw, uint nos, uint sm);
  [DllImport("canlib32.dll")] public static extern int  canBusOn(int hnd);
  [DllImport("canlib32.dll")] public static extern int  canBusOff(int hnd);
  [DllImport("canlib32.dll")] public static extern int  canClose(int hnd);
  [DllImport("canlib32.dll")] public static extern int  canWriteWait(int hnd, long id, byte[] msg, uint dlc, uint flag, uint timeout);
  public const int OPEN_ACCEPT_VIRTUAL = 0x0020;
  public const int MSG_STD = 0x0002;
  public const long BITRATE_500K = -2;
}
"@
Add-Type -TypeDefinition $code
[Can]::canInitializeLibrary()
$h = [Can]::canOpenChannel(0, [Can]::OPEN_ACCEPT_VIRTUAL); if ($h -lt 0) { throw "open ch0 : $h" }
[void][Can]::canSetBusParams($h, [Can]::BITRATE_500K, 0,0,0,0,0)
[void][Can]::canBusOn($h)

$payload = [byte[]](1,2,3,4,5,6,7,8)
$ok = 0; $fail = 0; $firstFailIdx = -1; $firstFailStat = 0
$end = (Get-Date).AddSeconds(5)
$idx = 0
while ((Get-Date) -lt $end) {
  $stat = [Can]::canWriteWait($h, 0x7E0, $payload, 8, [Can]::MSG_STD, 10)  # match backend
  if ($stat -eq 0) { $ok++ } else { $fail++; if ($firstFailIdx -lt 0) { $firstFailIdx = $idx; $firstFailStat = $stat } }
  $idx++
  Start-Sleep -Milliseconds 200  # ~5/sec, mirrors backend keepalive
}
Write-Host ("sustained 5s: ok={0} fail={1}" -f $ok, $fail)
if ($firstFailIdx -ge 0) { Write-Host ("first failure at idx={0} stat={1}" -f $firstFailIdx, $firstFailStat) }
[void][Can]::canBusOff($h); [void][Can]::canClose($h)
