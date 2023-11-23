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

    property int displayedValue: 0

    property bool isDisplayedValueAnImage: false
    property ListModel mnemonicsModel: segments_model

    property int lowerLimit: 0
    property int upperLimit: 5

    property int numOfSegments: (upperLimit - lowerLimit + 1)
    property int usedSegments: (displayedValue - lowerLimit + 1)

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
            text: displayedValue
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
            anchors.topMargin: 0
            anchors.horizontalCenter: parent.horizontalCenter
            source:  mnemonicsModel.get(isDisplayedValueAnImage ? displayedValue : 0).bigIcon
            visible: isDisplayedValueAnImage
        }
    }



    ListModel{
        id: segments_model
        ListElement {property url smallIcon: "images/status-bar/ISA_full_deact.png" ; property int centerOffset: -20;
            property url bigIcon: "images/isa-menu/ISA_full_deact_big.png"}
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
            model: isDisplayedValueAnImage ? mnemonicsModel : numOfSegments



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

                Rectangle {
                    id: progress_point_stick
                    height: 8
                    width: 2
                    anchors.horizontalCenter: progress_segment.right
                    anchors.top:  progress_segment.bottom
                    color: gray
                    z: 0
                }

                Text {
                    id: progress_point_value
                    color: gray
                    property int value: index + lowerLimit
                    text: value
                    anchors.horizontalCenter: progress_point_stick.horizontalCenter
                    anchors.top:  progress_point_stick.bottom
                    anchors.topMargin: progress_point_stick.height
                    font.pixelSize: 18
                    font.family: font_family
                    font.weight: Font.Light
                    visible: ! isDisplayedValueAnImage
                }

                Image {
                    id: progress_point_image

                    property int value: index + lowerLimit

                    source:  isDisplayedValueAnImage ? smallIcon : "images/isa-menu/ISA_full_deact_big.png"

                    anchors.horizontalCenter: progress_point_stick.horizontalCenter
                    anchors.horizontalCenterOffset: isDisplayedValueAnImage ? centerOffset : 0
                    anchors.verticalCenter: progress_point_stick.bottom
                    anchors.verticalCenterOffset: progress_point_stick.height * 3

                    visible: isDisplayedValueAnImage
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
}
