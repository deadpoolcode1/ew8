import MyQMLenums 0.1
import QtQuick 2.9
import QtQuick.Controls 2.2

ApplicationWindow {

    id: page
    
    width: 320
    height: 240

    //width: 800
    //height: 640

    visible: true

    color: "black"

Component.onCompleted: {
           // page.showMaximized();
      }



Item {

    id: general_panel

    x: 0

    y: 0

    width: 320

    height: 240

    visible: true




Rectangle {
  id: status_panel

  color: "white"

  objectName: "status_panel_root"

  width: parent.width
  height: parent.height/7
  anchors.top: parent.top

  visible: true
}

Rectangle {
 id: left_panel

 objectName: "left_panel_root"


 color: "gray"

 width: 50
 anchors.top: status_panel.bottom
 anchors.left: parent.left
 anchors.bottom: parent.bottom

 visible: true

 Item {
     id: groupSliRegular
     objectName: "SLI_REG_QtQG"
     property bool mutexGroup: true

     function setVisible(TrueFalse)
     {
        visible = TrueFalse
     }

     property int layer_pri: 0
     property int canEntityType: Alert.QtQG

     visible: false;

     Image {

         function setVisible(TrueFalse)
         {
            visible = TrueFalse
         }

         id: alert_regular_100;
         objectName: "ALERT_REGULAR_100"
         property int layer_pri: 0
         property int canEntityType: Alert.ALERT_REGULAR_100

         visible: false;
         x: 0; y: 0; width: left_panel.width*3/4; height: left_panel.width*3/4;
         fillMode: Image.PreserveAspectFit;
         source:"qrc:/resources/EWAlerts/sli.png";
         rotation: 0;
     }
}





}


Rectangle {
 id: right_panel

 objectName: "right_panel_root"

 color: "gray"

 width: 50
 anchors.top: status_panel.bottom
 anchors.right: parent.right
 anchors.bottom: parent.bottom

 visible: true
}



Rectangle {

    anchors.left: left_panel.right
    anchors.right: right_panel.left
    anchors.top: status_panel.bottom
    anchors.bottom: parent.bottom



    id: main_panel

    objectName: "main_panel_root"
    property int canEntityType: Alert.QtQG
    property bool mutexGroup: false

    color: "green"

    visible: true

    //tree instance:
    Item {
        id: group1
        objectName: "PCW_QtQG"
        property bool mutexGroup: false

        property int layer_pri: 0

        property int canEntityType: Alert.QtQG

        function setVisible(TrueFalse)
        {
           visible = TrueFalse
        }
        visible: false

        ////////////////////////////////
        //Atomic items:
        Image {

            id: alert_pcw
            objectName: "PCW_ALERT"
            property int layer_pri: 0
            property int canEntityType: Alert.ALERT_PCW

            function setVisible(TrueFalse)
            {
               visible = TrueFalse
            }

            visible: false;
            x: 0; y: 20; width: 210; height: 140;
            fillMode: Image.PreserveAspectFit;
            source:"qrc:/resources/EWAlerts/pcw.png";
            rotation: 0;

        }
        ///////////////////////////////

        //Groups:
        Item
        {
            id: group2
            objectName: "FCW_QtQG"
            property bool mutexGroup: false

            property int canEntityType: Alert.QtQG

            property int layer_pri: 1

            function setVisible(TrueFalse)
            {
               visible = TrueFalse
            }
            visible: false


            ////////////////////////////////
            //Atomic items:
            Image {

                function setVisible(TrueFalse)
                {
                   visible = TrueFalse
                }

                id: alert_fcw;
                objectName: "FCW_ALERT"
                property int layer_pri: 0
                property int canEntityType: Alert.ALERT_FCW

                visible: false;
                x: 0; y: 20; width: 210; height: 140;
                fillMode: Image.PreserveAspectFit;
                source:"qrc:/resources/EWAlerts/fcw.png";
                rotation: 0;


            }



        }
        Item
        {
            id: groupGAG
            objectName: "GAG_QtQG"
            property bool mutexGroup: false

            property int canEntityType: Alert.QtQG

            property int layer_pri: 2

            function setVisible(TrueFalse)
            {
               visible = TrueFalse
            }
            visible: false


            Item {
                id: groupErrors
                objectName: "ERR_QtQG"
                property bool mutexGroup: false

                function setVisible(TrueFalse)
                {
                   visible = TrueFalse
                }

                property int layer_pri: 0
                property int canEntityType: Alert.QtQG

                visible: false;
            }

            Item {
                id: groupLanes
                objectName: "LANES_QtQG"
                property bool mutexGroup: false

                function setVisible(TrueFalse)
                {
                   visible = TrueFalse
                }

                property int layer_pri: 1
                property int canEntityType: Alert.QtQG

                visible: false;

                ////////////////////////////////
                //Atomic items:
                Image {

                    function setVisible(TrueFalse)
                    {
                       visible = TrueFalse
                    }

                    id: ldw_off;
                    objectName: "ALERT_LDWOFF"
                    property int layer_pri: 2
                    property int canEntityType: Alert.ALERT_LDWOFF

                    visible: false;
                    x: 0; y: 20;// width: 300;
                    height: 200;
                    fillMode: Image.PreserveAspectFit;
                    source:"qrc:/resources/EWAlerts/ldwoff.png";
                    rotation: 0;


                }
                Image {

                    function setVisible(TrueFalse)
                    {
                       visible = TrueFalse
                    }

                    id: ldw_on;
                    objectName: "ALERT_LDWON"
                    property int layer_pri: 1
                    property int canEntityType: Alert.ALERT_LDWON

                    visible: false;
                    x: 0; y: 20; //width: 300;
                    height: 200;
                    fillMode: Image.PreserveAspectFit;
                    source:"qrc:/resources/EWAlerts/ldwon.png";
                    rotation: 0;


                }

                Item
                {
                    function setVisible(TrueFalse)
                    {
                        blinkTimer_lldw.setRunning(TrueFalse)
                        visible = TrueFalse
                        console.log("interval = "+blinkTimer_lldw.interval);
                    }

                    id: alert_lldw;
                    objectName: "ALERT_LLDW"
                    property int layer_pri: 0
                    property int canEntityType: Alert.ALERT_LLDW

                    Image {
                        visible: true;
                        x: 0; y: 20; //width: 300;
                        height: 200;
                        fillMode: Image.PreserveAspectFit;
                        source:"qrc:/resources/EWAlerts/lldw_L.png";
                        rotation: 0;


                        Timer {

                            id: blinkTimer_lldw

                            property int intervalOn: 500
                            property int intervalOff: 300

                            interval: intervalOn
                            running: false
                            repeat: true

                            function setRunning(On)
                            {
                                interval = intervalOn
                                running = On
                            }

                            onTriggered:
                            {
                                parent.visible = !parent.visible
                                interval = (parent.visible ? intervalOn : intervalOff)
                            }
                        }

                    }

                    Image {
                        visible: true;
                        x: 0; y: 20; //width: 300;
                        height: 200;
                        fillMode: Image.PreserveAspectFit;
                        source:"qrc:/resources/EWAlerts/lldw_R.png";
                        rotation: 0;



                    }
                }


                /////////////////////////////////
                Item
                {
                    function setVisible(TrueFalse)
                    {
                        blinkTimer_rldw.setRunning(TrueFalse)
                        visible = TrueFalse
                    }

                    id: alert_rldw;
                    objectName: "ALERT_RLDW"
                    property int layer_pri: 0
                    property int canEntityType: Alert.ALERT_RLDW

                    Image {
                        visible: true;
                        x: 0; y: 20; //width: 300;
                        height: 200;
                        fillMode: Image.PreserveAspectFit;
                        source:"qrc:/resources/EWAlerts/rldw_L.png";
                        rotation: 0;
                    }

                    Image {
                        visible: true;
                        x: 0; y: 20; //width: 300;
                        height: 200;
                        fillMode: Image.PreserveAspectFit;
                        source:"qrc:/resources/EWAlerts/rldw_R.png";
                        rotation: 0;


                        Timer {

                            id: blinkTimer_rldw

                            property int intervalOn: 500
                            property int intervalOff: 300

                            interval: intervalOn
                            running: false
                            repeat: true

                            function setRunning(On)
                            {
                                interval = intervalOn
                                running = On
                            }

                            onTriggered:
                            {
                                parent.visible = !parent.visible
                                interval = (parent.visible ? intervalOn : intervalOff)
                            }
                        }


                    }
                }



                //////////////////////////////////

            }

            Item {
                id: groupBeam
                objectName: "BEAM_QtQG"
                property bool mutexGroup: true

                function setVisible(TrueFalse)
                {
                   visible = TrueFalse
                }

                property int layer_pri: 1
                property int canEntityType: Alert.QtQG

                visible: false;

                Image {

                    function setVisible(TrueFalse)
                    {
                       visible = TrueFalse
                    }

                    id: alert_hi_beam;
                    objectName: "ALERT_HI_BEAM"
                    property int layer_pri: 0
                    property int canEntityType: Alert.ALERT_HI_BEAM

                    visible: false;
                    x: 100; y: 100; width: 60; height: 60;
                    fillMode: Image.PreserveAspectFit;
                    source:"qrc:/resources/EWAlerts/fla_armed.png";
                    rotation: 0;
                }

                Image {

                    function setVisible(TrueFalse)
                    {
                       visible = TrueFalse
                    }

                    id: alert_low_beam;
                    objectName: "ALERT_LOW_BEAM"
                    property int layer_pri: 0
                    property int canEntityType: Alert.ALERT_LOW_BEAM

                    visible: false;
                    x: 100; y: 100; width: 60; height: 60;
                    fillMode: Image.PreserveAspectFit;
                    source:"qrc:/resources/EWAlerts/fla_armed_low.png";
                    rotation: 0;
                }



           }


            Item {
                id: groupCIPV
                objectName: "CIPV_QtQG"
                property bool mutexGroup: false

                function setVisible(TrueFalse)
                {
                   visible = TrueFalse
                }

                property int layer_pri: 1
                property int canEntityType: Alert.QtQG

                visible: false;

                ////////////////////////////////
                //Atomic items:
                Image {

                    function setVisible(TrueFalse)
                    {
                       visible = TrueFalse
                    }

                    id: alert_hmw0;
                    objectName: "ALERT_HMW0"
                    property int layer_pri: 0
                    property int canEntityType: Alert.ALERT_HMW0

                    visible: false;
                    x: 0; y: 20; width: 210; height: 140;
                    fillMode: Image.PreserveAspectFit;
                    source:"qrc:/resources/EWAlerts/hmwa03.png";
                    rotation: 0;
                }
                Image {

                    function setVisible(TrueFalse)
                    {
                       visible = TrueFalse
                    }

                    id: alert_hmw1;
                    objectName: "ALERT_HMW1"
                    property int layer_pri: 0
                    property int canEntityType: Alert.ALERT_HMW1

                    visible: false;
                    x: 0; y: 20; width: 210; height: 140;
                    fillMode: Image.PreserveAspectFit;
                    source:"qrc:/resources/EWAlerts/hmwa03.png";
                    rotation: 0;
                }
                Image {

                    function setVisible(TrueFalse)
                    {
                       visible = TrueFalse
                    }

                    id: alert_hmw2;
                    objectName: "ALERT_HMW2"
                    property int layer_pri: 0
                    property int canEntityType: Alert.ALERT_HMW2

                    visible: false;
                    x: 0; y: 20; width: 210; height: 140;
                    fillMode: Image.PreserveAspectFit;
                    source:"qrc:/resources/EWAlerts/hmwa03.png";
                    rotation: 0;
                }
                Image {

                    function setVisible(TrueFalse)
                    {
                       visible = TrueFalse
                    }

                    id: alert_hmw3;
                    objectName: "ALERT_HMW3"
                    property int layer_pri: 0
                    property int canEntityType: Alert.ALERT_HMW3

                    visible: false;
                    x: 0; y: 20; width: 210; height: 140;
                    fillMode: Image.PreserveAspectFit;
                    source:"qrc:/resources/EWAlerts/hmwa04.png";
                    rotation: 0;
                }
                Image {

                    function setVisible(TrueFalse)
                    {
                       visible = TrueFalse
                    }

                    id: alert_hmw4;
                    objectName: "ALERT_HMW4"
                    property int layer_pri: 0
                    property int canEntityType: Alert.ALERT_HMW4

                    visible: false;
                    x: 0; y: 20; width: 210; height: 140;
                    fillMode: Image.PreserveAspectFit;
                    source:"qrc:/resources/EWAlerts/hmwa05.png";
                    rotation: 0;
                }
                Image {

                    function setVisible(TrueFalse)
                    {
                       visible = TrueFalse
                    }

                    id: alert_hmw5;
                    objectName: "ALERT_HMW5"
                    property int layer_pri: 0
                    property int canEntityType: Alert.ALERT_HMW5

                    visible: false;
                    x: 0; y: 20; width: 210; height: 140;
                    fillMode: Image.PreserveAspectFit;
                    source:"qrc:/resources/EWAlerts/hmwa06.png";
                    rotation: 0;
                }
                Image {

                    function setVisible(TrueFalse)
                    {
                       visible = TrueFalse
                    }

                    id: alert_hmw6;
                    objectName: "ALERT_HMW6"
                    property int layer_pri: 0
                    property int canEntityType: Alert.ALERT_HMW6

                    visible: false;
                    x: 0; y: 20; width: 210; height: 140;
                    fillMode: Image.PreserveAspectFit;
                    source:"qrc:/resources/EWAlerts/hmwa07.png";
                    rotation: 0;
                }
                Image {

                    function setVisible(TrueFalse)
                    {
                       visible = TrueFalse
                    }

                    id: alert_hmw7;
                    objectName: "ALERT_HMW7"
                    property int layer_pri: 0
                    property int canEntityType: Alert.ALERT_HMW7

                    visible: false;
                    x: 0; y: 20; width: 210; height: 140;
                    fillMode: Image.PreserveAspectFit;
                    source:"qrc:/resources/EWAlerts/hmwa08.png";
                    rotation: 0;
                }
                Image {

                    function setVisible(TrueFalse)
                    {
                       visible = TrueFalse
                    }

                    id: alert_hmw8;
                    objectName: "ALERT_HMW8"
                    property int layer_pri: 0
                    property int canEntityType: Alert.ALERT_HMW8

                    visible: false;
                    x: 0; y: 20; width: 210; height: 140;
                    fillMode: Image.PreserveAspectFit;
                    source:"qrc:/resources/EWAlerts/hmwm09.png";
                    rotation: 0;
                }
                Image {

                    function setVisible(TrueFalse)
                    {
                       visible = TrueFalse
                    }

                    id: alert_hmw9;
                    objectName: "ALERT_HMW9"
                    property int layer_pri: 0
                    property int canEntityType: Alert.ALERT_HMW9

                    visible: false;
                    x: 0; y: 20; width: 210; height: 140;
                    fillMode: Image.PreserveAspectFit;
                    source:"qrc:/resources/EWAlerts/hmwm10.png";
                    rotation: 0;
                }
                Image {

                    function setVisible(TrueFalse)
                    {
                       visible = TrueFalse
                    }

                    id: alert_hmw10;
                    objectName: "ALERT_HMW10"
                    property int layer_pri: 0
                    property int canEntityType: Alert.ALERT_HMW10

                    visible: false;
                    x: 0; y: 20; width: 210; height: 140;
                    fillMode: Image.PreserveAspectFit;
                    source:"qrc:/resources/EWAlerts/hmwm12.png";
                    rotation: 0;
                }
                Image {

                    function setVisible(TrueFalse)
                    {
                       visible = TrueFalse
                    }

                    id: alert_hmw11;
                    objectName: "ALERT_HMW11"
                    property int layer_pri: 0
                    property int canEntityType: Alert.ALERT_HMW11

                    visible: false;
                    x: 0; y: 20; width: 210; height: 140;
                    fillMode: Image.PreserveAspectFit;
                    source:"qrc:/resources/EWAlerts/hmwm14.png";
                    rotation: 0;
                }
                Image {

                    function setVisible(TrueFalse)
                    {
                       visible = TrueFalse
                    }

                    id: alert_hmw12;
                    objectName: "ALERT_HMW12"
                    property int layer_pri: 0
                    property int canEntityType: Alert.ALERT_HMW12

                    visible: false;
                    x: 0; y: 20; width: 210; height: 140;
                    fillMode: Image.PreserveAspectFit;
                    source:"qrc:/resources/EWAlerts/hmwm16.png";
                    rotation: 0;
                }
                Image {

                    function setVisible(TrueFalse)
                    {
                       visible = TrueFalse
                    }

                    id: alert_hmw13;
                    objectName: "ALERT_HMW13"
                    property int layer_pri: 0
                    property int canEntityType: Alert.ALERT_HMW13

                    visible: false;
                    x: 0; y: 20; width: 210; height: 140;
                    fillMode: Image.PreserveAspectFit;
                    source:"qrc:/resources/EWAlerts/hmwm18.png";
                    rotation: 0;
                }
                Image {

                    function setVisible(TrueFalse)
                    {
                       visible = TrueFalse
                    }

                    id: alert_hmw14;
                    objectName: "ALERT_HMW14"
                    property int layer_pri: 0
                    property int canEntityType: Alert.ALERT_HMW14

                    visible: false;
                    x: 0; y: 20; width: 210; height: 140;
                    fillMode: Image.PreserveAspectFit;
                    source:"qrc:/resources/EWAlerts/hmwm21.png";
                    rotation: 0;
                }
                Image {

                    function setVisible(TrueFalse)
                    {
                       visible = TrueFalse
                    }

                    id: alert_hmw15;
                    objectName: "ALERT_HMW15"
                    property int layer_pri: 0
                    property int canEntityType: Alert.ALERT_HMW15

                    visible: false;
                    x: 0; y: 20; width: 210; height: 140;
                    fillMode: Image.PreserveAspectFit;
                    source:"qrc:/resources/EWAlerts/hmwm25.png";
                    rotation: 0;
                }
                Image {

                    function setVisible(TrueFalse)
                    {
                       visible = TrueFalse
                    }

                    id: alert_hmw_green;
                    objectName: "ALERT_HMW_GREEN"
                    property int layer_pri: 0
                    property int canEntityType: Alert.ALERT_HMW_GREEN

                    visible: false;
                    x: 0; y: 20; width: 210; height: 140;
                    fillMode: Image.PreserveAspectFit;
                    source:"qrc:/resources/EWAlerts/hmwm25.png";
                    rotation: 0;
                }

            }


        }


    }



}


    Component.onCompleted: {
    //TBD
     }
}

}
