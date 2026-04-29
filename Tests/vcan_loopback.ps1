# Virtual CAN loopback test using Kvaser canlib32.dll directly via P/Invoke.
# ch 0 (writer) -> Kvaser virtual bus -> ch 1 (reader)
$ErrorActionPreference = 'Stop'

$code = @"
using System;
using System.Runtime.InteropServices;
public static class Can {
  [DllImport("canlib32.dll")] public static extern void canInitializeLibrary();
  [DllImport("canlib32.dll")] public static extern int  canGetNumberOfChannels(out int n);
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
$count = 0
[void][Can]::canGetNumberOfChannels([ref]$count)
Write-Host "channels: $count"
if ($count -lt 2) { throw "need >=2 virtual channels" }

$tx = [Can]::canOpenChannel(0, [Can]::OPEN_ACCEPT_VIRTUAL); if ($tx -lt 0) { throw "open ch0 failed: $tx" }
$rx = [Can]::canOpenChannel(1, [Can]::OPEN_ACCEPT_VIRTUAL); if ($rx -lt 0) { throw "open ch1 failed: $rx" }
Write-Host "tx handle=$tx rx handle=$rx"

foreach ($h in @($tx,$rx)) {
  $s = [Can]::canSetBusParams($h, [Can]::BITRATE_500K, 0,0,0,0,0); if ($s -ne 0) { throw "setBusParams h=$h s=$s" }
  $s = [Can]::canBusOn($h); if ($s -ne 0) { throw "busOn h=$h s=$s" }
}

$ok = 0; $fail = 0
for ($i = 0; $i -lt 5; $i++) {
  $payload = [byte[]](0x11,0x22,0x33,0x44,0x55,0x66,0x77,$i)
  $stat = [Can]::canWriteWait($tx, 0x123, $payload, 8, [Can]::MSG_STD, 100)
  if ($stat -ne 0) { Write-Host "TX FAILED stat=$stat"; $fail++; continue }

  $rid = [long]0; $rdlc = [uint32]0; $rflag = [uint32]0; $rtime = [uint64]0
  $rmsg = New-Object byte[] 8
  $stat = [Can]::canReadWait($rx, [ref]$rid, $rmsg, [ref]$rdlc, [ref]$rflag, [ref]$rtime, 500)
  if ($stat -ne 0) { Write-Host "RX TIMEOUT stat=$stat"; $fail++; continue }
  $hex = ($rmsg | ForEach-Object { '{0:X2}' -f $_ }) -join ' '
  Write-Host ("rx id=0x{0:X3} dlc={1} flag=0x{2:X} data={3}" -f $rid, $rdlc, $rflag, $hex)
  $ok++
}

[void][Can]::canBusOff($tx); [void][Can]::canBusOff($rx)
[void][Can]::canClose($tx);  [void][Can]::canClose($rx)
Write-Host "result: ok=$ok fail=$fail"
if ($fail -gt 0) { exit 1 } else { exit 0 }
