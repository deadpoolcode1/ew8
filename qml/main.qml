import QtQuick 2.9
//import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQml.Models 2.3

//Custom modules:
import MyQMLenums 0.1
import builtin.mobileye.QRCode 0.1

ApplicationWindow{
    id: page
    signal itemSelfDeactivated(var canEntityType, string _objectName)
    signal volumeKeySend(int qtKey);//Qt.Key

    property bool isInEdition: false

    width: 320
    height: 240
    objectName: "AppWindow"

    visible: true

    Rectangle {
        id: general_panel
        property int canEntityType: Alert.QtQG
        property int layer_pri: 0
        visible: true
        color: "#000000"

        anchors.fill: parent
        //source: "images/bg/eyewatch_car_lighter_bg-01.png"
        objectName: "general_panel_root"

        width: 320
        height: 240

        Rectangle {
            id: status_panel
            height: 50
            color: "#00000000"
            z: 1

            property int canEntityType: Alert.QtQG
            property int layer_pri: 2
            //function setVisibleSlot(){visible= true; console.log("STATUS")}
            //function setInvisibleSlot(){visible = false; console.log("STATUS OFF")}

            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0
            visible: true

            Image {
                id: logo
                width: 48
                height: 32
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                clip: true
                visible: true
                fillMode: Image.PreserveAspectCrop
                source: "images/logo/ME_logo_white.png"
            }

            Rectangle {
                id: speed
                width: 42//speed_value.width
                color: "#00000000"
                anchors.horizontalCenterOffset: 26
                anchors.horizontalCenter: parent.left
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 5
                anchors.top: parent.top

                anchors.topMargin: 5
                property string canEntityType: "INFO_VEH_SPEED"
                property int canEntityArg: 0
                property int layer_pri: 0
                x: -1
                y: 5
                function setVisibleSlot(arg) {canEntityArg = arg; opacity = 1.0}
                function setInvisibleSlot() {opacity = 0.0}
                visible: true
                opacity: isInEdition? 1.0:0.0

                Text {
                    id: speed_value
                    x: 0
                    color: "#f1e1ff"
                    text: speed.canEntityArg.toFixed(0)
                    topPadding: 0
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family: "HindSiliguri"
                    font.pixelSize: 20
                    font.bold: true

                    onTextChanged: {console.log("speed:"+text+" ts:"+Date.now());}
                }

                Text {
                    id: speed_units
                    color: "#e1f1ff"
                    text: qsTr("Km/h")
                    anchors.bottom: speed_value.bottom
                    anchors.bottomMargin: -5
                    anchors.horizontalCenterOffset: 0
                    font.pixelSize: 9
                    font.capitalization: Font.MixedCase
                    topPadding: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family: "HindSiliguri"
                    font.bold: true
                }

            }

            Row {
                id: left_row
                layoutDirection: Qt.RightToLeft
                anchors.right: logo.left
                anchors.rightMargin: 10
                spacing: 10
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 52

                Image {
                    id: vsn
                    width: 15
                    height: 18
                    opacity: isInEdition? 1.0:0.0
                    anchors.verticalCenter: parent.verticalCenter
                    fillMode: Image.PreserveAspectFit
                    source: "images/status_bar/status_low_vis.png"

                    property string canEntityType: "INFO_FAILSAFE"
                    property int layer_pri: 0

                    function setVisibleSlot() {opacity = 1.0}
                    function setInvisibleSlot() {opacity = 0.0}  
                }



                Image {
                    id: alert_blinkers
                    property string canEntityType: "ALERT_BLINKERS"
                    property int layer_pri: 0
                    width: 25
                    height: 18
                    function setVisibleSlot() {opacity = 1.0; is_blinking = true}
                    function setInvisibleSlot() {opacity = 0.0; is_blinking = false}

                    opacity: isInEdition? 1.0:0.0
                    property bool is_blinking: false

                    visible: true

                    anchors.verticalCenter: parent.verticalCenter
                    fillMode: Image.PreserveAspectFit
                    source: "images/status_bar/blinker_reminder_blue-01.png"

                    SequentialAnimation {
                        id: blinkers_animat
                        loops: Animation.Infinite
                        running: alert_blinkers.is_blinking
                        NumberAnimation {
                            target:  alert_blinkers
                            property: "opacity"
                            from: 1.0
                            to: 0.0
                            duration: 300
                            easing.type: Easing.InOutQuad
                        }
                        NumberAnimation {
                            target: alert_blinkers
                            property: "opacity"
                            from: 0.0
                            to: 1.0
                            duration: 200
                            easing.type: Easing.InOutQuad
                        }

                    }


                }


                Beam {
                    id: alert_hi_beam
                    property string canEntityType: "ALERT_HI_BEAM"
                    property int layer_pri: 0
                    opacity: isInEdition? 1.0:0.0
                }





            }

            Row {
                id: right_row
                layoutDirection: Qt.RightToLeft
                anchors.left: logo.right
                anchors.leftMargin: 10
                spacing: 10
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 20


                Image {
                    id: green_user
                    anchors.verticalCenter: parent.verticalCenter
                    source: "images/status_bar/eyewatch_statusbar_user_green-01.png"
                    opacity: 0
                }

                Image {
                    id: gsm
                    width: 18
                    anchors.verticalCenter: parent.verticalCenter
                    source: "images/status_bar/status_no_GSM.png"
                     opacity: 0
                }

                Image {
                    id: gps
                    width: 18
                    anchors.verticalCenter: parent.verticalCenter
                    source: "images/status_bar/status_no_GPS.png"
                    opacity: 0
                }

                Image {
                    id: ota
                    anchors.verticalCenter: parent.verticalCenter
                    source: "images/status_bar/status_OTA.png"
                    opacity: 0
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
            color: "#00000000"
            anchors.top: status_panel.bottom
            anchors.topMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0


            //TODO: replace with Image
            Rectangle {
                id: alert_err
                width: 100
                height: 100
                visible: false
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                //source: "images/error/red_alert-01.png"
                property string canEntityType: "ALERT_ERROR"
                property int canEntityArg: 0x00
                property int layer_pri: 0

                function setVisibleSlot(Arg){
                    visible= true;
                    canEntityArg = Arg
                }
                function setInvisibleSlot(){visible = false}

                Text {
                    id: err_code
                    width: 40
                    height: 20
                    text: "ER-"+parent.canEntityArg.toString(16).toUpperCase()
                    horizontalAlignment: Text.AlignHCenter
                    style: Text.Sunken
                    font.weight: Font.Medium
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                    font.pixelSize: 12
                }

            }

            IMS_TSR_Items {
                id: left_panel
                width: 50
                color: "#00000000"
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 15
                anchors.top: parent.top
                anchors.topMargin: 0
                anchors.leftMargin: 0
                z: 6
                anchors.left: parent.left

                property int canEntityType: Alert.QtQG
                property int layer_pri: 1
            }

            IMS_SmartADAS_Restricted_Items {
                id: right_panel
                width: 50
                color: "#00000000"
                anchors.top: parent.top
                anchors.topMargin: 0
                z: 6
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 15

                property int canEntityType: Alert.QtQG
                property int layer_pri: 1
            }

            Image {
                id: vehicle_img
                x: 95
                y: -5
                width: 80
                height: 61
                anchors.topMargin: alert_hmw_general.car_margin
                z: 5
                anchors.horizontalCenter: groupCIPV.horizontalCenter
                anchors.top: groupCIPV.top
                source: "images/cars/eyewatch_car_red_hmw-01.png"
                visible: alert_hmw_general.visible&&(!alert_pdz.visible)
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



                Item {
                    id: groupPdzHmwDistance
                    property int canEntityType: Alert.QtQG
                    property int layer_pri: 1
                    property bool mutexGroup: false
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    z: 1
                    visible: true
                    //anchors.fill: parent

                    objectName: "GAG_QtQG"

                    function setVisibleSlot() {visible = true}
                    function setInvisibleSlot() {visible = false}


                    Image {
                        id: alert_pdz
                        property string canEntityType: "ALERT_PDZ"
                        property int layer_pri: 0
                        anchors.horizontalCenter: parent.horizontalCenter

                        anchors.top: parent.top
                        anchors.topMargin: 0

                        z: 1
                        source: "images/pdz/main_ped_yellow_old.png"



                        function setVisibleSlot() {visible = true}
                        function setInvisibleSlot() {visible = false}

                    }

                    Item {
                        id: alert_hmw_distance
                        property int layer_pri: 1
                        property string canEntityType: "ALERT_HMW_DISTANCE"

                        anchors.fill: parent
                        function setVisibleSlot(Arg){
                            alert_hmw_general.canEntityArg = Arg
                        }
                        function setInvisibleSlot(){
                            alert_hmw_general.canEntityArg = 0x00
                        }
                    }

                }

                HMW {
                    id: alert_hmw_general
                    property int layer_pri: 1
                    anchors.fill: parent
                    playing: !(alert_lldw.visible||alert_rldw.visible||alert_pdz.visible)
                    alert: true
                }




            }

            GreyCar {
                id: greyCar
                width: 133
                height: 51
                anchors.bottomMargin: -24
                anchors.horizontalCenterOffset: 0
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

                            onVisibleChanged: {if(visible) greyCar.moveLeft(); else greyCar.moveLeftReset();}
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
                            source: "images/ldw/right_lane-01.png"
                        }


                        BlinkingLine {
                            id: alert_rldw
                            playing: !alert_pdz.visible
                            property string canEntityType: "ALERT_RLDW"
                            property int layer_pri: 1
                            source: "images/ldw/ldw_right-01.png"
                            onVisibleChanged: {if(visible) greyCar.moveRight(); else greyCar.moveRightReset();}
                        }

                        Image {
                            id: alert_ldwon_right
                            property string canEntityType: "ALERT_RIGHT_LDWON"
                            property int layer_pri: 2
                            anchors.fill: parent

                            function setVisibleSlot() {visible = true}
                            function setInvisibleSlot() {visible = false}

                            fillMode: Image.PreserveAspectCrop
                            source: "images/ldw/normal_lane_right-01.png"
                        }



                    }

                }


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

            //source: "images/bg/gradient_linear_24_16bit_2.png"

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
            id: groupFCW
            objectName: "FCW_QtQG"
            property bool mutexGroup: false
            property int canEntityType: Alert.QtQG
            property int layer_pri: 1
            z: 10
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

                function setVisibleSlot() {visible = true}
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

                function setVisibleSlot() {visible = true; console.log("pdz:"+Date.now());}
                function setInvisibleSlot() {visible = false}

                visible: false
                playing: visible
                anchors.horizontalCenter: parent.horizontalCenter
                source: "images/pcw/main_PCW_big.gif"
            }
        }

        Item {
            id: menu_listener
            visible: true
            focus: true
            property int layer_pri: 2
            property real start: 0


            Keys.onDownPressed:
            {
                console.log("down pressed")
                if(start === 0)
                {
                    start = Date.now()
                }
                console.log("down pressed at "+start)
                event.accepted = true;

                volume_done_timer.restart()
                volume_fail_timer.restart()
            }

            Keys.onReleased: {
                if (event.key === Qt.Key_Up) {
                    console.log("pressed Up")
                    volumeKeySend(Qt.Key_VolumeUp)
                }
                else if (event.key === Qt.Key_Down)
                {
                    if(Date.now() - start < 500)
                    {
                        console.log("pressed Down")
                        volumeKeySend(Qt.Key_VolumeDown)
                    }
                    else
                    {
                        console.log("pressed Mute")
                        volumeKeySend(Qt.Key_VolumeMute)
                    }
                    start = 0
                }
                else if (event.key === Qt.Key_Return)
                {
                    console.log("pressed Enter")
                }

                event.accepted = true;


            }

            function setVisibleSlot() {visible = true}
            function setInvisibleSlot() {visible = false}
        }

        Rectangle {
            id: volume_menu
            color: "#191414"

            property int canEntityType: Alert.QtQG
            property int layer_pri: 0
            z: 13
            function setVisibleSlot(){visible= true}
            function setInvisibleSlot(){visible = false}
            visible: false



            anchors.fill: parent

            Rectangle{
                id: volume_reqfail
                property int canEntityType: Alert.ALERT_REQFAIL
                objectName: "REQFAIL_VOLUME"
                property int layer_pri: 0
                color: "orange"

                width: 100
                height: 100
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                function setVisibleSlot(arg){visible = true}
                function setInvisibleSlot(){visible = false}

                Timer {
                    id: volume_reqfail_timer
                    running: volume_reqfail.visible
                    interval: 300
                    onTriggered: {
                        itemSelfDeactivated(Alert.ALERT_REQFAIL ,"REQFAIL_VOLUME")
                    }
                }
            }




            Rectangle{
                id: volume_fail
                property string canEntityType: "VOLUME_FAIL"
                objectName: "FAIL_VOLUME"
                property int layer_pri: 0
                color: "red"

                width: 100
                height: 100
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                function setVisibleSlot(arg){visible = true}
                function setInvisibleSlot(){visible = false}

                Timer {
                    id: volume_fail_timer
                    running: volume_fail.visible
                    interval: 500
                    onTriggered: {
                        itemSelfDeactivated("VOLUME_FAIL","FAIL_VOLUME")
                    }
                }
            }


            Item {
                id: volume_done
                property string canEntityType: "VOLUME_DONE"
                objectName: "DONE_VOLUME"
                property int canEntityArg: 0x0
                property int layer_pri: 1

                function setVisibleSlot(arg){visible= true; canEntityArg = arg;}
                function setInvisibleSlot(){visible = false}

                width: 100
                height: 100
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter


                Text {
                    id: volume_value
                    color: "white"
                    text: volume_done.canEntityArg.toFixed(0)
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    topPadding: 0
                    font.family: "HindSiliguri"
                    font.pixelSize: 50
                    font.bold: true
                }

                Timer {
                    id: volume_done_timer
                    running: volume_done.visible
                    interval: 1000
                    onTriggered: {
                        itemSelfDeactivated("VOLUME_DONE","DONE_VOLUME")
                    }
                }
            }
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
