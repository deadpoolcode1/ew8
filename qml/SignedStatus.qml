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

    Image {
        property string canEntityType: "INFO_DRIVER_AUTH_IN"
        id: auth_in
        anchors.top: parent.top
        anchors.topMargin: 0
        source: "images/status-bar/status_Signed_in.png"
        function setVisibleSlot(){visible = true; user_stat.opacity = 1.0}
        function setInvisibleSlot(){visible = false;}
    }

    Image {
        property string canEntityType: "INFO_DRIVER_AUTH_OUT"
        anchors.top: parent.top
        anchors.topMargin: 0
        source: "images/status-bar/status_Signed_out.png"
        function setVisibleSlot(){visible = true; user_stat.opacity = 1.0}
        function setInvisibleSlot(){visible = false;}
    }

    Image {
        property string canEntityType: "INFO_DRIVER_AUTH_PROCESS"
        anchors.top: parent.top
        anchors.topMargin: 0
        source: "images/status-bar/status_Signed_process.png"
        function setVisibleSlot(){visible = true; user_stat.opacity = 1.0}
        function setInvisibleSlot(){visible = false;}
    }

}
