
import QtQuick 2.9


AnimatedImage {

    id: sign
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    visible: true
    property alias enterRunning: enter_animat.running

    property int y_start_from

    enterRunning: visible

    z: 4


    SequentialAnimation{
        id: enter_animat
    ParallelAnimation
    {


        PauseAnimation {
            duration: 30
        }
        NumberAnimation {
            target: sign
            property: "anchors.verticalCenterOffset"
            from: y_start_from
            to: 0
            duration: 1500
            easing.type: Easing.InOutQuad
        }
        NumberAnimation {
            target: sign
            property: "scale"
            from: 1
            to: 0.6
            duration: 1000
            easing.type: Easing.InOutQuad
        }


    }

    }



    scale: 1

    fillMode: Image.PreserveAspectCrop

    rotation: 0;
}
