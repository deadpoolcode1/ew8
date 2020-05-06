
import QtQuick 2.9


AnimatedImage {

    id: sign
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    visible: true

    property int x_start_from


    SequentialAnimation
    {

        running: sign.visible
        NumberAnimation {
            target: sign
            property: "anchors.horizontalCenterOffset"
            from: x_start_from
            to: 0
            duration: 200
            easing.type: Easing.InOutQuad
        }
        NumberAnimation {
            target: sign
            property: "scale"
            from: 1
            to: 0.7
            duration: 1000
            easing.type: Easing.InOutQuad
        }

    }

    source: "images/sli_signs/sli_bg-01.png"


    scale: 1

    fillMode: Image.PreserveAspectCrop

    rotation: 0;
}
