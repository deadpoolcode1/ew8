import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQml.Models 2.3

//Custom modules:
import MyQMLenums 0.1


Rectangle {
    id: progress_menu
    color: "#191414"

    property alias displayedValue: actual_value.value

    property bool isDisplayedValueAnImage: false

    property alias lowerLimit: min_value.value
    property alias upperLimit: max_value.value

    property int numOfSegments: (max_value.value - min_value.value + 1)
    property int usedSegments: (actual_value.value - min_value.value + 1)

    property int progressBarSegmentFillDuration: 350

    
    property int canEntityType: Alert.QtQG

    property color black: "#ff191414"
    property color gray: "#ff3c4246"
    property color blue: "#ff00bfff"

    property color white: "#ffe1f1ff"


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
        anchors.topMargin: 68
        anchors.right: parent.right
        anchors.rightMargin: 14
        anchors.left: parent.left
        anchors.leftMargin: 14

        Text {
            id: actual_value
            color: blue
            property int value: 0
            text: value //.toFixed(0)
            anchors.top: parent.top
            anchors.topMargin: -10
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 54
            font.family: font_family
            font.weight: Font.Light
            visible: ! isDisplayedValueAnImage
        }

        Image {
            id: actual_value_image

            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter

            source: "images/status-bar/ISA_full_act.png"
            visible: isDisplayedValueAnImage
        }
    }


    ListModel{
        id: segments_model
        /*
        ListElement{property  string canType: "TEST_BRAKES"; property string wildca: "Brake" }
        ListElement{property  string canType: "TEST_WIPERS"; property string wildca: "Whip"}
        ListElement{property  string canType: "TEST_HIGH_BEAM"; property string wildca: "Lights"}
        ListElement{property  string canType: "TEST_BLINKER_LEFT"; property string wildca: "Left"}
        ListElement{property  string canType: "TEST_BLINKER_RIGHT"; property string wildca: "Right" }
        ListElement{property  string canType: "TEST_REVERSE"; property string wildca: "R"}
        */
    }


   function progressBarOffset(offsetSegments)
   {
     var ret = (offsetSegments > 1 ? (progress_bar.width)/(numOfSegments - 1)*(offsetSegments - 1) : 0)
     return ret
   }

    Rectangle {

        id: progress_bar

        z: 0

        anchors.top: value_rectangle.bottom
        anchors.topMargin: 14
        anchors.left: progress_menu.left
        anchors.leftMargin: 30
        width: 260
        height: 25
        color: "#00000000"

        Repeater {
            id: progress_bar_repeater
            model: isDisplayedValueAnImage ? segments_model : numOfSegments



            delegate: Rectangle {

                id: progress_bar_line
                anchors.verticalCenter: progress_bar.verticalCenter
                anchors.left: progress_bar.left
                color: "#00000000"

                Rectangle {
                    id: progress_segment
                    height: 8
                    width: index > 0 ? (progress_bar.width)/(numOfSegments - 1) : 0
                    anchors.verticalCenter: progress_bar_line.verticalCenter
                    anchors.left: progress_bar_line.left
                    anchors.leftMargin: progressBarOffset(index)
                    color: gray
                    z: 0
                }
            }
        }
    }

    onVisibleChanged: {
        if(0 !== progress_behavior.duration)
        {
            progress_behavior.duration = 0
        }
    }

    Timer {
       running: progress_menu.visible
       interval: 100

       onTriggered: {
           if(0 === progress_behavior.duration)
           {
               progress_behavior.duration = progressBarSegmentFillDuration
           }
       }
    }

    property int progressBarColored: progressBarOffset(usedSegments)

    Behavior on  progressBarColored {
            NumberAnimation {id: progress_behavior; duration: 0 }
    }

    Rectangle {
        id: scale_color
        z: 9
        width: progressBarColored
        height: 8

        anchors.verticalCenter: progress_bar.verticalCenter
        anchors.left: progress_bar.left

        color: blue

        opacity: 1.0
    }

    Rectangle {
        id: scale_ball
        z: 10
        width: 25
        height: 25
        radius: 25
        border.width: 3

        color: white
        border.color: blue

        anchors.verticalCenter: progress_bar.verticalCenter
        anchors.horizontalCenter: progress_bar.left
        anchors.horizontalCenterOffset: progressBarColored
        opacity: 1.0
    }

    Rectangle {
        id: progress_bar_line_radius_left
        height: 8
        width: 8
        radius: 8

        z: 0
        anchors.verticalCenter: progress_bar.verticalCenter
        anchors.horizontalCenter: progress_bar.left
        color: blue
    }

    Rectangle {
        id: progress_bar_line_radius_right
        height: 8
        width: 8
        radius: 8

        z: 0

        anchors.verticalCenter: progress_bar.verticalCenter
        anchors.horizontalCenter: progress_bar.right
        color: gray
    }

    Rectangle {
        id: value_boundaries
        height: 14
        color: "#00000000"
        border.color: "#00000000"
        anchors.top: progress_bar.bottom
        anchors.topMargin: 8
        anchors.right: parent.right
        anchors.rightMargin: 14
        anchors.left: parent.left
        anchors.leftMargin: 14

        Text {
            id: min_value
            color: gray
            opacity: 0.9
            property int value: 0
            text: value
            anchors.left: parent.left
            anchors.leftMargin: -1
            anchors.top: parent.top
            anchors.topMargin: -4
            font.pixelSize: 19
            font.family: font_family
            font.weight: Font.Medium
        }

        Text {
            id: max_value
            color: gray
            opacity: 0.9
            property int value: 0
            text: value
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.top: parent.top
            anchors.topMargin: -4
            font.pixelSize: 19
            font.family: font_family
            font.weight: Font.Medium
        }
     }
}
