import MyQMLenums 0.1
import builtin.mobileye.QRCode 0.1
import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import QtQml.Models 2.3


ApplicationWindow {

    id: page

    objectName: "AppWindow"

    signal itemSelfDeactivated(var canEntityType, string _objectName)

    width: 320
    height: 240

    visible: true

    Rectangle {

        id: general_panel

        objectName: "general_panel_root"

        color: "black"

        width: page.width

        height: page.height

        visible: true

        //Image
        Rectangle
        {
            id: status_panel

             objectName: "status_panel_root"

            width: general_panel.width
            height: general_panel.height/7
            anchors.top: general_panel.top


            //fillMode: Image.Stretch;
            //source: "../images/Containers/top-bar-frame@2x.png";
            color: parent.color;


            visible: true


            Image{

            height: status_panel.height
            x: status_panel.x + status_panel.width/2 - width/2

            fillMode: Image.PreserveAspectFit

            source:"../images/Containers/logo@2x.png";
            }

            //Lefter from logo:

            Image{

                id: alert_blinkers;
                objectName: "ALERT_BLINKERS"
                property int layer_pri: 0
                property string canEntityType: "ALERT_BLINKERS"

                function setVisibleSlot() {visible = true}
                function setInvisibleSlot() {visible = false}

                height: status_panel.height
                x: status_panel.x + status_panel.width*2/10
                fillMode: Image.PreserveAspectFit

                visible: false

                source:"../images/Statuses/blinkers@2x.png";

            }

            Item {
                id: groupBeam
                objectName: "BEAM_QtQG"
                property bool mutexGroup: true

                function setVisibleSlot() {setVisible(true)}
                function setInvisibleSlot() {setVisible(false)}

                function setVisible(isVisible)
                {
                    visible = isVisible
                }

                property int layer_pri: 0
                property int canEntityType: Alert.QtQG

                visible: false;

                Image {

                    function setVisibleSlot() {setVisible(true)}
                    function setInvisibleSlot() {setVisible(false)}

                    function setVisible(isVisible)
                    {
                        visible = isVisible
                    }

                    id: alert_hi_beam;
                    objectName: "ALERT_HI_BEAM"
                    property int layer_pri: 0
                    property string canEntityType: "ALERT_HI_BEAM"

                    visible: false;
                    height: status_panel.height*8/10
                    x: status_panel.x + (status_panel.width/10)
                    fillMode: Image.PreserveAspectFit;
                    source:"../images/Statuses/ihc@2x.png";
                    rotation: 0;
                }

                Image {

                    function setVisibleSlot() {setVisible(true)}
                    function setInvisibleSlot() {setVisible(false)}

                    function setVisible(isVisible)
                    {
                        visible = isVisible
                    }

                    id: alert_low_beam;
                    objectName: "ALERT_LOW_BEAM"
                    property int layer_pri: 0
                    property string canEntityType: "ALERT_LOW_BEAM"

                    visible: false;
                    height: status_panel.height*8/10
                    x: status_panel.x + (status_panel.width/10)
                    fillMode: Image.PreserveAspectFit;
                    source:"../images/Statuses/ihc_low@lincz.png";
                    rotation: 0;
                }



            }

            //TODO on right from logo

        }

      HalfCircleTray {
            id: left_panel

            side: "left"

            objectName: "left_panel_root"


            //color: "transparent"
            anchors.top: status_panel.bottom
            anchors.left: parent.left
            //anchors.bottom: parent.bottom

            visible: true






                TSR {
                    //general features

                    id: alert_sli_side

                    function setVisibleSlot(arg) {
                        console.log("SLI = "+arg);
                        canEntityArg = arg;
                        setVisible(true);
                    }

                    objectName: "SLI_SIDE"
                    property int layer_pri: 0
                    canEntityType: "ALERT_SLI"
                    canEntityArg: 0
                    //special features
                    is_main: false
                    its_pair_alert: alert_sli_main

                    source:"../images/TSRAlerts/sli@lincz.png";

                    Component.onCompleted:
                    {
                        console.log("item"+objectName.toString()+"says its entity type:" + canEntityType)
                    }

                    //TODO move text to TSR_SLI
                    Text {
                        text: parent.canEntityArg.toString()
                        font.family: "Arial"
                        font.pointSize: parent.is_main ? 40 : 10
                        font.bold: true
                        color: "black"
                        visible: parent.visible
                        opacity: 1
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter : parent.verticalCenter
                    }
                }







                TSR {

                    id: alert_motorway_side;
                    objectName: "ALERT_MOTORWAY_SIDE"
                    property int layer_pri: 0
                    property string canEntityType: "ALERT_MOTORWAY"
                    fillMode: Image.PreserveAspectFit;
                    source:"../images/EWAlerts/motorway.svg";
                    rotation: 0;
                }




                TSR {
                    id: alert_playground_side;
                    objectName: "ALERT_PLAYGROUND_SIDE"
                    property int layer_pri: 0
                    property string canEntityType: "ALERT_PLAYGROUND"
                    fillMode: Image.PreserveAspectFit;
                    source:"../images/EWAlerts/playground.svg";
                    rotation: 0;
                }



                TSR {
                    //general features
                    id: alert_no_pass_side;
                    objectName: "ALERT_NO_PASS_SIDE"
                    property int layer_pri: 0
                    canEntityType: "ALERT_NO_PASS"

                    //special features
                    is_main: false
                    its_pair_alert: alert_no_pass_main
                    source:"../images/EWAlerts/no_pass.svg";
                }



                TSR {
                    id: alert_end_all_restr_side;
                    objectName: "ALERT_END_ALL_RESTR_SIDE"
                    property int layer_pri: 0
                    property string canEntityType: "ALERT_END_ALL_RESTR"
                    is_main: false
                    //its_pair_alert: alert_end_all_restr_main
                    fillMode: Image.PreserveAspectFit;
                    source:"../images/EWAlerts/end_all_restr.svg";
                    rotation: 0;
                }
                //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

        }


        HalfCircleTray {
            id: right_panel

            side: "right"

            objectName: "right_panel_root"

            anchors.top: status_panel.bottom
            anchors.right: parent.right
            //anchors.bottom: parent.bottom

            visible: true

                SmartItem {

                    //general features
                    id: smart_animal_side;
                    objectName: "SMART_ANIMAL_SIDE"
                    property int layer_pri: 0
                    canEntityType: Alert.SMART_ANIMAL

                    //special features
                    is_main: false
                    its_pair_alert: smart_animal_main
                    source:"../images/SmartAlerts/animal.svg";

                }

                SmartItem {

                    //general features
                    id: smart_slippery_side;
                    objectName: "SMART_SLIPPERY_SIDE"
                    property int layer_pri: 0
                    canEntityType: Alert.SMART_SLIPPERY

                    //special features
                    is_main: false
                    its_pair_alert: smart_slippery_main
                    source:"../images/SmartAlerts/slippery.svg";

                }


                SmartItem {

                    //general features
                    id: smart_sev_weather_side;
                    objectName: "SMART_SEV_WEATHER_SIDE"
                    property int layer_pri: 0
                    canEntityType: Alert.SMART_SEV_WEATHER

                    //special features
                    is_main: false
                    its_pair_alert: smart_sev_weather_main
                    source:"../images/SmartAlerts/bww@2x.png";

                }



        }



        Rectangle {

            anchors.left: general_panel.left
            anchors.right: general_panel.right
            anchors.leftMargin: left_panel.width/2
            anchors.rightMargin: right_panel.width/2
            anchors.top: status_panel.bottom
            anchors.bottom: general_panel.bottom

            height: general_panel.height - status_panel.height

            id: main_panel

            objectName: "main_panel_root"
            property int canEntityType: Alert.QtQG
            property bool mutexGroup: false

            color: "transparent"

            visible: true

            //tree instance:
            Item {
                id: group1
                objectName: "PCW_QtQG"
                property bool mutexGroup: false

                anchors.fill: parent

                property int layer_pri: 0

                property int canEntityType: Alert.QtQG

                function setVisibleSlot() {setVisible(true)}
                function setInvisibleSlot() {setVisible(false)}

                function setVisible(isVisible)
                {
                    visible = isVisible
                }

                visible: false

                ////////////////////////////////
                //Atomic items:
                Image {

                    id: alert_pcw
                    objectName: "PCW_ALERT"
                    property int layer_pri: 0
                    property string canEntityType: "ALERT_PCW"

                    function setVisibleSlot() {setVisible(true)}
                    function setInvisibleSlot() {setVisible(false)}

                    function setVisible(isVisible)
                    {
                        visible = isVisible
                    }

                    visible: false;
                    x: 0; y: 20; width: 210; height: 140;
                    fillMode: Image.PreserveAspectFit;
                    source:"../images/EWAlerts/PCW@2x.png";
                    rotation: 0;

                }
                ///////////////////////////////

                //Groups:
                Item
                {
                    id: group2
                    objectName: "FCW_QtQG"
                    property bool mutexGroup: false

                    anchors.fill: parent

                    property int canEntityType: Alert.QtQG

                    property int layer_pri: 1


                    function setVisibleSlot() {setVisible(true)}
                    function setInvisibleSlot() {setVisible(false)}

                    function setVisible(isVisible)
                    {
                        visible = isVisible
                    }
                    visible: false

                    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                    //Groups:
                    Item
                    {
                        id: group4
                        objectName: "PDZ_QtQG"
                        property bool mutexGroup: false

                        property int canEntityType: Alert.QtQG

                        property int layer_pri: 1

                        function setVisibleSlot() {setVisible(true)}
                        function setInvisibleSlot() {setVisible(false)}

                        function setVisible(isVisible)
                        {
                            visible = isVisible
                        }
                        visible: false





                    //Atomic items:
                    Image {

                        function setVisibleSlot() {setVisible(true)}
                        function setInvisibleSlot() {setVisible(false)}

                        function setVisible(isVisible)
                        {

                            visible = isVisible
                        }

                        id: alert_pdz;
                        objectName: "PDZ_ALERT"
                        property int layer_pri: 0
                        property string canEntityType: "ALERT_PDZ"
                        opacity: 1.0

                        visible: false;
                        x: 0; y: 20; width: 210; height: 140;
                        //x: main_panel.width/8; y: 20; width: main_panel.width*3/4;
                        fillMode: Image.PreserveAspectFit;
                        source:"../images/EWAlerts/PDZ@2x.png";
                        rotation: 0;

                        SequentialAnimation {

                                running: alert_pdz.visible
                                loops: Animation.Infinite

                                PauseAnimation {duration: 300}
                                SmoothedAnimation { target: alert_pdz; property: "opacity"; from: 1.0; to: 0.0; duration: 100}
                                PauseAnimation {duration: 200}
                                SmoothedAnimation { target: alert_pdz; property: "opacity"; from: 0.0; to: 1.0; duration: 200}

                        }

                    }

                    }



                    Item {
                        id: groupErrors
                        objectName: "ERR_QtQG"
                        property bool mutexGroup: false

                        function setVisibleSlot()
                        {
                            visible = true
                        }

                        function setInvisibleSlot()
                        {
                            visible = false
                        }

                        property int layer_pri: 0
                        property int canEntityType: Alert.QtQG

                        visible: false;


                        QRCode{

                            function setVisibleSlotStr(snStrArg) {
                            sn = snStrArg;
                            visible = true
                            console.log("QR Displayed")
                            }
                            function setInvisibleSlot() {visible = false}

                            sn: "NA"

                             x: main_panel.width/8; y: 20; width: main_panel.width*3/4; height: width;

                            //x:20; y:20; width: 210; height: 210

                            contentsScale: 4

                            id: alert_qrcode;
                            objectName: "QRCODE"
                            property int layer_pri: 0
                            property string canEntityType: "INFO_QRCODE"

                            visible: false;
                            rotation: 0;
                        }

                        Image {

                            function setVisibleSlot(code) {visible = true; error_code = code}
                            function setInvisibleSlot() {visible = false}

                            id: alert_error;
                            objectName: "ERROR_ALERT"
                            property int layer_pri: 0
                            property string canEntityType: "ALERT_ERROR"
                            property int error_code: 0
                            opacity: 1.0

                            visible: false;
                            x: main_panel.width/8; y: 20; width: main_panel.width*3/4;
                            fillMode: Image.PreserveAspectFit;
                            source:"../images/EWAlerts/error@lincz.png";
                            rotation: 0;

                            Text {
                                text: "ER-"+parent.error_code.toString(16).toUpperCase()
                                font.family: "Arial"
                                font.pointSize:  20
                                font.bold: true
                                color: "#ffffff"
                                opacity: 1
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.top : parent.bottom
                            }


                        }




                    }


                    Image {

                        function setVisibleSlot() {setVisible(true)}
                        function setInvisibleSlot() {setVisible(false)}

                        function setVisible(isVisible)
                        {
                            visible = isVisible
                        }

                        id: alert_fcw;
                        objectName: "FCW_ALERT"
                        property int layer_pri: 0
                        property string canEntityType: "ALERT_FCW"
                        opacity: 1.0

                        visible: false;
                        x: 0; y: 20; width: 210; height: 140;
                        fillMode: Image.PreserveAspectFit;
                        source:"../images/EWAlerts/FCW@2x.png";
                        rotation: 0;

                        SequentialAnimation {
                                running: alert_fcw.visible
                                loops: Animation.Infinite

                                PauseAnimation {duration: 300}
                                //OpacityAnimator
                                ScaleAnimator {target:  alert_fcw; from: 1; to: 0; duration: 100
                                easing.type: Easing.InOutExpo;
                                }
                                PauseAnimation {duration: 200}
                                //OpacityAnimator
                                ScaleAnimator {target:  alert_fcw; from: 0; to: 1; duration: 200
                                easing.type: Easing.InOutExpo;
                                }
                        }
                    }




                        TSR {

                             id: alert_sli_main

                            //general features
                            objectName: "ALERT_SLI_MAIN"
                            property int layer_pri: 1
                            canEntityType: "ALERT_SLI"
                            canEntityArg: 0

                            //special features
                            is_main: true
                            its_pair_alert: alert_sli_side
                            source:"../images/TSRAlerts/sli@lincz300x300.png";

                            //TODO move text to TSR_SLI
                            Text {
                                text: parent.canEntityArg.toString();
                                font.family: "Arial"
                                font.pointSize: parent.is_main ? 40 : 10
                                font.bold: true
                                color: "black"
                                opacity: 1
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.verticalCenter : parent.verticalCenter
                            }

                    }

                    TSR {

                        //general features
                        id: alert_no_pass_main;
                        objectName: "ALERT_NO_PASS_MAIN"
                        property int layer_pri: 1
                        canEntityType: "ALERT_NO_PASS"

                        //special features
                        is_main: true
                        its_pair_alert: alert_no_pass_side
                        source:"../images/EWAlerts/no_pass.svg";

                    }

                    SmartItem {

                        //general features
                        id: smart_animal_main;
                        objectName: "SMART_ANIMAL_MAIN"
                        property int layer_pri: 0
                        canEntityType: Alert.SMART_ANIMAL

                        //special features
                        is_main: true
                        its_pair_alert: smart_animal_side
                        source:"../images/SmartAlerts/animal.svg";

                    }

                    SmartItem {

                        //general features
                        id: smart_slippery_main;
                        objectName: "SMART_SLIPPERY_MAIN"
                        property int layer_pri: 0
                        canEntityType: Alert.SMART_SLIPPERY

                        //special features
                        is_main: true
                        its_pair_alert: smart_slippery_side
                        source:"../images/SmartAlerts/slippery.svg";

                    }

                    SmartItem {

                        //general features
                        id: smart_sev_weather_main;
                        objectName: "SMART_SEV_WEATHER_MAIN"
                        property int layer_pri: 0
                        canEntityType: Alert.SMART_SEV_WEATHER

                        //special features
                        is_main: true
                        its_pair_alert: smart_sev_weather_side
                        source:"../images/SmartAlerts/bww@2x.png";
                    }
                }

                Item
                {
                    id: groupGAG
                    objectName: "GAG_QtQG"
                    property bool mutexGroup: false

                   anchors.fill: parent

                    property int canEntityType: Alert.QtQG

                    property int layer_pri: 2

                   function setVisibleSlot() {visible = true}
                   function setInvisibleSlot() {visible = false}

                    visible: false

                    Item {
                        id: groupLanes
                        objectName: "LANES_QtQG"
                        property bool mutexGroup: false

                        height:main_panel.height*3/5

                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right

                        function setVisibleSlot() {visible = true}
                        function setInvisibleSlot() {visible = false}

                        property int layer_pri: 1
                        property int canEntityType: Alert.QtQG

                        visible: false;

                        Image{
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter


                            fillMode: Image.PreserveAspectFit;
                            source:"../images/Containers/Road@2x.png";

                            visible: true
                        }


                        Item {
                            id: groupLanes_left
                            objectName: "LANES_LEFT_QtQG"
                            property bool mutexGroup: false

                            //anchors.fill: parent

                            anchors.bottom: parent.bottom
                            anchors.left: parent.left

                            function setVisibleSlot() {visible = true}
                            function setInvisibleSlot() {visible = false}

                            property int layer_pri: 1
                            property int canEntityType: Alert.QtQG

                            visible: false;

                            Image {

                                function setVisibleSlot() {visible = true}
                                function setInvisibleSlot() {visible = false}

                                id: alert_ldwoff_left

                                objectName: "ALERT_LDWOFF_LEFT"
                                property int layer_pri: 0
                                property string canEntityType: "ALERT_LDWOFF"

                                visible:false

                                //height: parent.height;
                                anchors.bottom: parent.bottom
                                anchors.left: parent.left

                                fillMode: Image.PreserveAspectFit;
                                source:"../images/EWAlerts/Lane_L_off@2x.png";
                                rotation: 0;



                            }


                            Image {

                                function setVisibleSlot() {visible = true}
                                function setInvisibleSlot() {visible = false}

                                id: alert_ldwon_left

                                objectName: "LDWON_LEFT_ALERT"
                                property int layer_pri: 2
                                property string canEntityType: "ALERT_LDWON"

                                visible:false

                                //height: parent.height;
                                anchors.bottom: parent.bottom
                                anchors.left: parent.left

                                fillMode: Image.PreserveAspectFit;
                                source:"../images/EWAlerts/Lane_L_on@2x.png";
                                rotation: 0;



                            }



                            Image {

                                function setVisibleSlot() {visible = true}
                                function setInvisibleSlot() {visible = false}

                                id: alert_lldw

                                objectName: "LLDW_ALERT"
                                property int layer_pri: 1
                                property string canEntityType: "ALERT_LLDW"

                                visible:false

                                //height: parent.height;
                                anchors.bottom: parent.bottom
                                anchors.left: parent.left

                                fillMode: Image.PreserveAspectFit;
                                source:"../images/EWAlerts/Lane_L_alert@2x.png";
                                rotation: 0;


                                SequentialAnimation {

                                    running: alert_lldw.visible
                                    loops: Animation.Infinite

                                    PropertyAction {target: alert_lldw; property: "opacity"; value: 1.0}
                                    PauseAnimation {duration: 500}
                                    PropertyAction {target: alert_lldw; property: "opacity"; value: 0.0}
                                    PauseAnimation {duration: 300}

                                }
                            }

                        }



                        Item {
                            id: groupLanes_right
                            objectName: "LANES_RIGHT_QtQG"
                            property bool mutexGroup: false

                            //anchors.fill: parent
                            anchors.bottom: parent.bottom
                            anchors.right: parent.right


                            function setVisibleSlot() {visible = true}
                            function setInvisibleSlot() {visible = false}

                            property int layer_pri: 1
                            property int canEntityType: Alert.QtQG

                            visible: false;

                            Image {

                                function setVisibleSlot() {visible = true}
                                function setInvisibleSlot() {visible = false}

                                id: alert_ldwoff_right

                                objectName: "ALERT_LDWOFF_RIGHT"
                                property int layer_pri: 0
                                property string canEntityType: "ALERT_LDWOFF"

                                visible:false

                                //height: parent.height;
                                anchors.bottom: parent.bottom
                                anchors.right: parent.right

                                fillMode: Image.PreserveAspectFit;
                                source:"../images/EWAlerts/Lane_R_off@2x.png";
                                rotation: 0;



                            }


                            Image {

                                function setVisibleSlot() {visible = true}
                                function setInvisibleSlot() {visible = false}

                                id: alert_ldwon_right

                                objectName: "LDWON_RIGHT_ALERT"
                                property int layer_pri: 2
                                property string canEntityType: "ALERT_LDWON"

                                visible:false

                                //height: parent.height;
                                anchors.bottom: parent.bottom
                                anchors.right: parent.right

                                fillMode: Image.PreserveAspectFit;
                                source:"../images/EWAlerts/Lane_R_on@2x.png";
                                rotation: 0;



                            }



                            Image {

                                function setVisibleSlot() {visible = true}
                                function setInvisibleSlot() {visible = false}

                                id: alert_rldw

                                objectName: "RLDW_ALERT"
                                property int layer_pri: 1
                                property string canEntityType: "ALERT_RLDW"

                                visible:false

                                //height: parent.height;
                                anchors.bottom: parent.bottom
                                anchors.right: parent.right

                                fillMode: Image.PreserveAspectFit;
                                source:"../images/EWAlerts/Lane_R_alert@2x.png";
                                rotation: 0;


                                SequentialAnimation {

                                    running: alert_rldw.visible
                                    loops: Animation.Infinite

                                    PropertyAction {target: alert_rldw; property: "opacity"; value: 1.0}
                                    PauseAnimation {duration: 500}
                                    PropertyAction {target: alert_rldw; property: "opacity"; value: 0.0}
                                    PauseAnimation {duration: 300}

                                }
                            }

                        }

                    }




                    Item {
                        id: groupCIPV
                        objectName: "CIPV_QtQG"
                        property bool mutexGroup: false

                        function setVisibleSlot() {setVisible(true)}
                        function setInvisibleSlot() {setVisible(false)}

                        function setVisible(isVisible)
                        {
                            visible = isVisible
                        }

                        property int layer_pri: 1
                        property int canEntityType: Alert.QtQG

                        visible: false;








                        ////////////////////////////////
                        //Atomic items:
                        HMW
                        {
                            id: alert_hmw_alert;
                            objectName: "HMW_ALERT_ALERT"
                            property int layer_pri: 0
                            property string canEntityType: "ALERT_HMW_ALERT"
                            vehicle_source: "../images/EWAlerts/Vehicle@2x.png";
                            strips_source:"../images/EWAlerts/Strips_red@2x.png";
                            text_color: "red"
                        }

                        HMW
                        {
                            id: alert_hmw_monitor;
                            objectName: "HMW_MONITOR_ALERT"
                            property int layer_pri: 0
                            property string canEntityType: "ALERT_HMW_MONITOR"
                            vehicle_source: "../images/EWAlerts/Vehicle_green@2x.png";
                            strips_source:"../images/EWAlerts/Strips@2x.png";
                            text_color: "#00ff00"
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
