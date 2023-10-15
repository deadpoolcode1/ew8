import QtQuick 2.9

Rectangle {

    id: container
    property var canEntityType;
    visible: true

    property bool is_error: false
    property  bool is_deactivated: false

    property color white: "#ffffff"
    property color red: "#ef000c"

    width: 47
    height: 20
    color: "#00000000"

    function setVisibleSlot() {
        visible = true;
    }

    function setInvisibleSlot() {
       // visible = false;
    }

    Image{
        id: icon
        //width: 47
        //height: 20
		anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenterOffset: 0
        anchors.verticalCenter: parent.verticalCenter
        source: "images/status-bar/ISA_part_deact.png"
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
    ]

}





