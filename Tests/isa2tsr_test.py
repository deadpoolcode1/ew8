#!/usr/bin/env python3

#from subprocess import call
from can2ew8testlib import EW8test


def main():

    ew8class = EW8test()

    ew8class.constructMessage(0x700,dict_of_signals = {"TSR_enabbled": 1, "Error_Active": 1})

    ew8class.constructMessage(1831,
                              {
                                    "Vision_only_Sign_Type_D1":1, "Vision_only_supp_Sign_Type_D1": 1,
                                    "Vision_only_Sign_Type_D2": 0xff,"Vision_only_supp_Sign_Type_D2": 0,
                                    "Vision_only_Sign_Type_D3": 0xff,"Vision_only_supp_Sign_Type_D3": 0,
                                    "Vision_only_Sign_Type_D4": 0xff, "Vision_only_supp_Sign_Type_D4": 0
                               })

    ew8class.constructMessage(1980, {
                                    "ISA_STATE_Value": 3,
                                     "ISA_Legal_Speed": 30,
                                    "Legal_Speed_Validity": 2
        })

    ew8class.constructMessage(0x412, {"Validity": 1})

    ew8class.send(time2send = 10)

    #TODO IMS_ISA
    ew8class.deleteMessage(1980)
    ew8class.constructMessage(1980, {"ISA_STATE_Value": 0})


    ew8class.send(time2send= 10)

    #TODO IMS_ISA disable state

    ew8class.send(0.01, time2send=10)









# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    main()

