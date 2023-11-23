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
        property int canEntityArg3: 0x0

        property int layer_pri: 2

        width: 320
        height: 240

        visible: isInEdition

        property  bool is_available: is_available_bundle && is_available_version

        property  bool is_available_bundle: false

        property  bool is_available_version: false

        property bool isInEdition: true


        property string font_family

        anchors.fill: parent


     Item {
        property string canEntityType: "INFO_ISA_VERSION"
        objectName: "ISA_VERSION"
        property int layer_pri: 0

        function setVisibleSlot(arg0,arg1){
            is_available_version = true;
            canEntityArg2 = arg0;
            canEntityArg3 = arg1;
        }

 }

        Item {
            property string canEntityType: "INFO_ISA_BUNDLE"
            objectName: "ISA_BUNDLE"
            property int layer_pri: 0

            function setVisibleSlot(arg0,arg1){
                is_available_bundle = true;
                canEntityArg0 = arg0;
                canEntityArg1 = arg1;
            }

        }


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
            text: isa_version.canEntityArg+"."+isa_version.canEntityArg1+"."+isa_version.canEntityArg2+"."+isa_version.canEntityArg3
            anchors.top: parent.top
            anchors.topMargin: 108
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 32
            font.family: font_family
            font.weight: Font.Light
            visible: true
        }

        BallsFooter {
          current: 2
          quantity: 3
          anchors.bottom: parent.bottom
          anchors.horizontalCenter: parent.horizontalCenter
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


