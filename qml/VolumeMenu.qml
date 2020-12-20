import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQml.Models 2.3

//Custom modules:
import MyQMLenums 0.1
import builtin.mobileye.QRCode 0.1


Rectangle {
    id: volume_menu
    color: "#191414"
    
    property int canEntityType: Alert.QtQG
    property int layer_pri: 0
    width: 320
    height: 240
    z: 14
    function setVisibleSlot(){visible= true}
    function setInvisibleSlot(){visible = false}
    visible: isInEdition

    property bool isInEdition: false
    
    
    
    anchors.fill: parent
    
    
    
    
    
    Rectangle {
        id: value_rectangle
        height: 40
        color: "#00000000"
        border.color: "#00000000"
        anchors.top: parent.top
        anchors.topMargin: 14
        anchors.right: parent.right
        anchors.rightMargin: 14
        anchors.left: parent.left
        anchors.leftMargin: 14

        Text {
            id: actual_value
            color: "#e1f1ff"
            opacity: 0.9
            property int value: volume_done.canEntityArg
            text: value.toFixed(0)
            anchors.top: parent.top
            anchors.topMargin: -10
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 54
        }

        Image {
            id: volume_reqfail
            property int canEntityType: Alert.ALERT_REQFAIL
            objectName: "REQFAIL_VOLUME"
            property int layer_pri: 0

            anchors.left: parent.left
            anchors.leftMargin: 0
            //color: "orange"
            source: "images/master-volume/m_red alert.png"


            anchors.verticalCenter: parent.verticalCenter

            visible: false

            function setVisibleSlot(arg){visible = true}
            function setInvisibleSlot(){visible = false}

            Timer {
                id: volume_reqfail_timer
                running: volume_reqfail.visible
                interval: 300
                onTriggered: {
                    itemSelfDeactivated(Alert.ALERT_REQFAIL ,"REQFAIL_VOLUME")
                }
            }
        }

        Image {
            id: volume_fail
            property string canEntityType: "VOLUME_FAIL"
            objectName: "FAIL_VOLUME"
            property int layer_pri: 0

            anchors.left: parent.left
            anchors.leftMargin: 0
            //color: "red"
            source: "images/master-volume/m_red alert.png"


            anchors.verticalCenter: parent.verticalCenter

            function setVisibleSlot(arg){visible = true}
            function setInvisibleSlot(){visible = false}

            Timer {
                id: volume_fail_timer
                running: volume_fail.visible
                interval: 500
                onTriggered: {
                    itemSelfDeactivated("VOLUME_FAIL","FAIL_VOLUME")
                }
            }
        }

        VolumeIndicator {
            id: volume_done

            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 0
        }

    }
    Rectangle {
        id: value_progress_used
        height: 8
        width: 292*((actual_value.value - min_value.value)/(max_value.value - min_value.value))
        color: "#e1f1ff"
        opacity: 0.9
        border.color: "#00000000"
        anchors.top: value_rectangle.bottom
        anchors.topMargin: 14
        anchors.left: parent.left
        anchors.leftMargin: 14
     }

    Rectangle {
        id: value_progress_unused
        height: 8
        width: 292 - value_progress_used.width
        color: "#ffffff"
        opacity: 0.3
        border.color: "#00000000"
        anchors.top: value_rectangle.bottom
        anchors.topMargin: 14
        anchors.right: parent.right
        anchors.rightMargin: 14
     }

    Rectangle {
        id: value_boundaries
        height: 14
        color: "#00000000"
        border.color: "#00000000"
        anchors.top: value_progress_used.bottom
        anchors.topMargin: 8
        anchors.right: parent.right
        anchors.rightMargin: 14
        anchors.left: parent.left
        anchors.leftMargin: 14

        Text {
            id: min_value
            color: "#e1f1ff"
            opacity: 0.9
            property int value: volume_done.canEntityArg1
            text: value.toFixed(0)
            anchors.left: parent.left
            anchors.leftMargin: -1
            anchors.top: parent.top
            anchors.topMargin: -4
            font.pixelSize: 19
        }

        Text {
            id: max_value
            color: "#e1f1ff"
            opacity: 0.9
            property int value: volume_done.canEntityArg2
            text: value.toFixed(0)
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.top: parent.top
            anchors.topMargin: -4
            font.pixelSize: 19
        }
     }
}
