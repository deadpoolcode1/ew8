import QtQuick 2.9

Item {

    id: container
    property int canEntityArg: 0x10
    property var canEntityType;
    width: 80
    height: 80
    visible: true

    property bool displayed: false



    function setVisibleSlot(arg) {sign.visible = true; }
    function setInvisibleSlot() {sign.visible = false;}

    AnimatedImage{

        id: sign
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        visible: true


        SequentialAnimation
        {

            running: sign.visible
            NumberAnimation {
                target: sign
                property: "anchors.horizontalCenterOffset"
                from: -80
                to: 0
                duration: 200
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: sign
                property: "scale"
                from: 1.5
                to: 1
                duration: 1000
                easing.type: Easing.InOutQuad
            }

        }

        property int stage: 0
        source: "images/sli_signs/sli_50-01.png"


        scale: 1.5

        fillMode: Image.PreserveAspectCrop

        rotation: 0;
    }
}








