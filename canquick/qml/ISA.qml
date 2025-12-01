import QtQuick 2.9

Item {
id: container
property int canEntityArg: 0
property var canEntityType;
property bool overSpeeding: false
property bool usaShape: false
property bool isHighway: false
visible: true

property alias source: sign.source

property alias sign_visible: sign.visible


property url regularSource: "images/left-panel/ISA/bellow_speed.png"
property url overspeedRegularSource: "images/left-panel/ISA/above_speed.png"
property url highwaySource: "images/left-panel/TSR/left_expressway_beg.png"


property url usaShapeSource: "images/left-panel/SLI/left_SLI_rect.png"
property url endRegularSource: "images/left-panel/TSR/black_stripes.png"

property alias isInSlot: sign.isInSlot

property bool endOfLimit: false

property bool supplemented: false

property int maxduration: 0

signal  itemActionDeactivate()


function setVisibleSlot(arg)
{
    canEntityArg = arg;
    sign.visible = true
}

function setInvisibleSlot() {
    sign.visible = false
    console.log("SLI "+canEntityArg+"switched off");
}


Timer {
    id: max_duration_timer
    running: sign.visible && (maxduration > 0)
    interval: maxduration
    onTriggered: {
        container.itemActionDeactivate()
    }
}

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
 
    property bool no_source: false

    visible: false

    quadrant: 2

    Text {
        id: splim
        text: canEntityArg.toString()
        font.pixelSize: 36
        fontSizeMode: Text.FixedSize
        font.family: intelFont.name
        font.weight: Font.Medium
        color: "black"
        visible: parent.visible
        opacity: 1
        scale: 1.6 - (text.length * 0.2)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: 2
        anchors.verticalCenter : parent.verticalCenter
        onTextChanged: {if(sign.visible){sign.visible = false; sign.visible = true;}}
    }

    SequentialAnimation{
        id:over_speeding_animat
        loops: Animation.Infinite
        running: overSpeeding && ! isHighway


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

    source: overSpeeding? overspeedRegularSource : regularSource
   }
   
   //circular
   states: [
       State {
           name: "NoSpeedLimit"; when: isHighway
           PropertyChanges {
               target: sign
               source: highwaySource
           }

           PropertyChanges {
               target: splim
               visible: false
           }
       }
       ,
       State {
           name: "UsaEnd"; when: usaShape && endOfLimit && ! isHighway
           PropertyChanges {
               target: sign
               visible: false
           }
       }
       ,
       State {
           name: "GeneralEnd"; when: !usaShape && endOfLimit && ! isHighway
           PropertyChanges {
               target: sign
               source: endRegularSource
           }
       }
       ,
       State {
           name: "Usa"; when: usaShape && !endOfLimit  && ! isHighway
           PropertyChanges {
               target: sign
               source: usaShapeSource
           }

           PropertyChanges {
               target: splim
               anchors.verticalCenterOffset: 17
           }

           PropertyChanges {
               target: splim
	       font.pixelSize: 30
           }
       }
   ]
}








