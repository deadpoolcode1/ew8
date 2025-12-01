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
    signal keyPressedReportSend(int qtKey);
    signal keyReleasedReportSend(int qtKey);
    signal volumeKeySend(int qtKey);//Qt.Key
    signal brightnessChanged(int newLevel);
    signal alertsReportSend(bool b1, bool b2, bool b3, bool b4)

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
        color: "#e1f1ff"
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


        anchors.fill: parent
        objectName: "general_panel_root"
        color: "#ff000000"

        width: 320
        height: 240

        SignalTest
        {
            property int layer_pri: 1
            visible: false
            z: 1
        }

        PeripheralTest {
            property int layer_pri: 2
            visible: false
            z: 1
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
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.topMargin: -35
                    font.family: intelFont.name
                    font.weight: Font.Bold
                    font.pixelSize: 20
                }
                Text {
                    id: discon_label_remark
                    color: "#111abc"
                    text: qsTr("(Test Application)")
                    anchors.top: discon_label.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family: intelFont.name
                    font.weight: Font.Bold
                    font.pixelSize: 20
                }
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
