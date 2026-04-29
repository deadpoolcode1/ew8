# Listen on Kvaser virtual ch 1 and print every frame received.
# Pair with the backend, which opens ch 0.
param([int]$DurationSec = 30)
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
  [DllImport("canlib32.dll")] public static extern int  canReadWait(int hnd, out long id, byte[] msg, out uint dlc, out uint flag, out ulong time, uint timeout);
  public const int OPEN_ACCEPT_VIRTUAL = 0x0020;
  public const long BITRATE_500K = -2;
}
"@
Add-Type -TypeDefinition $code
[Can]::canInitializeLibrary()

$h = [Can]::canOpenChannel(1, [Can]::OPEN_ACCEPT_VIRTUAL); if ($h -lt 0) { throw "open ch1 failed: $h" }
[void][Can]::canSetBusParams($h, [Can]::BITRATE_500K, 0,0,0,0,0)
[void][Can]::canBusOn($h)
Write-Host "listening on ch 1 (handle=$h) for ${DurationSec}s..."

$end = (Get-Date).AddSeconds($DurationSec)
$count = 0
while ((Get-Date) -lt $end) {
  $rid = [long]0; $rdlc = [uint32]0; $rflag = [uint32]0; $rtime = [uint64]0
  $msg = New-Object byte[] 8
  $stat = [Can]::canReadWait($h, [ref]$rid, $msg, [ref]$rdlc, [ref]$rflag, [ref]$rtime, 200)
  if ($stat -eq 0) {
    $count++
    $hex = ($msg | ForEach-Object { '{0:X2}' -f $_ }) -join ' '
    Write-Host ("[{0,4}] t={1,8} id=0x{2:X3} dlc={3} flag=0x{4:X} data={5}" -f $count, $rtime, $rid, $rdlc, $rflag, $hex)
  }
}

[void][Can]::canBusOff($h); [void][Can]::canClose($h)
Write-Host "received: $count frames in ${DurationSec}s"
