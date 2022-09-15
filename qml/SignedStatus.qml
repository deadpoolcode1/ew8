import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQml.Models 2.3

Rectangle {
    id: user_stat
    anchors.top: parent.top
    anchors.topMargin: 0
    width: auth_in.width
    height: auth_in.height
    color: "#00000000"

    property bool is_in_err20: false
    property bool is_active: false

    opacity: (!is_in_err20 && is_active) ? 1.0 : 0.0

    Image {
        property string canEntityType: "INFO_DRIVER_AUTH_IN"
        id: auth_in
        anchors.top: parent.top
        anchors.topMargin: 0
        source: "images/status-bar/status_Signed_in.png"
        function setVisibleSlot(){visible = true; user_stat.is_active = true}
        function setInvisibleSlot(){visible = false;}
    }

    Image {
        id: driver_out
        property string canEntityType: "INFO_DRIVER_AUTH_OUT"
        anchors.top: parent.top
        anchors.topMargin: 0
        opacity: 1.0
        source: "images/status-bar/status_Signed_out.png"
        function setVisibleSlot(){visible = true; user_stat.is_active = true}
        function setInvisibleSlot(){visible = false;}

        SequentialAnimation {
            id: driver_out_animat
            loops: Animation.Infinite
            running: driver_out.visible

            NumberAnimation {
                target:  driver_out
                property: "opacity"
                from: 1.0
                to: 0.0
                duration: 404
                easing.type: Easing.InOutQuad
            }

            NumberAnimation {
                target: driver_out
                property: "opacity"
                from: 0.0
                to: 1.0
                duration: 404
                easing.type: Easing.InOutQuad
            }
        }
    }

    Image {
        property string canEntityType: "INFO_DRIVER_AUTH_PROCESS"
        anchors.top: parent.top
        anchors.topMargin: 0
        source: "images/status-bar/status_Signed_process.png"
        function setVisibleSlot(){visible = true; user_stat.is_active = true}
        function setInvisibleSlot(){visible = false;}
    }

}
