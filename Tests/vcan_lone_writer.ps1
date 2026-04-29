# Reproduces the "*Transmitted frame is faulty*" diagnosis:
# (A) Open ch 0 alone, write — expect failures (no ACK peer).
# (B) Open ch 0 + ch 1 (idle peer), write on ch 0 — expect success.
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

function OpenCh($idx) {
  $h = [Can]::canOpenChannel($idx, [Can]::OPEN_ACCEPT_VIRTUAL); if ($h -lt 0) { throw "open ch$idx : $h" }
  [void][Can]::canSetBusParams($h, [Can]::BITRATE_500K, 0,0,0,0,0)
  [void][Can]::canBusOn($h)
  return $h
}

function WriteN($h, $n, $tag) {
  $payload = [byte[]](1,2,3,4,5,6,7,8)
  $ok = 0; $fail = 0
  for ($i = 0; $i -lt $n; $i++) {
    $stat = [Can]::canWriteWait($h, 0x123, $payload, 8, [Can]::MSG_STD, 100)
    if ($stat -eq 0) { $ok++ } else { $fail++ }
  }
  Write-Host ("[{0}] writes: ok={1} fail={2}" -f $tag, $ok, $fail)
}

# (A) Lone writer
$tx = OpenCh 0
WriteN $tx 5 "lone-writer"
[void][Can]::canBusOff($tx); [void][Can]::canClose($tx)

# (B) Writer + idle peer on ch 1
$tx = OpenCh 0
$peer = OpenCh 1
WriteN $tx 5 "writer+peer"
[void][Can]::canBusOff($tx);   [void][Can]::canClose($tx)
[void][Can]::canBusOff($peer); [void][Can]::canClose($peer)
