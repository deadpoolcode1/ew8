import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQml.Models 2.3

//Custom modules:
import MyQMLenums 0.1
import builtin.mobileye.QRCode 0.1


Image {
    id: gps_status
    anchors.top: parent.top
    anchors.topMargin: 0
    source: "images/status-bar/status_no_GPS.png"
    property bool is_active: isInEdition
    property bool is_in_err20: false
    opacity: ((!is_in_err20) && active)? 1.0 : 0.0
    property int layer_pri: 0


    Item{
    id: no_gps
    property string canEntityType: "INFO_NO_GPS"
    property int layer_pri: 0
    visible: false
    
    function setVisibleSlot() {is_active = true}
    function setInvisibleSlot() {is_active = false}
    }

    Item{
    id: ok
    property string canEntityType: "INFO_GPS_OK"
    property int layer_pri: 0
    visible: false

    function setVisibleSlot() {}
    function setInvisibleSlot() {}
    }
}
