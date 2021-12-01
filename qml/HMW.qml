import QtQuick 2.9


Item{
    id: hmw_item
    property int canEntityArg: 0x10
    property alias playing: strips_img.playing
    property double car_scale: 1
    property int car_margin: 47
    property bool alert
    width: 220
    height: 190
    property string timeText: (hmw_item.canEntityArg == 0x00 ? "  " : (hmw_item.canEntityArg/10).toFixed(1))

    function setVisibleSlot(){visible = true}
    function setInvisibleSlot(){visible = false}

    property color text_color: "#e1f1ff"


    AnimatedImage {
        id: strips_img;
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter
        visible: false;


        source: "images/hmw/green_road-01.png"
    }

    Text {
        id: units
        color: text_color
        text: hmw_item.canEntityArg == 0x00? "   ":"sec"
        font.pixelSize: 20
        lineHeight: 1
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignTop
        font.weight: Font.Bold
        font.family: intelFont.name
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 38
        visible: strips_img.visible
    }


    Item{
        id: time
        anchors.horizontalCenter: strips_img.horizontalCenter
        anchors.horizontalCenterOffset: -2
        anchors.bottom: units.top
        anchors.bottomMargin: -13
        width: time_text_id.width
        property int fontPixelSize: 28


        Text {
            id: time_text_id
            color: text_color
            text: timeText
            anchors.horizontalCenter: time.horizontalCenter
            anchors.horizontalCenterOffset: 1
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            font.weight: Font.Bold
            font.pixelSize: parent.fontPixelSize
            font.family: intelFont.name
            visible: strips_img.visible
        }
    }

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
        NumberAnimation { properties: "car_margin,car_scale"; easing.type: Easing.InOutQuad ; duration: 700 }
    }

    states: [
        State {name: "Alert"; when: alert
            PropertyChanges {
                target: strips_img;
                source: "images/hmw/HMW-red-new-1.gif"
                visible: true
            }
        },
        State {name: "Yellow";
            PropertyChanges {
                target: strips_img
                source: "images/hmw/HMW-yellow-new-2.gif"
                visible: true
            }

            PropertyChanges {
                target: hmw_item
                car_margin: 43
                car_scale: 0.8
            }
        },
        State {name: "Monitor"; when: !alert
            PropertyChanges {
                target: strips_img
                anchors.horizontalCenterOffset: 0
                source: "images/hmw/HMW-green-new-2.gif"
                visible: true
            }

            PropertyChanges {
                target: hmw_item
                car_margin: 40
                car_scale: 0.75
            }
        }
    ]




}


