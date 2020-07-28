import QtQuick 2.9

Item {
id: container
property int canEntityArg: 0x10
property var canEntityType;
width: 80
height: 80
visible: true

property alias source: sign.source

function setVisibleSlot(arg) {sign.visible = true; canEntityArg = arg;}
function setInvisibleSlot() {sign.visible = false;}

SideIcon {

    id: sign

    x_start_from: 120

    Text {
        text: canEntityArg.toString()
        font.family: "Arial"
        font.pointSize: 18
        font.bold: true
        color: "black"
        visible: parent.visible
        opacity: 1
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter : parent.verticalCenter
        onTextChanged: {sign.visible = false; sign.visible = true;}
    }

    source: "images/sli/sli_bg-01.png"

   }

}








