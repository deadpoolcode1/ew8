import QtQuick 2.9
//import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQml.Models 2.3

//Custom modules:
import MyQMLenums 0.1
import builtin.mobileye.QRCode 0.1

Rectangle
{
    width: 22
    height: 35
    color: "#00000000"
    border.color: "#00000000"

    property int canEntityArg: 0x0
    property int canEntityArg1: 0x0
    property int canEntityArg2: 0x5

Image {
    id: volume_reqfail
    property int canEntityType: Alert.ALERT_REQFAIL
    objectName: "REQFAIL_VOLUME"
    property int layer_pri: 0

    anchors.left: parent.left
    anchors.leftMargin: 0
    source: "images/master-volume/m_red alert.png"


    anchors.verticalCenter: parent.verticalCenter

    visible: false

    function setVisibleSlot(arg){visible = true}
    function setInvisibleSlot(){visible = false}
    signal  itemSelfDeactivate()

    Timer {
        id: volume_reqfail_timer
        running: volume_reqfail.visible
        interval: 300
        onTriggered: {
            volume_reqfail.itemSelfDeactivate()
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
    signal itemActionDeactivate()

    Timer {
        id: volume_fail_timer
        running: volume_fail.visible
        interval: 500
        onTriggered: {
            volume_fail.itemActionDeactivate()
        }
    }
}



Image {
    id: volume_done
    property string canEntityType: "VOLUME_DONE"
    objectName: "DONE_VOLUME"
    //TODO check the values integrity
    property int layer_pri: 1
    
    source: "images/master-volume/m_mute.png"
    
    function setVisibleSlot(arg0,arg1,arg2){visible= true; canEntityArg = arg0; canEntityArg1 = arg1; canEntityArg2 = arg2;}
    function setInvisibleSlot(){visible = false}
    signal itemActionDeactivate()
    
    Timer {
        id: volume_done_timer
        running: volume_done.visible
        interval: 1000
        onTriggered: {
            volume_done.itemActionDeactivate()
        }
    }

}

states: [
    State {
        name: "Low"
        when: canEntityArg > 0 && canEntityArg < 3

        PropertyChanges {
            target: volume_done
            source: "images/master-volume/m_vol_low.png"
        }
    },
    State {
        name: "High"
        when: canEntityArg > 2

        PropertyChanges {
            target: volume_done
            source: "images/master-volume/m_vol_high.png"
        }
    }
]

}
