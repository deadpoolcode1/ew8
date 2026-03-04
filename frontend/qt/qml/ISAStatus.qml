import QtQuick 2.9

Rectangle {

    id: container
    property var canEntityType;

    property bool is_error: false
    property  bool is_deactivated: false
    property  bool is_part_deactivated: false
    property  bool is_available: true
    property bool is_forced: false
    property bool is_active: false

    property color white: "#ffffff"
    property color red: "#ef000c"

    visible: to_be_displayed
    property bool to_be_displayed: is_forced || (is_active && is_available)

    width: 47
    height: 20
    color: "#00000000"

    function setVisibleSlot() {
        is_active = true;
    }

    function setInvisibleSlot() {
        is_active = false;
    }

    Image{
        id: icon
        //width: 47
        //height: 20
		anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenterOffset: 0
        anchors.verticalCenter: parent.verticalCenter
        source: "images/status-bar/ISA_full_act.png"
    }


    states: [
        State {
            name: "ISA_ERROR"
            when: is_error
            PropertyChanges {
                 target: icon
                source: "images/status-bar/ISA_error.png"
            }
        }
        ,   State {
            name: "FULL_INACTIVE"
            when: is_deactivated
            PropertyChanges {
                target: icon
                source: "images/status-bar/ISA_full_deact.png"
            }
        }
        ,   State {
            name: "PART_INACTIVE"
            when: is_part_deactivated
            PropertyChanges {
                target: icon
                source: "images/status-bar/ISA_part_deact.png"
            }
        }
    ]

}





