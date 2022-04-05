import QtQuick 2.9

Item {
id: container
property int canEntityArg: 0
property var canEntityType;
property bool overSpeeding: false
property bool usaShape: false
visible: true

property alias source: sign.source

property url usaShapeSource: "images/left-panel/SLI/left_SLI_rect.png"
property url endRegularSource: "images/left-panel/TSR/black_stripes.png"

property alias isInSlot: sign.isInSlot

property bool sign_visible: false

property bool endOfLimit: false

property bool supplemented: false

property int maxduration: 0

signal  itemActionDeactivate()


function setVisibleSlot(arg, supp)
{
    console.log("supple: "+supp)
    switch (supp)
    {
    case 0:
    case 21:
        endOfLimit = false;
        canEntityArg = arg;
        sign_visible = true;
        break;
    case 24:
        endOfLimit = true;
        canEntityArg = arg;
        sign_visible = true;
        break;
    default:
    break;
    }

}

function setInvisibleSlot() {sign_visible = false}


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

    visible: sign_visible && !no_source

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
           name: "UsaEnd"; when: usaShape && endOfLimit
           PropertyChanges {
               target: sign
               no_source: true
           }
       }
       ,
       State {
           name: "GeneralEnd"; when: !usaShape && endOfLimit
           PropertyChanges {
               target: sign
               source: endRegularSource
           }
       }
       ,
       State {
           name: "Usa"; when: usaShape && !endOfLimit
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








