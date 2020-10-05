import QtQuick 2.9
//import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQml.Models 2.3

//Custom modules:
import MyQMLenums 0.1
import builtin.mobileye.QRCode 0.1

Image {
    id: volume_done
    property string canEntityType: "VOLUME_DONE"
    objectName: "DONE_VOLUME"
    property int canEntityArg: 0x0
    property int layer_pri: 1
    
    source: "images/Volume_Control_shortcut/mute.png"
    
    function setVisibleSlot(arg){visible= true; canEntityArg = arg;}
    function setInvisibleSlot(){visible = false}
    
    width: 100
    height: 100
    anchors.verticalCenter: parent.verticalCenter
    anchors.horizontalCenter: parent.horizontalCenter
    
    
    Text {
        id: volume_value
        x: 15
        color: "white"
        text: volume_done.canEntityArg > 0 ? volume_done.canEntityArg.toFixed(0):""
        anchors.verticalCenter: parent.verticalCenter
        topPadding: 0
        font.family: "HindSiliguri"
        font.pixelSize: 50
        font.bold: true
    }
    
    Timer {
        id: volume_done_timer
        running: volume_done.visible
        interval: 1000
        onTriggered: {
            itemSelfDeactivated("VOLUME_DONE","DONE_VOLUME")
        }
    }
    states: [
        State {
            name: "Low"
            when: canEntityArg > 0 && canEntityArg < 3

            PropertyChanges {
                target: volume_done
                source: "images/Volume_Control_shortcut/volume_low.png"
            }
        },
        State {
            name: "High"
            when: canEntityArg > 2

            PropertyChanges {
                target: volume_done
                source: "images/Volume_Control_shortcut/volume_high.png"
            }
        }
    ]
}
