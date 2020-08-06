import QtQuick 2.9
//import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQml.Models 2.3

//Custom modules:
import MyQMLenums 0.1
import builtin.mobileye.QRCode 0.1

Rectangle {
    id: left_panel
    width: 80
    height: 175

    visible: true
    
    property int canEntityType: Alert.QtQG
    property int layer_pri: 1

    function setVisibleSlot(){visible = true;}
    function setInvisibleSlot(){visible = false;}
    
    
    SLI {
        id: upper_tsr
        canEntityType: "ALERT_SLI"
        property int layer_pri: 0

        anchors.top: parent.top
        anchors.topMargin: -10
        anchors.left: parent.left
        anchors.leftMargin: 0
    }

    Item {
        id: groupBottomTSR
        objectName: "BOTTOM_QtQG"
        property bool mutexGroup: true
        property int layer_pri: 0
        z: 4

        property int canEntityType: Alert.QtQG

        visible: true


        anchors.left: parent.left
        anchors.rightMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0

        function setVisibleSlot() {visible = true}
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
        canEntityType: "ALERT_NO_PASS"
        property int layer_pri: 0
        source: "images/tsr/left_nopass_red.png"

        anchors.left: parent.left
        anchors.rightMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
    }
    

    
    TSR{
        id: alert_motorway
        canEntityType: "ALERT_MOTORWAY"
        property int layer_pri: 0
        source: "images/tsr/left_highway_beg.png"

        anchors.left: parent.left
        anchors.rightMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
    }
    
    TSR{
        id: alert_playground
        canEntityType: "ALERT_PLAYGROUND"
        property int layer_pri: 0
        source: "images/tsr/left_playgrond_blue.png"

        anchors.left: parent.left
        anchors.rightMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
    }
}
}
