import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQml.Models 2.3

//Custom modules:
import MyQMLenums 0.1
import builtin.mobileye.QRCode 0.1

Rectangle {
    id: left_panel

    visible: true

    property int canEntityType: Alert.QtQG
    property int layer_pri: 1
    property bool overSpeeding
    property alias speedLimit: upper_tsr.canEntityArg
    property alias usaShapeSLI: upper_tsr.usaShape

    function setVisibleSlot(){visible = true;}
    function setInvisibleSlot(){visible = false;}

    SLI {
        id: upper_tsr
        canEntityType: "ALERT_SLI"
        property int layer_pri: 0

        overSpeeding: parent.overSpeeding && isInSlot

        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
    }


    Item {
        id: groupBottom
        objectName: "BOTTOM_QtQG"
        property bool mutexGroup: true
        property int layer_pri: 0

        property bool isInSlot:  true

        property int canEntityType: Alert.QtQG

        visible: true

        z: 4

        anchors.left: parent.left
        anchors.rightMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0

        function setVisibleSlot() {visible = true; }
        function setInvisibleSlot() {visible = false}

        DummyItem{
            canEntityType: "ALERT_END_ALL_RESTR"
            property int layer_pri: 1

            anchors.left: parent.left
            anchors.rightMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
        }



        TSR{
            id: alert_no_pass
            property string canEntityType: "ALERT_NO_PASS"
            property int layer_pri: 0
            source: "images/left-panel/TSR/left_nopass_red.png"
        }

        TSR{
            id: alert_no_pass_end
            canEntityType: "ALERT_NO_PASS_END"
            property int layer_pri: 0
            source: "images/left-panel/TSR/left_nopass_end.png"
        }

        TSR{
            id: alert_motorway
            canEntityType: "ALERT_MOTORWAY"
            property int layer_pri: 0
            source: "images/left-panel/TSR/left_motorway_beg.png"
        }

        TSR{
            id: alert_motorway_end
            canEntityType: "ALERT_MOTORWAY_END"
            property int layer_pri: 0
            source: "images/left-panel/TSR/left_motorway_end.png"
        }

        TSR{
            id: alert_expressway
            canEntityType: "ALERT_EXPRESSWAY"
            property int layer_pri: 0
            source: "images/left-panel/TSR/left_expressway_beg.png"
        }

        TSR{
            id: alert_expressway_end
            canEntityType: "ALERT_EXPRESSWAY_END"
            property int layer_pri: 0
            source: "images/left-panel/TSR/left_expressway_end.png"
        }

        TSR{
            id: alert_playground
            canEntityType: "ALERT_PLAYGROUND"
            property int layer_pri: 0
            source: "images/left-panel/TSR/left_playgrond_blue.png"

        }

        TSR{
            id: alert_playground_end
            canEntityType: "ALERT_PLAYGROUND_END"
            property int layer_pri: 0
            source: "images/left-panel/TSR/left_playgrond_blue_end.png"
        }
    }
}
