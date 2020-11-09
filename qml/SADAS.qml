import QtQuick 2.9

Item {

    id: container
    property var canEntityType;
    visible: true
    //z: sign.z

    property alias source: sign.source

    function setVisibleSlot() {sign.visible = true;}
    function setInvisibleSlot() {sign.visible = false;}

    SideIcon
    {
        id: sign
        quadrant: 1
    }
}








