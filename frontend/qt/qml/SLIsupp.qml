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

property alias isInSlot: sign.isInSlot

property alias sign_visible: sign.visible

property bool endOfLimit: false

property int maxduration: 0

function setVisibleSlot(arg, supp)
{
    console.log("sli supplementary: "+supp)

    itsSupp.supp = supp
    canEntityArg = arg;
    sign.visible = true;
}

function setInvisibleSlot() {sign.visible = false}

signal  itemActionDeactivate()

Timer {
    id: max_duration_timer
    running: sign.visible && (maxduration > 0)
    interval: maxduration
    onTriggered: {
        container.itemActionDeactivate()
    }
}

SideIcon {

    id: sign

    visible: false

    quadrant: 3

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

    source: "images/left-panel/SLI/left_SLI_circ.png"

    has_supp: true

    Supp
    {
        id: itsSupp
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.bottom
        anchors.topMargin: -15
    }

   }


   
   //circular
   states: [
       State {
           name: "Usa"; when: usaShape
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








