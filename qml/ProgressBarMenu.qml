import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQml.Models 2.3

//Custom modules:
import MyQMLenums 0.1
import builtin.mobileye.QRCode 0.1


Rectangle {
    id: volume_menu
    color: "#191414"

    property alias displayedValue: actual_value.value

    property alias lowerLimit: min_value.value
    property alias upperLimit: max_value.value
    
    property int canEntityType: Alert.QtQG
    width: 320
    height: 240
    z: 14
    visible: isInEdition

    property bool isInEdition: true

    property alias mnemonicIconSlot: value_rectangle

    property string font_family
     
    anchors.fill: parent
    
    Rectangle {
        id: value_rectangle
        height: 40
        color: "#00000000"
        border.color: "#00000000"
        anchors.top: parent.top
        anchors.topMargin: 14
        anchors.right: parent.right
        anchors.rightMargin: 14
        anchors.left: parent.left
        anchors.leftMargin: 14

        Text {
            id: actual_value
            color: "#e1f1ff"
            opacity: 0.9
            property int value: 0
            text: value //.toFixed(0)
            anchors.top: parent.top
            anchors.topMargin: -10
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 54
            font.family: font_family
            font.weight: Font.Light
        }
    }
    Rectangle {
        id: value_progress_used
        height: 8
        width: 292*((actual_value.value - min_value.value)/(max_value.value - min_value.value))
        color: "#e1f1ff"
        opacity: 0.9
        border.color: "#00000000"
        anchors.top: value_rectangle.bottom
        anchors.topMargin: 14
        anchors.left: parent.left
        anchors.leftMargin: 14
     }

    Rectangle {
        id: value_progress_unused
        height: 8
        width: 292 - value_progress_used.width
        color: "#ffffff"
        opacity: 0.3
        border.color: "#00000000"
        anchors.top: value_rectangle.bottom
        anchors.topMargin: 14
        anchors.right: parent.right
        anchors.rightMargin: 14
     }

    Rectangle {
        id: value_boundaries
        height: 14
        color: "#00000000"
        border.color: "#00000000"
        anchors.top: value_progress_used.bottom
        anchors.topMargin: 8
        anchors.right: parent.right
        anchors.rightMargin: 14
        anchors.left: parent.left
        anchors.leftMargin: 14

        Text {
            id: min_value
            color: "#e1f1ff"
            opacity: 0.9
            property int value: 0
            text: value //.toFixed(0)
            anchors.left: parent.left
            anchors.leftMargin: -1
            anchors.top: parent.top
            anchors.topMargin: -4
            font.pixelSize: 19
            font.family: font_family
            font.weight: Font.Medium
        }

        Text {
            id: max_value
            color: "#e1f1ff"
            opacity: 0.9
            property int value: 0
            text: value //.toFixed(0)
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.top: parent.top
            anchors.topMargin: -4
            font.pixelSize: 19
            font.family: font_family
            font.weight: Font.Medium
        }
     }
}
