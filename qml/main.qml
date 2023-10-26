import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQml.Models 2.3

//Custom modules:
import MyQMLenums 0.1
import builtin.mobileye.QRCode 0.1
import builtin.mobileye.EWInfo 0.1



ApplicationWindow{
    id: page
    signal keyPressedReportSend(int qtKey);
    signal keyReleasedReportSend(int qtKey);
    signal volumeKeySend(int qtKey);//Qt.Key
    signal brightnessChanged(int newLevel);
    signal alertsReportSend(bool b1, bool b2, bool b3, bool b4)

    property bool keyDownState: false;
    property bool keyReturnState: false;
    property bool keyUpState: false;

    property color white: "#ffffff"


    signal debugMessagesConnect(bool On);

    //flags: Qt.FramelessWindowHint

    function debugMessage(arg)
    {
       console.log("DEBUG MESSAGE: " + arg);
       debug.text = arg
       debug.visible = true;
       debug_timer.restart()
    }


    FontLoader {id: intelFont; source: "fonts/intelone-display-font-family-ttf/intelone-display-bold.ttf"}
    FontLoader { source: "fonts/intelone-display-font-family-ttf/intelone-display-regular.ttf"}
     FontLoader { source: "fonts/intelone-display-font-family-ttf/intelone-display-medium.ttf"}
    FontLoader { source: "fonts/intelone-display-font-family-ttf/intelone-display-light.ttf"}



    Text {
        z: 100
        id: debug
        color: white
        text: ""
        anchors.top: parent.top
        anchors.topMargin: 50
        anchors.horizontalCenterOffset: 0
        font.pixelSize: 14
        font.capitalization: Font.MixedCase
        topPadding: 0
        anchors.horizontalCenter: parent.horizontalCenter
        font.family: intelFont.name
        visible: false

        Timer {
            id: debug_timer
            running: false
            interval: 2000
            onTriggered: {
                debug.visible = false
            }
        }
    }

    property bool isInEdition: false


    width: 320
    height: 240
    objectName: "AppWindow"

    visible: true

    Rectangle {
        id: general_panel
        property int canEntityType: Alert.QtQG
        property int layer_pri: 0
        y: 0
        visible: true

        color: "#000000"

        anchors.fill: parent
        objectName: "general_panel_root"

        width: 320
        height: 240

        DummyItem{
            property int layer_pri: 5
            canEntityType: "OM_NORMAL"
        }

        Item {
            id: shape
            property string canEntityType: "SHAPE_USA"
            property int layer_pri: 2
            function setVisibleSlot() {left_panel.usaShapeSLI = true}
            function setInvisibleSlot() {left_panel.usaShapeSLI = false}
            visible: false
        }

        Item {
            id: show_speed
            property string canEntityType: "INFO_SPEED_SHOW"
            property int layer_pri: 2
            function setVisibleSlot() {visible = true}
            function setInvisibleSlot() {visible = false}
            visible: false
        }

        Item {
            id: show_sli_overspeed
            property string canEntityType: "ALERT_SLI_SHOW"
            property int layer_pri: 2
            function setVisibleSlot() {visible = true}
            function setInvisibleSlot() {visible = false}
            visible: false
        }



        Rectangle {
            id: status_panel
            height: 43
            color: "#00000000"
            border.color: "#00000000"
            z: 1

            property int canEntityType: Alert.QtQG
            property int layer_pri: 2
            //function setVisibleSlot(){visible= true; console.log("STATUS")}
            //function setInvisibleSlot(){visible = false; console.log("STATUS OFF")}

            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.top: parent.top
            anchors.topMargin: 8
            visible: true

            Image {
                id: logo
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 0
                clip: true
                visible: true
                fillMode: Image.PreserveAspectCrop
                //source: "images/logo/logo.png"
                source: "images/logo/ME_status_logo.png"
            }


            Row {
                id: left_row
                y: -2
                height: 42
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: logo.left
                anchors.rightMargin: 8
                layoutDirection: Qt.LeftToRight
                spacing: 8

                Rectangle {
                    id: speed
                    width: 42
                    height: 35//speed_value.width
                    color: "#00000000"
                    anchors.top: parent.top
                    anchors.topMargin: 0

                    property string canEntityType: "INFO_VEH_SPEED"
                    property int canEntityArg: 255
                    property int displaySpeed: is_mph? (canEntityArg * 0.621371):canEntityArg;

                    property bool is_mph: false
                    property string unit_str: is_mph? qsTr("MPH") : qsTr("km/h");
                    property bool speed_available: false

                    function setVisibleSlot(arg, is_mph_arg) {
                        is_mph = (is_mph_arg === 1);
                        canEntityArg = arg;
                        speed_available = true;
                    }
                    function setInvisibleSlot() {speed_available = false;}
                    visible: true
                    opacity: isInEdition || (speed_available && show_speed.visible)? 1.0:0.0

                    Text {
                        id: speed_value
                        x: 0
                        color: white
                        text: speed.displaySpeed
                        font.letterSpacing: 0
                        leftPadding: -2
                        anchors.horizontalCenter: parent.horizontalCenter
                        topPadding: -4
                        font.family: intelFont.name
                        font.weight: Font.Medium
                        font.pixelSize: 22

                        onTextChanged: {
                            console.log("speed:"+text+" ts:"+Date.now());
                        }
                    }

                    Text {
                        id: speed_units
                        color: white
                        text: speed.unit_str
                        anchors.bottom: speed_value.bottom
                        anchors.bottomMargin: -11
                        anchors.horizontalCenterOffset: 0
                        font.pixelSize: 14
                        font.capitalization: Font.MixedCase
                        font.family: intelFont.name
                        font.weight: Font.Medium
                        topPadding: 0
                        anchors.horizontalCenter: parent.horizontalCenter

                    }

                }

                Beam {
                    id: alert_hi_low_beam
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    opacity: isInEdition? 1.0:0.0
                }

                Rectangle{
                    id: left_row_slot3
                    width: 42
                    height: 35//speed_value.width
                    color: "#00000000"
                    anchors.top: parent.top

                    Image {
                        id: alert_blinkers
                        property string canEntityType: "ALERT_BLINKERS"
                        property int layer_pri: 1
                        anchors.top: parent.top
                        anchors.topMargin: 0
                        function setVisibleSlot() {visible = true; is_blinking = true}
                        function setInvisibleSlot() {visible = false; is_blinking = false}

                        visible: isInEdition
                        property bool is_blinking: false


                        fillMode: Image.PreserveAspectFit
                        source: "images/status-bar/status_blinker_yellow.png"

                        SequentialAnimation {
                            id: blinkers_animat
                            loops: Animation.Infinite
                            running: alert_blinkers.is_blinking
                            NumberAnimation {
                                target:  alert_blinkers
                                property: "opacity"
                                from: 1.0
                                to: 0.0
                                duration: 404
                                easing.type: Easing.InOutQuad
                            }
                            NumberAnimation {
                                target: alert_blinkers
                                property: "opacity"
                                from: 0.0
                                to: 1.0
                                duration: 404
                                easing.type: Easing.InOutQuad
                            }

                        }
                    }
                }
            }


            Row {
                id: right_row
                height: 42
                layoutDirection: Qt.RightToLeft
                anchors.left: logo.right
                anchors.leftMargin: 8
                spacing: 7
                anchors.right: parent.right
                anchors.rightMargin: 0


                SignedStatus {
                    id: signed_status
                    opacity: isInEdition? 1.0 : 0.0
                }

                Rectangle {
                    id: comm_info
                    width: 23
                    height: 35
                    color: "#00000000"
                    border.color: "#00000000"

                    Image {
                        id: ota
                        anchors.top: parent.top
                        property int layer_pri: 1
                        anchors.topMargin: 0
                        source: "images/status-bar/status_OTA.png"
                        opacity: isInEdition? 1.0 : 0.0
                    }

                    Image {
                        id: gsm_status
                        anchors.top: parent.top
                        property string canEntityType: "INFO_NO_GSM"
                        property int layer_pri: 0
                        anchors.topMargin: 0
                        source: "images/status-bar/status_no_GSM.png"

                        function setVisibleSlot() {opacity = 1.0}
                        function setInvisibleSlot() {opacity = 0.0}
                        opacity: isInEdition? 1.0 : 0.0

                    }
                }

                GpsStatus {
                    id: gps_status
                }


                Rectangle{

                    width: 28
                    height: 35
                    color: "#00000000"
                    border.color: "#00000000"

                    Rectangle {
                        id: status_error

                        width: 28
                        height: 35

                        opacity: isInEdition? 1.0 : 0.0

                        property string canEntityType: "ALERT_ERROR"
                        property int canEntityArg: 0
                        property int layer_pri: 0
                        color: "#00000000"
                        border.color: "#00000000"



                        function setVisibleSlot(Arg){
                            opacity = 1.0
                            canEntityArg = Arg
                        }
                        function setInvisibleSlot(){opacity = 0.0}


                        Text {
                            id: err_code
                            color: white
                            text: status_error.canEntityArg.toString(16).toUpperCase()
                            font.letterSpacing: 0
                            anchors.horizontalCenter: parent.horizontalCenter
                            topPadding: 4
                            font.family: intelFont.name
                            font.weight: Font.Medium
                            font.pixelSize: 24
                        }


                    }

                    Image {
                        id: om_mute

                        property string canEntityType: "OM_MUTE"
                        anchors.top: parent.top
                        anchors.topMargin: 0
                        anchors.right: parent.right
                        property int layer_pri: 1
                        function setVisibleSlot() {opacity = 1.0}
                        function setInvisibleSlot() {opacity = 0.0}
                        source: "images/status-bar/status_mute.png"
                        opacity: isInEdition? 1.0 : 0.0
                    }
                }

            }

        }

        Rectangle {
            id: main_panel
            property int canEntityType: Alert.QtQG
            property int layer_pri: 2
            function setVisibleSlot(){visible= true; console.log("MAIN PANEL")}
            function setInvisibleSlot(){visible = false; console.log("MAIN PANEL OFF")}
            visible: isInEdition

            y: 50
            color: parent.color
            anchors.top: status_panel.bottom
            anchors.topMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0


            //TODO: replace with Image
            Image {
                id: alert_err
                visible: isInEdition
                z: 20
                source: "images/error/error_full_display_general.jpg"
                property string canEntityType: "ALERT_ERROR"
                property int canEntityArg: 0x00
                property int layer_pri: 0
                fillMode: Image.PreserveAspectCrop
                width:324
                height:240
                anchors.bottomMargin: -20
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.leftMargin: -2



                function setVisibleSlot(Arg){
                    visible= true;
                    canEntityArg = Arg
                }
                function setInvisibleSlot(){visible = false}
            }

            IMS_TSR_Items {
                id: left_panel
                width: 50
                color: "#00000000"
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 12
                anchors.top: parent.top
                anchors.topMargin: 12
                anchors.leftMargin: 0
                z: 6
                anchors.left: parent.left

                //NOTE: SLI units are always same as units of SpeedFormat(e.g. UK has EU shape with Mph)
                overSpeeding: show_sli_overspeed.visible

                property int canEntityType: Alert.QtQG
                property int layer_pri: 1
            }

            IMS_SmartADAS_Restricted_Items {
                id: right_panel
                width: 50
                color: "#00000000"
                anchors.top: parent.top
                anchors.topMargin: 12
                z: 6
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 12

                property int canEntityType: Alert.QtQG
                property int layer_pri: 1
                is_in_alert: alert_pdz.visible || alert_rtw_alert.visible ||
                             alert_lldw.visible || alert_rldw.visible ||
                             (alert_hmw_general.visible) // && alert_hmw_general.alert)

            }


            Rectangle {
                id: alert_rtw_alert

                z: 10

                property int layer_pri: 0
                property string canEntityType: "ALERT_RTW_ALERT"

                color: "black"

                anchors.fill: parent


                function setVisibleSlot(Arg){
                    visible = true;
                }
                function setInvisibleSlot(){
                    visible = false;
                }

                Image{

                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    source: "images/traffic-violation/left_TV_RL_big.png"
                }
            }


            Image {
                id: forward_vehicle
                width: 80
                height: 61
                anchors.topMargin: alert_hmw_general.car_margin
                z: 5
                anchors.horizontalCenter: groupCIPV.horizontalCenter
                anchors.top: groupCIPV.top
                source: "images/cars/eyewatch_car_red_hmw-01.png"
                visible: alert_hmw_general.visible //&&(!alert_pdz.visible)
                scale: alert_hmw_general.car_scale
            }

            Item {
                id: groupCIPV
                property int layer_pri: 1
                property int canEntityType: Alert.QtQG
                anchors.rightMargin: 0
                anchors.left: left_panel.right
                anchors.right: right_panel.left
                anchors.bottom: parent.bottom
                anchors.top: parent.top
                anchors.leftMargin: 0
                function setVisibleSlot(){visible = true}
                function setInvisibleSlot(){visible = false}


                Image {
                    id: alert_pdz
                    property string canEntityType: "ALERT_PDZ"
                    property int layer_pri: 0
                    anchors.horizontalCenter: parent.horizontalCenter

                    anchors.top: parent.top
                    anchors.topMargin: -8

                    z: 1
                    source: "images/pdz/main_ped_yellow_old.png"



                    function setVisibleSlot() {visible = true;  console.log("pdz:"+Date.now());}
                    function setInvisibleSlot() {visible = false}

                    /*
                    SequentialAnimation on opacity{
                        loops: Animation.Infinite
                        running: alert_pdz.visible


                        NumberAnimation{
                            from: 1
                            to: 0
                            duration: 300
                            easing.type: Easing.InOutQuad
                        }


                        PauseAnimation {
                            duration: 500
                        }


                        NumberAnimation {
                            from: 0
                            to: 1
                            duration: 300
                            easing.type: Easing.InOutQuad
                        }

                        PauseAnimation {
                            duration: 500
                        }

                        onStopped: {opacity =  1.0}
                    }
                    */

                }


                Item {
                    id: alert_hmw_distance
                    property int layer_pri: 0
                    property string canEntityType: "ALERT_HMW_DISTANCE"

                    anchors.fill: parent
                    function setVisibleSlot(Arg){
                        alert_hmw_general.canEntityArg = Arg
                    }
                    function setInvisibleSlot(){
                        alert_hmw_general.canEntityArg = 0x00
                    }
                }

                HMW {
                    id: alert_hmw_general
                    property int layer_pri: 0
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.top: parent.top
                    anchors.leftMargin: -2
                    playing: !(alert_lldw.visible||alert_rldw.visible||alert_pdz.visible)
                    alert: true
                    is_text_hidden: vsn.visible
                }
            }

            HostCar {
                id: hostCar
                width: 160
                fillMode: Image.PreserveAspectFit
                anchors.bottomMargin: -5
                is_left: alert_lldw.visible
                is_right: alert_rldw.visible
            }

            Item {
                id: groupGAG
                z: 4
                property int canEntityType: Alert.QtQG
                property int layer_pri: 1
                property bool mutexGroup: false
                visible: true

                objectName: "GAG_QtQG"

                function setVisibleSlot() {visible = true}
                function setInvisibleSlot() {visible = false}

                anchors.right: right_panel.left
                anchors.rightMargin: 0
                anchors.left: left_panel.right
                anchors.leftMargin: 0
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0

                Item {
                    id: groupLanes
                    property int canEntityType: Alert.QtQG
                    property int layer_pri: 0
                    property bool mutexGroup: false
                    anchors.topMargin: -5
                    anchors.rightMargin: 32
                    anchors.leftMargin: 32
                    anchors.fill: parent
                    visible: true

                    objectName: "LANES_QtQG"

                    function setVisibleSlot() {visible = true}
                    function setInvisibleSlot() {visible = false}



                    Item {
                        id: groupLanesLeft
                        property int canEntityType: Alert.QtQG
                        property int layer_pri: 0
                        property bool mutexGroup: false
                        anchors.fill: parent

                        objectName: "LANES_LEFT_QtQG"

                        function setVisibleSlot() {visible = true}
                        function setInvisibleSlot() {visible = false}




                        Image {
                            id: alert_ldwoff_left
                            property string canEntityType: "ALERT_LEFT_LDWOFF"
                            property int layer_pri: 0
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                            anchors.top: parent.top

                            function setVisibleSlot() {visible = true}
                            function setInvisibleSlot() {visible = false}


                            fillMode: Image.PreserveAspectCrop
                            source: "images/ldw/left_lane_yellow-01.png"
                        }


                        BlinkingLine {
                            id: alert_lldw
                            playing: !alert_pdz.visible
                            property string canEntityType: "ALERT_LLDW"
                            property int layer_pri: 1
                            anchors.left: parent.left
                            source: "images/ldw/ldw_left-01-01.png"
                        }
                        Image {
                            id: alert_ldwon_left
                            property string canEntityType: "ALERT_LEFT_LDWON"
                            property int layer_pri: 2
                            anchors.bottom: parent.bottom
                            anchors.left: parent.left
                            anchors.top: parent.top

                            function setVisibleSlot() {visible = true}
                            function setInvisibleSlot() {visible = false}


                            fillMode: Image.PreserveAspectCrop
                            source: "images/ldw/normal_lane_left-01.png"
                        }
                    }

                    Item {
                        id: groupLanesRight
                        property int canEntityType: Alert.QtQG
                        property int layer_pri: 0
                        property bool mutexGroup: false
                        anchors.fill: parent

                        objectName: "LANES_RIGHT_QtQG"

                        function setVisibleSlot() {visible = true}
                        function setInvisibleSlot() {visible = false}


                        Image {
                            id: alert_ldwoff_right
                            property string canEntityType: "ALERT_RIGHT_LDWOFF"
                            property int layer_pri: 0
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            anchors.top: parent.top

                            function setVisibleSlot() {visible = true}
                            function setInvisibleSlot() {visible = false}

                            fillMode: Image.PreserveAspectCrop
                            source: "images/ldw/left_lane_yellow-01.png"
                            mirror: true
                            //source: "images/ldw/right_lane-01.png"
                        }


                        BlinkingLine {
                            id: alert_rldw
                            playing: !alert_pdz.visible
                            property string canEntityType: "ALERT_RLDW"
                            property int layer_pri: 1
                            source: "images/ldw/ldw_left-01-01.png"
                            mirror: true
                            //source: "images/ldw/ldw_right-01.png"
                            anchors.right: parent.right
                        }

                        Image {
                            id: alert_ldwon_right
                            property string canEntityType: "ALERT_RIGHT_LDWON"
                            property int layer_pri: 2
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            anchors.top: parent.top

                            function setVisibleSlot() {visible = true}
                            function setInvisibleSlot() {visible = false}

                            fillMode: Image.PreserveAspectCrop
                            source: "images/ldw/normal_lane_left-01.png"
                            mirror: true
                            //source: "images/ldw/normal_lane_right-01.png"
                        }



                    }

                }


            }







        }

        Item {
            id: groupFCW
            objectName: "FCW_QtQG"
            property bool mutexGroup: false
            property int canEntityType: Alert.QtQG
            property int layer_pri: 2 //Decreased from 1 to prevent reinit of SLI and TSR -- TBD add setSuppressed() signal
            z: 15
            anchors.fill: parent
            visible: false


            function setVisibleSlot() {visible = true}
            function setInvisibleSlot() {visible = false}

            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            AnimatedImage {
                id: alert_fcw
                property string canEntityType: "ALERT_FCW"
                property int layer_pri: 1
                anchors.fill: parent

                function setVisibleSlot() {visible = true;  console.log("fcw:"+Date.now());}
                function setInvisibleSlot() {visible = false}
                visible: false
                playing: visible
                anchors.horizontalCenter: parent.horizontalCenter
                source: "images/fcw/main_FCW_big.gif"
            }

            AnimatedImage {
                id: alert_pcw
                property string canEntityType: "ALERT_PCW"
                property int layer_pri: 0
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.fill: parent

                function setVisibleSlot() {visible = true; console.log("pcw:"+Date.now());}
                function setInvisibleSlot() {visible = false}

                visible: false
                playing: visible
                anchors.horizontalCenter: parent.horizontalCenter
                source: "images/pcw/main_PCW_big.gif"
            }
        }

        Rectangle {


            color: "black"
            anchors.fill: parent


            Rectangle {

                id: qr_code_logo_bar

                height: 43
                color: "#ff000000"
                border.color: "#ff000000"
                z: 41

                property int canEntityType: Alert.QtQG
                property int layer_pri: 2

                anchors.right: parent.right
                anchors.rightMargin: 8
                anchors.left: parent.left
                anchors.leftMargin: 8
                anchors.top: parent.top
                anchors.topMargin: 8
                visible: true

                Image {
                    id: logo_qr_code
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    clip: true
                    visible: true
                    fillMode: Image.PreserveAspectCrop
                    //source: "images/logo/logo.png"
                    source: "images/logo/ME_status_logo.png"
                }




            }


            property string canEntityType: "INFO_QRCODE"
            property int layer_pri: 2
            z: 40

            property bool is_up_pressed: false
            property bool is_down_pressed: false
            property bool is_active: false


            Timer{
                id: press2activate_timer
                running: false

                interval: 5000

                onTriggered:
                {
                        qr_code.visible = true;
                        deactivate_timer.start();
                }
            }


            Timer{
                id: deactivate_timer
                running: false

                interval: 20000

                onTriggered:
                {
                    qr_code.visible = false
                }
            }


            function setVisibleSlotStr(Arg) {
                ewinfo.mesn = Arg;
                qr_code_core.request = "sn="+Arg+"&ew_sn="+ewinfo.sn+"&ew_fw="+ewinfo.bin.replace(/\./g,"-")+"&ew_cfg="+ewinfo.cfg.replace(/\./g,"-")+"&snv="+ewinfo.snv
                qr_code.is_active = true;
            }
            function setInvisibleSlot(){qr_code.is_active = false; visible = false; press2activate_timer.stop()}

            id: qr_code

            QRCode{

                id: qr_code_core
                x: (320 - 32)/2
                y: (240 - 50  + qr_code_logo_bar.height)/2
                z: 42

                baseurl: "https://connect.mobileye.com/login?"
                fillColor: "black"

                visible: true


                width: 49
                height: 49
                scale: 3

            }

            EWInfo{
                id: ewinfo
            }








            visible: false
        }



        Rectangle
        {
            id: vsn

            property string canEntityType: "INFO_FAILSAFE"
            property int layer_pri: 2

            z: 10

            function setVisibleSlot(){visible = true;}
            function setInvisibleSlot(){visible = false;}

            anchors.fill: parent

            color: "#00000000"

            visible: isInEdition


            Image
            {
                id: lv_icon
                anchors.top: parent.top
                anchors.topMargin: 135
                anchors.horizontalCenter: parent.horizontalCenter
                visible: vsn.visible

                scale: 0.6

                source: "images/error/icon_eye.png"

            }

            Text {
                id: low_vis_text
                text: "Low Visibility"
                anchors.top: lv_icon.bottom
                anchors.topMargin: -12
                font.pixelSize: 17
                fontSizeMode: Text.FixedSize
                font.family: intelFont.name
                font.weight: Font.Medium
                color: "#fed500"
                visible: vsn.visible
                anchors.horizontalCenter: parent.horizontalCenter
            }

        }


        Rectangle {
            id: discon_panel
            visible: false
            anchors.fill: parent

            property int canEntityType: Alert.QtQG
            property int layer_pri: 0
            color: "#00000000"
            z: 11
            function setVisibleSlot(){visible= true; console.log("LOGO BACKGROUND")}
            function setInvisibleSlot(){visible = false; console.log("LOGO BACKGROUND OFF")}

            antialiasing: true
            smooth: true


            Item {
                id: om_poweroff
                property string canEntityType: "OM_POWEROFF"

                property int layer_pri: 1
                width: 150
                height: 150
                function setVisibleSlot(){visible = true}
                function setInvisibleSlot(){visible = false}



                visible: false
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                //source: "images/error/red_alert-01.png"

                Text {
                    id: om_pwroff_label
                    color: "#111abc"
                    text: qsTr("Power off")
                    anchors.top: parent.bottom
                    anchors.topMargin: -20
                    font.family: intelFont.name
                    font.weight: Font.Bold
                    font.pixelSize: 20
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            Item {
                id: om_keeppwr
                property string canEntityType: "OM_KEEPPWR"

                property int layer_pri: 1
                width: 150
                height: 150
                function setVisibleSlot(){visible = true}
                function setInvisibleSlot(){visible = false}



                visible: false
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                //source: "images/error/red_alert-01.png"

                Text {
                    id: om_keeppwr_label
                    color: "#111abc"
                    text: qsTr("Keep Power On")
                    anchors.top: parent.bottom
                    anchors.topMargin: -20
                    font.family: intelFont.name
                    font.weight: Font.Bold
                    font.pixelSize: 20
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }




            Item {
                id: om_pilot
                property string canEntityType: "OM_PILOT"

                property int layer_pri: 1
                width: 150
                height: 150
                function setVisibleSlot(){visible = true}
                function setInvisibleSlot(){visible = false}



                visible: false
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                //source: "images/error/red_alert-01.png"

                Text {
                    id: om_pilot_label
                    color: "#111abc"
                    text: qsTr("Pilot mode")
                    anchors.top: parent.bottom
                    anchors.topMargin: -20
                    font.family: intelFont.name
                    font.weight: Font.Bold
                    font.pixelSize: 20
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }



            Image {
                id: discon_alert
                property int canEntityType: Alert.ALERT_NOCOM

                property int layer_pri: 0
                width: 150
                height: 150
                function setVisibleSlot(){visible = true}
                function setInvisibleSlot(){visible = false}



                visible: true
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                source: "images/error/red_alert-01.png"

                Text {
                    id: discon_label
                    color: "#111abc"
                    text: qsTr("Disconnected")
                    anchors.top: parent.bottom
                    anchors.topMargin: -20
                    font.family: intelFont.name
                    font.weight: Font.Bold
                    font.pixelSize: 20
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }




        }

        Item {
            id: general_menu_listener
            visible: true
            focus: true
            property int layer_pri: 2
            property real start: 0

            property bool is_initial_input_active: true

            Component.onCompleted:
            {
                console.log("Initial timer started")
                stop_initial_keys.start()
            }

            Timer {
                    id: single_key_gap_timer
                    interval: 100
                    running: false
                    repeat: false

                    property int its_eventkey

                    function registerStartEvent(eventkey)
                    {
                        its_eventkey = eventkey
                        start()
                    }

                    onTriggered: {
                        general_menu_listener.pressed_handler(its_eventkey);
                    }
                }

            Timer {
                    id: volume_mute_timer
                    interval: 500 - single_key_gap_timer.interval
                    running: false
                    repeat: false

                    onTriggered: {
                        if(general_menu_listener.is_volume_enabled)
                        {
                            console.log("Mute pressed")
                            volumeKeySend(Qt.Key_Return)
                            volume_conditional_send_timer.start()
                        }
                    }
                }


            Timer {
                    id: stop_initial_keys
                    interval: 10000
                    running: false
                    repeat: false
                    onTriggered: {
                        console.log("Initial timer stopped")
                        general_menu_listener.is_initial_input_active = false
                    }
                }

            property bool is_volume_enabled: ! (brightness.visible || discon_panel.visible || alert_err.visible || groupFCW.visible)


            Keys.onReturnPressed:
            {

                keyPressedReportSend(event.key)

                press2activate_timer.stop()

                start = 0

                volume_mute_timer.stop()

                if(single_key_gap_timer.running)
                {
                   single_key_gap_timer.stop()
                   double_pressed_handler(event.key)
                }
                else
                {
                   single_key_gap_timer.registerStartEvent(event.key)
                }
                event.accepted = true
            }

            Keys.onUpPressed:
            {
                keyPressedReportSend(event.key)

                start = 0

                volume_mute_timer.stop()

                console.log("Up pressed")

                if(single_key_gap_timer.running)
                {
                   single_key_gap_timer.stop()
                   double_pressed_handler(event.key)
                }
                else
                {
                   single_key_gap_timer.registerStartEvent(event.key)
                }
                event.accepted = true

                volume_menu.timersRestart()
            }

            Keys.onDownPressed:
            {
               keyPressedReportSend(event.key)

               console.log("Down pressed")
               general_menu_listener.is_initial_input_active = false

                console.log("Return pressed")

                if(single_key_gap_timer.running)
                {
                   single_key_gap_timer.stop()
                   double_pressed_handler(event.key)
                }
                else
                {
                   single_key_gap_timer.registerStartEvent(event.key)
                }
                event.accepted = true
                //TODO does not work:
                volume_menu.timersRestart()
            }

            Keys.onReleased:
            {
                keyReleasedReportSend(event.key)

                press2activate_timer.stop()

                general_menu_listener.is_initial_input_active = false;



                start = 0

                volume_mute_timer.stop()

                if(single_key_gap_timer.running)
                {
                   single_key_gap_timer.stop()
                   pressed_handler(single_key_gap_timer.its_eventkey)
                }

                event.accepted = true;
            }


            function double_pressed_handler(eventkey)
            {
                var eventkey1 = single_key_gap_timer.its_eventkey
                var eventkey2 = eventkey

                if (general_menu_listener.is_initial_input_active
                        && ((Qt.Key_Up === eventkey1 && Qt.Key_Return === eventkey2)
                            ||(Qt.Key_Up === eventkey2 && Qt.Key_Return === eventkey1) )
                        )
                {
                    console.log("Print debug messages on LCD")
                    debugMessage("Print Debug On")
                    debugMessagesConnect(true)
                }

                else if (qr_code.is_active
                         && ((Qt.Key_Up === eventkey1 && Qt.Key_Down === eventkey2)
                             ||(Qt.Key_Up === eventkey2 && Qt.Key_Down === eventkey1) )
                         )
                {
                    if(!press2activate_timer.running)
                    {
                        press2activate_timer.start()
                    }
                }
            }



            function pressed_handler(eventkey)
            {
                if (Qt.Key_Up === eventkey ) {
                    console.log("Up released")
                    if(is_volume_enabled)
                    {
                        volume_menu.suppressLimitFail()
                        volumeKeySend(Qt.Key_VolumeUp)
                    }

                    if(brightness.visible)
                    {
                        brightness.up()
                    }
                }
                else if (Qt.Key_Down === eventkey)
                {

                    if(is_volume_enabled)
                    {

                        if(start === 0)
                        {
                            start = Date.now();
                        }


                        if(Date.now() - start < (500 - single_key_gap_timer.interval))
                        {
                                volume_menu.suppressLimitFail() 
                                volumeKeySend(Qt.Key_VolumeDown)
                        }
                        else
                        {
                            volumeKeySend(Qt.Key_Return)
                            volume_conditional_send_timer.start()
                        }


                        if(!volume_mute_timer.running)
                        {
                            volume_mute_timer.start()
                        }
                    }


                    if(brightness.visible)
                    {
                        brightness.down()
                    }
                }
                else if (Qt.Key_Return === eventkey)
                {
                    console.log("Enter released")

                    if(((!speed.speed_available) || (0 === speed.canEntityArg)) && !(1.0 === status_error.opacity && status_error.canEntityArg === 0x20))
                    {
                        brightness.visible = ! brightness.visible
                    }
                    else if (brightness.visible)
                    {
                        brightness.visible = false
                    }
                }
            }


            Timer {
                id: volume_conditional_send_timer

                interval: 60
                running: false
                repeat: false

                onTriggered:
                {
                    if(volume_menu.lowerLimit == 0)
                    {
                        console.log("Mute is permited: send")
                        volumeKeySend(Qt.Key_VolumeMute)
                    }
                    else
                    {
                        volume_menu.invokeLimitFail()
                    }
                }
            }




            function setVisibleSlot() {visible = true}
            function setInvisibleSlot() {visible = false}
        }

        VolumeMenu {
            id: volume_menu
            z:20
            font_family: intelFont.name
            property int layer_pri: 2
            visible: false
        }

        BrightnessMenu
        {
           z: 20
           id: brightness
           font_family: intelFont.name
           visible: false
        }


        Test{
            id: test_group
        }

    }
}





/*##^##
Designer {
    D{i:30;anchors_height:0;anchors_width:0}D{i:28;anchors_x:50;anchors_y:0}D{i:34;anchors_width:110}
D{i:41;anchors_x:0;anchors_y:0}D{i:38;anchors_width:110;anchors_x:9}D{i:42;invisible:true}
}
##^##*/
