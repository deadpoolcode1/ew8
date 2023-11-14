import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQml.Models 2.3


 Rectangle {

        id: isa_version

        color: "#191414"

        property int canEntityArg: 0x0
        property int canEntityArg1: 0x0
        property int canEntityArg2: 0x0

        width: 320
        height: 240

        visible: isInEdition

        property  bool is_available: false

        property bool isInEdition: true


        property string font_family

        anchors.fill: parent


        

        property string canEntityType: "INFO_ISA_VERSION"
        objectName: "ISA_VERSION"
        property int layer_pri: 2

        function setVisibleSlot(arg0,arg1,arg2){is_available = true; canEntityArg = arg0; canEntityArg1 = arg1; canEntityArg2 = arg2;}


        Text {
            id: version_label
            color: "#e1f1ff"
            opacity: 0.9
            text: "ISA VERSION"
            anchors.bottom: version_text.top
            anchors.bottomMargin: 2
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 16
            font.family: font_family
            font.weight: Font.Light
            visible: true
        }

        Text {
            id: version_text
            color: "#e1f1ff"
            opacity: 0.9
            text: isa_version.canEntityArg+"."+isa_version.canEntityArg1+"."+isa_version.canEntityArg2
            anchors.top: parent.top
            anchors.topMargin: 108
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 32
            font.family: font_family
            font.weight: Font.Light
            visible: true
        }

        Timer {
            id: hide_timer
            running: isa_version.visible
            interval: 5000
            onTriggered: {
               isa_version.visible = false
            }
        }
 }


