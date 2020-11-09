
import QtQuick 2.9


AnimatedImage {

    id: sign
    visible: true

    property int y_start_from
    property int x_start_from

    property int quadrant

    property bool is_top: quadrant < 3
    property double target_scale: 0.732

    property int targetWidthMargin: - (width * (1 - target_scale) / 2)
    property int targetHeightMargin: - (height * (1 - target_scale) / 2)




    property bool isInSlot: false

    y_start_from: is_top? 12 : (165 - 112 - 12)
    anchors.topMargin: 12
    anchors.bottomMargin: 165 - 112 - 12
    anchors.rightMargin: 0
    anchors.leftMargin: 0

    scale: 1

    states: [
         State {name: "I"; when:  quadrant === 1
                PropertyChanges{
                  target: sign
                  anchors.top: parent.top
                  anchors.right: parent.right
                }
            }
        ,State {name: "II"; when:  quadrant === 2
            PropertyChanges{
              target: sign
              anchors.top: parent.top
              anchors.left: parent.left
            }
        }
        ,State {name: "III"; when:  quadrant === 3
                PropertyChanges{
                  target: sign
                  anchors.bottom: parent.bottom
                  anchors.left: parent.left
                }
            }
        ,State {name: "IV"; when: quadrant === 4
                PropertyChanges{
                  target: sign
                  anchors.bottom: parent.bottom
                  anchors.right: parent.right
                }
            }
    ]

    onVisibleChanged:
    {
            scale = 1
            anchors.topMargin = y_start_from
            anchors.bottomMargin = y_start_from
            anchors.leftMargin = 0
            anchors.rightMargin = 0
    }


    SequentialAnimation  {

        //NOTE: next line used in edition mode
        //running: false
        running: sign.visible

        id: enter_animat

        PauseAnimation {
            duration: 1000
        }

        ParallelAnimation
        {
            PropertyAction {
              target: sign
              property: "isInSlot"
              value: false
            }

            NumberAnimation {
                target: sign
                properties: "anchors.topMargin, anchors.bottomMargin"
                from: y_start_from
                to: targetHeightMargin
                duration: 500
                easing.type: Easing.OutQuad
            }

            NumberAnimation {
                target: sign
                properties: "anchors.leftMargin, anchors.rightMargin"
                from: 0
                to: targetWidthMargin
                duration: 500
                easing.type: Easing.OutQuad
            }

            NumberAnimation {
                target: sign
                property: "scale"
                from: 1
                to: target_scale
                duration: 500
                easing.type: Easing.OutQuad
            }
        }

        PropertyAction {
          target: sign
          property: "isInSlot"
          value: true
        }
    }


    fillMode: Image.PreserveAspectCrop

    rotation: 0;
}
