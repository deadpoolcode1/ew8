import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQml.Models 2.3

//Custom modules:
import MyQMLenums 0.1
import builtin.mobileye.QRCode 0.1

AnimatedImage {
    id: hostCar
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.horizontalCenterOffset: 0
    fillMode: Image.PreserveAspectCrop
    visible: groupGAG.visible || groupCIPV.visible
    playing: visible
    z: 6
    anchors.bottom: parent.bottom
    source: "images/cars/grey_car_bright.png"

    property int move_offset: 41

    property bool is_left: false
    property bool is_right: false

    states:[
        State {
            name: "Left"; when: is_left && !is_right
            PropertyChanges {
                target: hostCar
                anchors.horizontalCenterOffset: - move_offset
            }
        }
        , State {
            name: "Center"; when: is_left === is_right
            PropertyChanges {
                target: hostCar
                anchors.horizontalCenterOffset: 0
            }
        }
        , State {
            name: "Right"; when: is_right && !is_left
            PropertyChanges {
                target: hostCar
                anchors.horizontalCenterOffset: move_offset
            }
        }

    ]

    transitions: [ 
        Transition {
            from: "*"; to: "Left";
            NumberAnimation {target: hostCar; properties: "anchors.horizontalCenterOffset"; duration: 200; easing.type: Easing.InOutQuad }
        }
        ,Transition {
            from: "*"; to: "Right";
            NumberAnimation {target: hostCar; properties: "anchors.horizontalCenterOffset"; duration: 200; easing.type: Easing.InOutQuad }
        }
        ,Transition {
            from: "*"; to: "Center";
            NumberAnimation {target: hostCar; properties: "anchors.horizontalCenterOffset"; duration: 600; easing.type: Easing.InOutQuad }
        }
    ]
}
