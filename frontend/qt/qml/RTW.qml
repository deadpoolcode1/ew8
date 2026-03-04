import QtQuick 2.9

Item {
id: container
property var canEntityType;
visible: true

property alias isInSlot: sign.isInSlot

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

SideIcon {

    id: sign

    quadrant: 2

    source: "images/traffic-violation/left_TV_RL_small.png"

   }
}








