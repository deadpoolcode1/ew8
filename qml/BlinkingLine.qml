import QtQuick 2.9

AnimatedImage {
    id: line
    anchors.fill: parent

    SequentialAnimation{
        running: line.visible
        loops: Animation.Infinite
        NumberAnimation {
            target: line
            property: "opacity"
            from: 0
            to: 1
            duration: 300
            easing.type: Easing.InOutQuad
        }
        NumberAnimation {
            target: line
            property: "opacity"
            from: 1
            to: 0
            duration: 200
            easing.type: Easing.InOutQuad
        }
    }

    function setVisibleSlot() {visible = true}
    function setInvisibleSlot() {visible = false}

    fillMode: Image.PreserveAspectCrop
}

