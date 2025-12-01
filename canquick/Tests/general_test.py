#!/usr/bin/env python3

#from subprocess import call
import os
import can
import time
import timeit
import platform
import msvcrt


BASICSLEEP = 0.03
VERBOSE = True 

#Basic support functions:

#Bitrate is default 500K
BITRATE = 500000
CHANNEL = 1

PLATFORM = platform.system()

#end of defines

can.rc['interface'] = "kvaser"
can.rc['channel'] = CHANNEL
#can.rc['bitrate'] = BITRATE #WARNING does not work
bus = can.interface.Bus()

def send_one(std_id,aData):
    msg = can.Message(arbitration_id = std_id,
                      data = aData,
                      extended_id=False)
    try:
        bus.send(msg)
    except can.CanError:
        print("CAN Error: Message NOT sent")



def write_to_can(msg_id,data):
  argumentstr = " ".join(hex(i) for i in data) + " -i{} -r1 -c{} -b{} -v0".format(hex(msg_id),CHANNEL,BITRATE)
  starttime = time.time()
  send_one(msg_id,data);
  stoptime = time.time()
  if VERBOSE:
      print(str(starttime) +' ' + str(stoptime) + ' ' + "data:" +' '+argumentstr)

#Send messages functions:
 
def msg0x700(B1BYTE = 0x0,B2BYTE= 0x0,B4BYTE = 0x1, B5BYTE = 0x0, B7BYTE = 0x0):
    write_to_can(0x700, [ 0x0, B1BYTE, B2BYTE, 0x1, B4BYTE , B5BYTE, 0x0, B7BYTE ])
    time.sleep(BASICSLEEP)

def msg0x727(SIGN0 = 0xFF,SUPP0 = 0x0,SIGN1 = 0xFF, SUPP1 = 0x0, SIGN2 = 0xFF,SUPP2 = 0x0,SIGN3 = 0xFF,SUPP3 = 0x0):
    write_to_can(0x727, [ SIGN0, SUPP0, SIGN1, SUPP1, SIGN2, SUPP2, SIGN3, SUPP3 ])
    time.sleep(BASICSLEEP)

#Tests:
def test_an_alert_b5(anAlert):
    iterfirst = True
    B5BYTE = anAlert
    starttime = time.time()
    curtime = time.time()

   #while curtime - starttime < 0.3:
    while iterfirst:
        msg0x700(B5BYTE = anAlert)

        curtime = time.time()

        if iterfirst  == True:
            print("test with all seeqs alert " + hex(anAlert))
            iterfirst = False
			
def test_an_alert_b4(anAlert):
    iterfirst = True
    B5BYTE = anAlert
    starttime = time.time()
    curtime = time.time()

   #while curtime - starttime < 0.3:
    while iterfirst:
        msg0x700(B4BYTE = anAlert)

        curtime = time.time()

        if iterfirst  == True:
            print("test with all seeqs alert " + hex(anAlert))
            iterfirst = False


def loop(msg_fn,**args):
    while not msvcrt.kbhit():
        msg_fn(**args)
    msvcrt.getwch()



def main():
    time.sleep(3)
    
    while True:
        
        loop(msg0x700, B5BYTE = 0x4)
        loop(msg0x700, B2BYTE = 0x0,B7BYTE = 0x1)
        
        print("Next is FCW alert")
        loop(msg0x700, B2BYTE = 0x11,B5BYTE = 0x4,B7BYTE = 0x3)

        print("I am FCW alert")
        loop(msg0x700, B2BYTE = 0x11,B4BYTE = 0x8,B7BYTE = 0x3)
        #msg0x700(B4BYTE = 0x8)

        

        loop(msg0x700, B4BYTE = 0x7)

        loop(msg0x700, B4BYTE = 0x4)

        loop(msg0x700, B4BYTE = 0x2)
        

        loop(msg0x700, B4BYTE = 0x6)

        loop(msg0x700, B4BYTE = 0x6, B5BYTE = 0x4)

        loop(msg0x700, B1BYTE = 0x80)

        loop(msg0x700, B1BYTE = 0xC0)

        loop(msg0x700, B1BYTE = 0x80)

        loop(msg0x700, B1BYTE = 0x40)
           
        loop(msg0x727, SIGN1 = 0x9)

        loop(msg0x727)

        loop(msg0x727, SIGN1 = 0x6)
        
        loop(msg0x727, SIGN1 = 0xAF)

        loop(msg0x727, SIGN1 = 0xAB)

        loop(msg0x727, SIGN1 = 0x40)

        loop(msg0x727, SIGN1 = 0xC8)
		
    input("Press ENTER to close the window")

main()


"""
function msg0x703_err {
  CAN_ID=0x703

  write_to_can  0x00  0x0  0x2  0x0  0x0  0x6  0x0   0x0
}
"""
