import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQml.Models 2.3

//Custom modules:
import MyQMLenums 0.1
import builtin.mobileye.QRCode 0.1


Rectangle {
    id: isa_menu
    color: "#191414"

    property int displayedValue
    
    property int canEntityType: Alert.QtQG
    width: 320
    height: 240
    z: 14
    visible: isInEdition

    property bool isInEdition: true

    property alias mnemonicIconSlot: value_rectangle

    property string font_family

    anchors.fill: parent
    
    Rectangle {
        id: value_rectangle
        height: 40
        color: "#00000000"
        border.color: "#00000000"
        anchors.top: parent.top
        anchors.topMargin: 14
        anchors.right: parent.right
        anchors.rightMargin: 14
        anchors.left: parent.left
        anchors.leftMargin: 14

        Image {
            id: isa_done

            objectName: "DONE_ISA"
            //TODO check the values integrity
            property int layer_pri: 1

            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter

            source: "images/status-bar/ISA_full_act.png"
        }

    }

    Rectangle {
        id: value_progress_used
        height: 8
        width: 292*(displayedValue)/2
        color: "#e1f1ff"
        opacity: 0.9
        border.color: "#00000000"
        anchors.top: value_rectangle.bottom
        anchors.topMargin: 14
        anchors.left: parent.left
        anchors.leftMargin: 14
    }

    Rectangle {
        id: value_progress_unused
        height: 8
        width: 292 - value_progress_used.width
        color: "#ffffff"
        opacity: 0.3
        border.color: "#00000000"
        anchors.top: value_rectangle.bottom
        anchors.topMargin: 14
        anchors.right: parent.right
        anchors.rightMargin: 14
    }

    Rectangle {
        id: value_boundaries
        height: 14
        color: "#00000000"
        border.color: "#00000000"
        anchors.top: value_progress_used.bottom
        anchors.topMargin: 8
        anchors.right: parent.right
        anchors.rightMargin: 14
        anchors.left: parent.left
        anchors.leftMargin: 14

        Text {
            id: min_value
            color: "#e1f1ff"
            opacity: 0.9
            property int value: 0
            text: "Inactive"
            anchors.left: parent.left
            anchors.leftMargin: -1
            anchors.top: parent.top
            anchors.topMargin: -4
            font.pixelSize: 10
            font.family: font_family
            font.weight: Font.Medium
        }

        Text {
            id: max_value
            color: "#e1f1ff"
            opacity: 0.9
            property int value: 0
            text: "Active"
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.top: parent.top
            anchors.topMargin: -4
            font.pixelSize: 10
            font.family: font_family
            font.weight: Font.Medium
        }
    }


    
    Rectangle{

        id: isa_version

        color: "#00000000"
        border.color: "#00000000"

        z: 10

        property int canEntityArg: 0x0
        property int canEntityArg1: 0x0
        property int canEntityArg2: 0x0

        anchors.bottom: parent.bottom

        anchors.bottomMargin: 80

        height: 40
        width: 100

        anchors.horizontalCenter: parent.horizontalCenter



        property string canEntityType: "INFO_ISA_VERSION"
        objectName: "ISA_VERSION"
        property int layer_pri: 0



        visible: true

        function setVisibleSlot(arg0,arg1,arg2){visible= true; canEntityArg = arg0; canEntityArg1 = arg1; canEntityArg2 = arg2;}
        function setInvisibleSlot(){visible = false}


        Text {
            id: version_label
            color: "#e1f1ff"
            opacity: 0.9
            text: "ISA VERSION"
            anchors.bottom: version_text.top
            anchors.bottomMargin: 2
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 10
            font.family: font_family
            font.weight: Font.Light
            visible: true
        }

        Text {
            id: version_text
            color: "#e1f1ff"
            opacity: 0.9
            text: isa_version.canEntityArg+"."+isa_version.canEntityArg1+"."+isa_version.canEntityArg2
            anchors.top: parent.top
            anchors.topMargin: -10
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 20
            font.family: font_family
            font.weight: Font.Light
            visible: true
        }

    }





    states: [
        State {
            name: "DEACT"
            when: displayedValue === 0

            PropertyChanges {
                target: isa_done
                source: "images/status-bar/ISA_full_deact.png"
            }
        },
        State {
            name: "PART"
            when: displayedValue === 1

            PropertyChanges {
                target: isa_done
                source: "images/status-bar/ISA_part_deact.png"
            }
        },
        State {
            name: "FULL"
            when: displayedValue === 2

            PropertyChanges {
                target: isa_done
                source: "images/status-bar/ISA_full_act.png"
            }
        }
    ]

}
