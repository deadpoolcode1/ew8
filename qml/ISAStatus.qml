import QtQuick 2.9

Rectangle {

    id: container
    property var canEntityType;
    visible: true

    property bool is_error: false
    property  bool is_deactivated: false

    property color white: "#ffffff"
    property color red: "#ef000c"

    width: 40
    height: 16
    color: "#00000000"
    radius: 1
    border.color: white
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 20
    anchors.left: parent.left
    anchors.leftMargin: 8


    function setVisibleSlot() {
        visible = true;
    }

    function setInvisibleSlot() {
        visible = false;
    }

    Image{
        id: icon
        width: 10
        height: 10
        anchors.verticalCenterOffset: 0
        anchors.left: parent.left
        anchors.leftMargin: 2
        anchors.verticalCenter: parent.verticalCenter
        source: "images/Volume_Control_shortcut/mute.png"

    }

    Text
    {
        id: isa_label
        color: white
        text: "ISA"
        topPadding: 0
        font.capitalization: Font.Capitalize
        rightPadding: 0
        leftPadding: 2
        anchors.right: parent.right
        anchors.rightMargin: 3
        font.family: intelFont.name
    }


    Canvas
            {
                id: drawingCanvas
                z: 1
                anchors.fill: parent
                visible: false
                onPaint:
                {
                    var ctx = getContext("2d")

                    ctx.fillStyle = "#00000000"
                    ctx.fillRect(0,0,drawingCanvas.width ,drawingCanvas.height )

                    ctx.lineWidth = 1;
                    ctx.strokeStyle = red
                    ctx.beginPath()
                    ctx.moveTo(0, drawingCanvas.height)
                    ctx.lineTo(drawingCanvas.width , 0)
                    ctx.closePath()
                    ctx.stroke()
                }
            }



    states: [
        State {
            name: "ISA_ERROR"
            when: is_error
            PropertyChanges {
                target: container
                border.color: red
            }

            PropertyChanges {
                target: isa_label
                color: red
            }

            PropertyChanges {
                target: icon
                source: "images/peripheral-test/Peripherals_Result_red.png"
            }
        }
        ,   State {
            name: "FULL_INACTIVE"
            when: is_deactivated
            PropertyChanges {
                target:drawingCanvas
                visible: true
            }
        }
    ]

}





