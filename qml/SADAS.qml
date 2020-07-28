import QtQuick 2.9

Item {

    id: container
    property var canEntityType;
    width: 80
    height: 80
    visible: true

    property alias source: sign.source

    function setVisibleSlot() {sign.visible = true;}
    function setInvisibleSlot() {sign.visible = false;}

    SideIcon
    {
        id: sign
        x_start_from: -120
    }
}








