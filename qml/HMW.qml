import QtQuick 2.9


Item{
    id: hmw_item
    property int canEntityArg: 0x10
    property var canEntityType;
    width: 220
    height: 190
    function setVisibleSlot(){visible = true}
    function setInvisibleSlot(){visible = false}


    states: [
        State {name: "Alert"; when: canEntityType === "ALERT_HMW_ALERT"
            PropertyChanges {
                target: strips_img;
                source: "images/hmw/red_road-01.png"
                visible: true
            }

            PropertyChanges {
                target: vehicle_img
                source: "images/cars/eyewatch_car_red_hmw-01.png"
            }
        },
        State {name: "Monitor"; when: canEntityType === "ALERT_HMW_MONITOR"
            PropertyChanges {
                target: strips_img;
                source: "images/hmw/green_road-01.png"
                visible: true
            }

            PropertyChanges {
                target: vehicle_img
                anchors.topMargin: 0
                source: "images/cars/eyewatch_car_green_hmw-01.png"
            }
        }
    ]

    Image {
        id: vehicle_img
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 0
        source: "images/cars/eyewatch_car_green_hmw-01.png"
        visible: true
    }


    Image {
        id: strips_img;
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
            anchors.bottomMargin: 8
        }

            Text {
                id: units
                color: "#f1e1ff"
                text: "  sec"
                font.bold: true
                font.pixelSize: 10
                font.family: "Helvetica"
                anchors.bottomMargin: 8
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
            }
    }
}


