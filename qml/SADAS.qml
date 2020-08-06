import QtQuick 2.9

Item {

    id: container
    property var canEntityType;
    width: 110
    height: 110
    visible: true
    //z: sign.z

    property alias source: sign.source

    function setVisibleSlot() {sign.visible = true;}
    function setInvisibleSlot() {sign.visible = false;}

    SideIcon
    {
        id: sign
        y_start_from: 47
    }
}








