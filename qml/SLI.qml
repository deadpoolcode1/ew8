import QtQuick 2.9

Item {
id: container
property int canEntityArg: 0x10
property var canEntityType;
property bool overSpeeding: false
property bool usaShape: false
width: 110
height: 110
visible: true

property alias source: sign.source

function setVisibleSlot(arg) {canEntityArg = arg; sign.visible = true}
function setInvisibleSlot() {sign.visible = false}

NumberAnimation on z {
    running: sign.visible
    from: 5
    to: 3
    duration: 1500
    easing.type: Easing.InOutQuad
}

SideIcon {

    width: 146
    height: 146

    id: sign

    y_start_from: 47

    Text {
        text: canEntityArg.toString()
        font.pixelSize: 40
        fontSizeMode: Text.FixedSize
        font.family: "Arial"
        font.bold: true
        color: "black"
        visible: parent.visible
        opacity: 1
        scale: 1.6 - (text.length * 0.2)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter : parent.verticalCenter
        onTextChanged: {if(sign.visible){sign.visible = false; sign.visible = true;}}
    }

    SequentialAnimation{
        id:over_speeding_animat
        loops: Animation.Infinite
        running: overSpeeding
        NumberAnimation {
            target: sign
            property: "opacity"
            from: 1
            to: 0
            duration: 300
            easing.type: Easing.InOutQuad
        }
        NumberAnimation {
            target: sign
            property: "opacity"
            from: 0
            to: 1
            duration: 200
            easing.type: Easing.InOutQuad
        }

        onStopped: {sign.opacity =  1.0}
    }

    source: "images/sli/white_circular_sign-01.png"

   }

}








