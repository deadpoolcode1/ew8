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
    //TODO check the values integrity
    property int canEntityArg: 0x0
    property int canEntityArg1: 0x0
    property int canEntityArg2: 0x5
    property int layer_pri: 1
    
    source: "images/master-volume/m_mute.png"
    
    function setVisibleSlot(arg0,arg1,arg2){visible= true; canEntityArg = arg0; canEntityArg1 = arg1; canEntityArg2 = arg2;}
    function setInvisibleSlot(){visible = false}
    
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
