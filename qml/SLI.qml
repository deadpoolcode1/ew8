import QtQuick 2.9

Item {
id: container
property int canEntityArg: 30
property var canEntityType;
property bool overSpeeding: false
property bool usaShape: false
visible: true

property alias source: sign.source

property alias isInSlot: sign.isInSlot

property alias sign_visible: sign.visible

function setInvisibleSlot() {sign.visible = false}

//  source: "images/shadow-test/s4.png"

SequentialAnimation on z {

    running: sign.visible

    PropertyAction{
        value: 3
    }

    PauseAnimation {
        duration: 1200
    }

    PropertyAction{
        value: 1
    }
}

SideIcon {

    id: sign

    quadrant: 2

    Text {
        id: splim
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

        PauseAnimation {
            duration: 500
        }

        NumberAnimation {
            target: sign
            property: "opacity"
            from: 0
            to: 1
            duration: 300
            easing.type: Easing.InOutQuad
        }

        PauseAnimation {
            duration: 500
        }

        onStopped: {sign.opacity =  1.0}
    }

    source: "images/left-panel/SLI/left_SLI_circ.png"

   }
   
   //circular
   states: [
       State {
           name: "Usa"; when: usaShape
           PropertyChanges {
               target: sign
               source: "images/left-panel/SLI/left_SLI_rect.png"
           }

           PropertyChanges {
               target: splim
               anchors.verticalCenterOffset: 23
           }
       }
   ]
}








