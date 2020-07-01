import QtQuick 2.9


Item{
    id: hmw_item
    property int canEntityArg: 0x10
    property alias playing: strips_img.playing
    property double car_scale: 1
    property int car_margin: -2
    property bool alert
    width: 220
    height: 190

    function setVisibleSlot(){visible = true}
    function setInvisibleSlot(){visible = false}


    Item{
        property string canEntityType: "ALERT_HMW_ALERT"
        property int layer_pri: 1
        id: alert_hmw_alert
        function setVisibleSlot(){
            visible=true
            alert = true
        }
        function setInvisibleSlot(){visible = false}
    }

    Item{
        property string canEntityType: "ALERT_HMW_MONITOR"
        property int layer_pri: 1
        id: alert_hmw_monitor
        function setVisibleSlot(){
            visible=true
            alert = false
        }
        function setInvisibleSlot(){visible = false}
    }

    transitions: Transition {
            NumberAnimation { properties: "car_margin,car_scale"; easing.type: Easing.InOutQuad }
        }

    states: [
        State {name: "Alert"; when: alert
            PropertyChanges {
                target: strips_img;
                source: "images/hmw/main_HMW_redcarpet.gif"
                visible: true
            }
        },
        State {name: "Monitor"; when: !alert
            PropertyChanges {
                target: strips_img;
                source: "images/hmw/main_HMW_greencarpet.gif"
                visible: true
            }

            PropertyChanges {
                target: hmw_item
                car_margin: -5
                car_scale: 0.7
            }
        }
    ]




    AnimatedImage {
        id: strips_img;
        z: -5
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter
        visible: false;


        source: "images/hmw/green_road-01.png"

        Text {
            id: time
            color: "#f1e1ff"
            text: (hmw_item.canEntityArg == 0x00 ? "  " : (hmw_item.canEntityArg/10).toFixed(1))
            font.bold: true
            font.pixelSize: 40
            font.family: "Helvetica"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: units.top
            anchors.bottomMargin: 0
        }

            Text {
                id: units
                color: "#f1e1ff"
                text: hmw_item.canEntityArg == 0x00? "   ":"sec"
                anchors.verticalCenterOffset: 65
                anchors.verticalCenter: parent.verticalCenter
                font.bold: true
                font.pixelSize: 10
                font.family: "Helvetica"
                anchors.horizontalCenter: parent.horizontalCenter
            }
    }
}


