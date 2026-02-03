for i in {1..10}; do
  cansend can0 700#0000190100800001
  cansend can0 701#00000000
  cansend can0 7BC#5A0032120000
  cansend can0 7BD#281606
  cansend can0 412#0000000000001100
  cansend can0 760#00FF000000023B67
  sleep 0.01
done
