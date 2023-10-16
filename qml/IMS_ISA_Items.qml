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
    property alias speedLimit: upper_isa.canEntityArg
    property bool usaShapeSLI: false

    function setVisibleSlot(){visible = true;}
    function setInvisibleSlot(){visible = false;}

    Item {
        id: groupTop
        objectName: "UPPER_QtQG"
        property bool mutexGroup: false
        property int layer_pri: 0

        property bool isInSlot:  true

        property int canEntityType: Alert.QtQG

        visible: true

        z: (alert_rtw_warn.sign_visible? alert_rtw_warn.z : 1) * (upper_isa.sign_visible? upper_isa.z : 1) * (upper_isa_nolim.sign_visible? upper_isa_nolim.z : 1)

        RTW {
            id: alert_rtw_warn
            canEntityType: "ALERT_RTW_WARN"
            property int layer_pri: 0


            function setVisibleSlot() {sign_visible = true}
            function setInvisibleSlot() {sign_visible = false}
        }

        ISA {
            id: upper_isa
            canEntityType: "ALERT_ISA_SPEED"
            property int layer_pri: 2
            usaShape: usaShapeSLI

            overSpeeding: left_panel.overSpeeding && isInSlot

            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
        }

        ISA {
            id: upper_isa_nolim
            canEntityType: "ALERT_ISA_HIGHWAY"
            property int layer_pri: 1
            usaShape: usaShapeSLI

            overSpeeding: false
            isHighway: true

            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
        }
    }




}
