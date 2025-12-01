import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQml.Models 2.3

SignalTestItem {

   id: upp


   wildcard: "Empty"
   property int  displaySpeed: 0
   visible: true


   Text {
        id: speed_value
        color: icon_color
        z: 40
        text: isEnabled ? displaySpeed.toString() : "X"
        anchors.horizontalCenterOffset: isBig? -1 : 0
        anchors.verticalCenterOffset: isBig? -1 : 0
        anchors.verticalCenter: parent.verticalCenter
        font.letterSpacing: -1.0
        leftPadding: 0
        anchors.horizontalCenter: parent.horizontalCenter
        font.family: intelFont.name
        font.pixelSize: upp.width / 3 + (isBig? 1 : 0)
        font.weight: Font.Light
        visible: isSlotVisible
    }
}
