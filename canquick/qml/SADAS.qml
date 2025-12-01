import QtQuick 2.9

Item {

    id: container
    property var canEntityType;
    visible: true
    //z: sign.z

    property alias source: sign.source
    property alias is_in_alert: sign.is_in_alert
    property alias sign_visible: sign.visible

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

    function setVisibleSlot() {sign.visible = true;}
    function setInvisibleSlot() {sign.visible = false;}

    SideIcon
    {
        id: sign
        quadrant: 1
    }
}








