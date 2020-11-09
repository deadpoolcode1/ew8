import QtQuick 2.9

Image {
    id: line
    anchors.fill: parent
    property bool playing

    SequentialAnimation{
        id: animat
        loops: Animation.Infinite
        running: line.visible && line.playing
        NumberAnimation {
            target: line
            property: "opacity"
            from: 1
            to: 0
            duration: 404
            easing.type: Easing.InOutQuad
        }
        NumberAnimation {
            target: line
            property: "opacity"
            from: 0
            to: 1
            duration: 404
            easing.type: Easing.InOutQuad
        }

        onStopped: {line.opacity =  1.0}
    }

    function setVisibleSlot() {visible = true}
    function setInvisibleSlot() {visible = false}

    fillMode: Image.PreserveAspectCrop
}

