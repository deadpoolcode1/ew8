import QtQuick 2.9

Item {

    id: container
    property var canEntityType;
    visible: true

    property alias source: sign.source

    function setVisibleSlot() {sign.visible = true;}
    function setInvisibleSlot() {sign.visible = false;}

    property bool isInSlot: !visible || sign.isInSlot

    z: 4

    SideIcon
    {
        id: sign
        quadrant: 3
    }
}








