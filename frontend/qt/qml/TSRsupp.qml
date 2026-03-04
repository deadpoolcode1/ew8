import QtQuick 2.9

Item {

    id: container
    property var canEntityType;
    visible: true

    property int maxduration: 0

    property alias source: sign.source


    function setVisibleSlot(arg)
    {
        console.log("tsr supplementary: "+arg)
        itsSupp.supp = arg
        sign.visible = true;
    }

    function setInvisibleSlot() {sign.visible = false}


    signal  itemActionDeactivate()


    property bool isInSlot: !visible || sign.isInSlot


    Timer {
        id: max_duration_timer
        running: sign.visible && (maxduration > 0)
        interval: maxduration
        onTriggered: {
            container.itemActionDeactivate()
        }
    }


    z: 4

    SideIcon
    {
        id: sign
        quadrant: 3
        has_supp: true

        Supp
        {
            id: itsSupp
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: parent.bottom
            anchors.topMargin: -20
        }
    }
}








