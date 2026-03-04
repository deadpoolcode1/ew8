import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQml.Models 2.3

Image {
    id: beam
    visible: true
    function setVisibleSlot() {beam.opacity = 1.0}
    function setInvisibleSlot() {beam.opacity = 0.0}

    source: "images/status-bar/status_IHC_high.png"
    property bool is_hi: true
    opacity: 1.0


    states: [
        State {
            name: "Low"; when: !is_hi
            PropertyChanges {
                target: beam
                source: "images/status-bar/status_IHC_low.png"
            }
        }
    ]

    Item{
        property string canEntityType: "ALERT_HI_BEAM"
        property int layer_pri: 1
        id: alert_hmw_alert
        function setVisibleSlot(){
            visible=true
            is_hi = true
        }
        function setInvisibleSlot(){visible = false}
    }

    Item{
        property string canEntityType: "ALERT_LOW_BEAM"
        property int layer_pri: 1
        id: alert_hmw_monitor
        function setVisibleSlot(){
            visible=true
            is_hi = false
        }
        function setInvisibleSlot(){visible = false}
    }
}
