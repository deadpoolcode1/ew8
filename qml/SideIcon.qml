
import QtQuick 2.9


AnimatedImage {

    id: sign
    visible: true

    property int _topMar: 12
    property int _bottomMar: (165 - 112 - 12)
    property int y_start_from: is_top? _topMar : _bottomMar
    property int x_start_from: 0

    property int pause_duration: 1000

    property int quadrant

    property bool is_in_alert: false

    property bool is_top: quadrant < 3
    property double start_scale: 1.0
    property double target_scale: 0.732

    property int targetWidthMargin: - (width * (1 - target_scale) / 2)
    property int targetHeightMargin: - (height * (1 - target_scale) / 2)




    property bool isInSlot: false

    anchors.topMargin: _topMar
    anchors.bottomMargin: _bottomMar
    anchors.rightMargin: x_start_from
    anchors.leftMargin: x_start_from

    scale: start_scale

    states: [
         State {name: "I"; when:  quadrant === 1 && (!is_in_alert)
                PropertyChanges{
                  target: sign
                  anchors.top: parent.top
                  anchors.right: parent.right
                  x_start_from: 80
                  target_scale: 0.5124
                  start_scale: 0.85
                  _topMar: 2
                }
          }
          ,State {name: "Ia"; when:  quadrant === 1 && is_in_alert
                PropertyChanges{
                  target: sign
                  anchors.top: parent.top
                  anchors.right: parent.right
                  target_scale: 0.5124
                  start_scale: 0.7
                  _topMar: 2
                  x_start_from: -18
                  pause_duration: 1500
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
            scale = start_scale
            anchors.topMargin = y_start_from
            anchors.bottomMargin = y_start_from
            anchors.leftMargin = x_start_from
            anchors.rightMargin = x_start_from
           console.log("Smart ADAS is at alert:" +  is_in_alert)
    }


    SequentialAnimation  {

        //NOTE: next line used in edition mode
        //running: false
        running: sign.visible

        id: enter_animat

        PauseAnimation {
            duration: pause_duration
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
                from: x_start_from
                to: targetWidthMargin
                duration: 500
                easing.type: Easing.OutQuad
            }

            NumberAnimation {
                target: sign
                property: "scale"
                from: start_scale
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
