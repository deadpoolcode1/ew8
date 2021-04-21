import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQml.Models 2.3

//Custom modules:
import MyQMLenums 0.1
import builtin.mobileye.QRCode 0.1


ApplicationWindow{
    id: page
    signal keyReportSend(int qtKey);//Qt.Key
    signal volumeKeySend(int qtKey);//Qt.Key
    signal brightnessChanged(int newLevel);

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
                    property string unit_str: is_mph? qsTr("Mph") : qsTr("Km/h");
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
                        color: "#e1f1ff"
                        text: speed.displaySpeed
                        font.letterSpacing: -2.2
                        leftPadding: -2
                        anchors.horizontalCenter: parent.horizontalCenter
                        topPadding: -4
                        font.family: "HindSiliguri"
                        font.pixelSize: 24
                        font.bold: true

                        onTextChanged: {console.log("speed:"+text+" ts:"+Date.now());}
                    }

                    Text {
                        id: speed_units
                        color: "#e1f1ff"
                        text: speed.unit_str
                        anchors.bottom: speed_value.bottom
                        anchors.bottomMargin: -11
                        anchors.horizontalCenterOffset: 0
                        font.pixelSize: 14
                        font.capitalization: Font.MixedCase
                        topPadding: 0
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.family: "HindSiliguri"
                        font.bold: true
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









                Image {
                    id: vsn
                    visible: isInEdition
                    fillMode: Image.PreserveAspectFit
                    source: "images/status-bar/status_low_vis.png"

                    property string canEntityType: "INFO_FAILSAFE"
                    property int layer_pri: 0
                    anchors.top: parent.top
                    anchors.topMargin: 0

                    function setVisibleSlot() {visible = true}
                    function setInvisibleSlot() {visible = false}
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


                Image {
                    id: green_user
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    source: "images/status-bar/status_Signed_in.png"
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
                        property int canEntityArg: 0x00
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
                            color: "#e1f1ff"
                            text: status_error.canEntityArg.toString(16).toUpperCase()
                            font.letterSpacing: -2.2
                            anchors.horizontalCenter: parent.horizontalCenter
                            topPadding: 4
                            font.family: "HindSiliguri"
                            font.pixelSize: 24
                            font.bold: true
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
                    width: 180
                    height: 180
                    anchors.fill: parent
                    playing: !(alert_lldw.visible||alert_rldw.visible||alert_pdz.visible)
                    alert: true
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
                            anchors.fill: parent

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
                            source: "images/ldw/ldw_left-01-01.png"
                        }
                        Image {
                            id: alert_ldwon_left
                            property string canEntityType: "ALERT_LEFT_LDWON"
                            property int layer_pri: 2
                            anchors.fill: parent

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
                            anchors.fill: parent

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
                        }

                        Image {
                            id: alert_ldwon_right
                            property string canEntityType: "ALERT_RIGHT_LDWON"
                            property int layer_pri: 2
                            anchors.fill: parent

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
                    font.bold: true
                    anchors.top: parent.bottom
                    anchors.topMargin: -20
                    font.pixelSize: 20
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
                    font.bold: true
                    anchors.top: parent.bottom
                    anchors.topMargin: -20
                    font.pixelSize: 20
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
                    font.bold: true
                    anchors.top: parent.bottom
                    anchors.topMargin: -20
                    font.pixelSize: 20
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
                    font.bold: true
                    anchors.top: parent.bottom
                    anchors.topMargin: -20
                    font.pixelSize: 20
                }
            }




        }


        Item {
            id: volume_menu_listener
            visible: true
            focus: true
            property int layer_pri: 2
            property real start: 0

            property bool is_volume_enabled: ! (brightness.visible || discon_panel.visible || alert_err.visible || groupFCW.visible)


            Keys.onDownPressed:
            {
                console.log("down pressed")
                if(start === 0)
                {
                    start = Date.now()
                }
                console.log("down pressed at "+start)
                event.accepted = true;

                //TODO does not work:
                volume_menu.timersRestart()
            }

            Keys.onReleased: {
                if (event.key === Qt.Key_Up) {
                    keyReportSend(Qt.Key_Up)

                    console.log("pressed Up")
                    if(is_volume_enabled)
                    {
                      volumeKeySend(Qt.Key_VolumeUp)
                    }

                    if(brightness.visible)
                    {
                        brightness.up()
                    }
                }
                else if (event.key === Qt.Key_Down)
                {
                     keyReportSend(Qt.Key_Down)
                    console.log("pressed Down")
                    if(Date.now() - start < 500)
                    {
                        if(is_volume_enabled)
                        {
                            volumeKeySend(Qt.Key_VolumeDown)
                        }
                    }
                    else
                    {
                        if(is_volume_enabled)
                        {
                        console.log("pressed Mute")
                        volumeKeySend(Qt.Key_VolumeMute)
                        }

                    }

                    if(brightness.visible)
                    {
                        brightness.down()
                    }


                    start = 0
                }
                else if (event.key === Qt.Key_Return)
                {
                     keyReportSend(Qt.Key_Return)
                    console.log("pressed Enter")
                    brightness.visible = ! brightness.visible
                    //NOTE: menu key verification
                    //volumeKeySend(Qt.Key_Return)
                }

                event.accepted = true;


            }

            function setVisibleSlot() {visible = true}
            function setInvisibleSlot() {visible = false}
        }

        VolumeMenu {
            id: volume_menu
            z:20
            property int layer_pri: 2
            visible: false
        }

        BrightnessMenu
        {
           z: 20
           id: brightness
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
