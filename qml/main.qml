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
                anchors.top: parent.top
                anchors.topMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.verticalCenter: parent.verticalCenter
                clip: true
                visible: true
                fillMode: Image.PreserveAspectFit
                source: "images/logo/thumbnails.png"
            }

            Row {
                id: left_row
                anchors.right: logo.left
                anchors.rightMargin: -105
                spacing: 10
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 20

                Rectangle {
                    id: speed
                    width: speed_value.width
                    color: "#00000000"
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 5
                    anchors.top: parent.top
                    anchors.topMargin: 5
                    property string canEntityType: "INFO_VEH_SPEED"
                    property int canEntityArg: 0x0
                    property int layer_pri: 0
                    function setVisibleSlot(arg) {canEntityArg = arg; visible = true}
                    function setInvisibleSlot() {visible = false}

                    Text {
                        id: speed_value
                        x: 0
                        color: "#f1e1ff"
                        text: speed.canEntityArg.toFixed(0)
                        topPadding: 0
                        anchors.top: parent.top
                        anchors.topMargin: 0
                        font.family: "HindSiliguri"
                        font.pixelSize: 25
                        font.bold: true
                    }

                    Text {
                        id: speed_units
                        x: 0
                        y: -25
                        color: "#3d667c"
                        text: qsTr("kmp")
                        topPadding: 0
                        anchors.bottom: speed_value.bottom
                        anchors.bottomMargin: -5
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.bold: true
                        font.pixelSize: 8
                    }

                }

                Rectangle {
                    id: groupBeam
                    property string canEntityType: Alert.QtQG
                    property int layer_pri: 0
                    property bool mutexGroup: true
                    width: Math.max(alert_hi_beam.width,alert_low_beam.width)
                    color: "#00000000"
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    function setVisibleSlot() {visible = true}
                    function setInvisibleSlot() {visible = false}

                    visible: true

                    Beam {
                        id: alert_hi_beam
                        is_hi: true
                        property string canEntityType: "ALERT_HI_BEAM"
                        property int layer_pri: 0
                    }

                    Beam {
                        id: alert_low_beam
                        is_hi: false
                        property string canEntityType: "ALERT_LOW_BEAM"
                        property int layer_pri: 1
                    }
                }

                Image {
                    id: alert_blinkers
                    property string canEntityType: "ALERT_BLINKERS"
                    property int layer_pri: 0
                    function setVisibleSlot() {visible = true}
                    function setInvisibleSlot() {visible = false}

                    anchors.verticalCenter: parent.verticalCenter
                    fillMode: Image.PreserveAspectFit
                    source: "images/status_bar/blinker_reminder_white-01.png"
                }

                /*
                Image {
                    id: vsn
                    anchors.verticalCenter: parent.verticalCenter
                    fillMode: Image.PreserveAspectFit
                    source: "images/status_bar/eyewatch_statusbar_low_vision_white-01.png"
                }
                */

            }

            Row {
                id: right_row
                layoutDirection: Qt.RightToLeft
                anchors.left: logo.right
                anchors.leftMargin: -105
                spacing: 10
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 20

                /*
                Image {
                    id: green_user
                    anchors.verticalCenter: parent.verticalCenter
                    source: "images/status_bar/eyewatch_statusbar_user_green-01.png"
                }

                Image {
                    id: player
                    anchors.verticalCenter: parent.verticalCenter
                    source: "images/status_bar/eyewatch_statusbar_dvr-01.png"
                }

                Image {
                    id: gps
                    anchors.verticalCenter: parent.verticalCenter
                    source: "images/status_bar/eyewatch_statusbar_gps-01.png"
                }

                Image {
                    id: gsm
                    anchors.verticalCenter: parent.verticalCenter
                    source: "images/status_bar/eyewatch_statusbar_gsm-01.png"
                }
                */

            }

        }

        Rectangle {
            id: main_panel
            property int canEntityType: Alert.QtQG
            property int layer_pri: 2
            function setVisibleSlot(){visible= true; console.log("MAIN PANEL")}
            function setInvisibleSlot(){visible = false; console.log("MAIN PANEL OFF")}


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
            visible: true

            //TODO: replace with Image
            Rectangle {
                id: alert_err
                width: 100
                height: 100
                visible: false
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                //source: "qrc:/qtquickplugin/images/template_image.png"
                property string canEntityType: "ALERT_ERROR"
                property int canEntityArg: 0x00
                property int layer_pri: 1

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

            Rectangle {
                id: left_panel
                width: 50
                color: "#00000000"
                z: 7
                visible: true
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0

                property int canEntityType: Alert.QtQG
                property int layer_pri: 1
                function setVisibleSlot(){visible = true;}
                function setInvisibleSlot(){visible = false;}


                SLI {
                    id: upper_tsr
                    canEntityType: "ALERT_SLI"
                    property int layer_pri: 0
                }

                TSR{
                    id: alert_no_pass
                    canEntityType: "ALERT_NO_PASS"
                    property int layer_pri: 0
                    source: "images/tsr/left_nopass_red.png"
                }

                DummyItem{
                    canEntityType: "ALERT_END_ALL_RESTR"
                    property int layer_pri: 1
                }

                TSR{
                    id: alert_motorway
                    canEntityType: "ALERT_MOTORWAY"
                    property int layer_pri: 0
                    source: "images/tsr/left_highway_beg.png"
                }

                TSR{
                    id: alert_playground
                    canEntityType: "ALERT_PLAYGROUND"
                    property int layer_pri: 0
                    source: "images/tsr/left_motorway_beg.png"
                }
            }

            IMS_SmartADAS_Restricted_Items {
                id: right_panel
                width: 50
                color: "#00000000"
                z: 6
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0

                property int canEntityType: Alert.QtQG
                property int layer_pri: 1
            }

            Image {
                id: vehicle_img
                x: 95
                y: -5
                z: 5
                anchors.horizontalCenter: groupCIPV.horizontalCenter
                anchors.top: groupCIPV.top
                anchors.topMargin: alert_hmw_general.car_margin
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


                    AnimatedImage {
                        id: alert_pdz
                        playing: visible
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
                    alert: false
                }




            }

            GreyCar {
                id: greyCar
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

        Image {
            id: logo_panel
            visible: true
            anchors.fill: parent

            property int canEntityType: Alert.QtQG
            property int layer_pri: 0
            z: 11
            function setVisibleSlot(){visible= true; console.log("LOGO BACKGROUND")}
            function setInvisibleSlot(){visible = false; console.log("LOGO BACKGROUND OFF")}

            /*
            gradient: Gradient {
                GradientStop { position: 0.0; color: "white" }
                GradientStop { position: 1.0; color: "#56abf1"}

            }
*/


            antialiasing: true
            smooth: true

            source: "images/bg/gradient_linear_24_16bit_2.png"

            Image {
                id: grand_logo
                property int canEntityType: Alert.ALERT_NOCOM

                property int layer_pri: 0
                function setVisibleSlot(){visible= true; console.log("LOGO")}
                function setInvisibleSlot(){visible = false; console.log("LOGO OFF")}



                visible: true
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                source: "images/logo/eyewatch_logo_transparent-01.png"
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
                visible: true
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

                function setVisibleSlot() {visible = true}
                function setInvisibleSlot() {visible = false}

                visible: true
                playing: visible
                anchors.horizontalCenter: parent.horizontalCenter
                source: "images/pcw/main_PCW_big.gif"
            }
        }


    }

}





/*##^##
Designer {
    D{i:30;anchors_height:0;anchors_width:0}D{i:28;anchors_x:50;anchors_y:0}D{i:34;anchors_width:110}
D{i:41;anchors_x:0;anchors_y:0}D{i:38;anchors_width:110;anchors_x:9}D{i:42;invisible:true}
}
##^##*/
