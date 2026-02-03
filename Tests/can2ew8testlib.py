import os
from copyreg import constructor
from time import sleep

# This is a sample Python script.
import cantools
import can
#import platform
import time

BITRATE = 500000
CHANNEL = 0

#PLATFORM = platform.system()

#end of defines

can.rc['interface'] = "kvaser"
can.rc['channel'] = CHANNEL
#can.rc['bitrate'] = BITRATE #WARNING does not work




def send_one(std_id,aData, bus):
    msg = can.Message(arbitration_id = std_id,
                      data = aData, is_extended_id= False)
    try:
        bus.send(msg)
    except can.CanError:
        print("CAN Error: Message NOT sent")

class EW8test(object):
    dbset = dict();
    frames2send = []

    def __init__(self):
        homedir = os.path.expanduser('~')
        print(homedir)
        dbcdir = os.path.join(homedir,'canquick','DBC')
        print(dbcdir)

        files = os.listdir(dbcdir)
        for file in files:
            print(file)
            db = cantools.db.load_file(os.path.join(dbcdir,file))

            for msg in db.messages:
                print(msg)
                self.dbset[msg.frame_id] = msg

    def constructMessage(self, id, dict_of_signals, fill = 0):
        msg = self.dbset[id]
        can_frame = bytearray(len([0x00] * msg.length))
        can_dict = msg.decode(can_frame)
        can_dict.update(dict_of_signals)
        frame_data = msg.encode(can_dict)
        self.frames2send.append((id,frame_data))

    def deleteMessage(self, id):
        for frame in self.frames2send:
            if frame[0] == id:
                self.frames2send.remove(frame)



    def send(self, period = 0.01, time2send = 0):
        with can.interface.Bus() as bus:
            time2stop = time.time() + time2send
            while (time2send == 0 or time2stop > time.time()):
                for msg in self.frames2send:
                    (id,data) = msg
                    print(id)
                    send_one(id, data, bus)
                    sleep(period)



# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    pass
    

