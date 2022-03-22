
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
    property bool has_supp: false

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
                  x_start_from: 92
                  y_start_from: -8
                  target_scale: 0.6028
                  start_scale: 1.0
                  pause_duration: 1500
                  _topMar: 3
                }
          }
          ,State {name: "Ia"; when:  quadrant === 1 && is_in_alert
                PropertyChanges{
                  target: sign
                  anchors.top: parent.top
                  anchors.right: parent.right
                  target_scale: 0.6028
                  start_scale: 0.78
                  _topMar: 3
                  x_start_from: -8
                }
        }
        ,State {name: "II"; when:  quadrant === 2
            PropertyChanges{
              target: sign
              anchors.top: parent.top
              anchors.left: parent.left
            }
        }
        ,State {name: "III"; when:  quadrant === 3 && !has_supp
                PropertyChanges{
                  target: sign
                  anchors.bottom: parent.bottom
                  anchors.left: parent.left
                }
            }
        ,State {name: "IIIs"; when:  quadrant === 3 && has_supp
                PropertyChanges{
                  target: sign
                  anchors.bottom: parent.bottom
                  anchors.left: parent.left
                  start_scale: 0.82
                  target_scale: 0.6028 * 0.9
                  targetHeightMargin: - (height * (1 - target_scale) / 2) * 0.3
                  targetWidthMargin: - (width * (1 - target_scale) / 2) * 0.57
                }
            }
        ,State {name: "IV"; when: quadrant === 4&& (!is_in_alert)
                PropertyChanges{
                  target: sign
                  x_start_from: 92
                  y_start_from: 38
                  target_scale: 0.6028
                  start_scale: 1.0
                  pause_duration: 1500
               
                  anchors.bottom: parent.bottom
                  anchors.right: parent.right
                }
            }
        ,State {name: "IVa"; when: quadrant === 4 && (is_in_alert)
                PropertyChanges{
                  target: sign
                  x_start_from: -8
                  y_start_from: 26
                  target_scale: 0.6028
                  start_scale: 0.78
                  pause_duration: 1500
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
