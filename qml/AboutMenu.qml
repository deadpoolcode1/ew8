import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQml.Models 2.3


Rectangle {

    id: about_version

    color: "#191414"

    property int canEntityArg: 0x0
    property int canEntityArg1: 0x0
    property int canEntityArg2: 0x0
    property int canEntityArg3: 0x0

    property string osbuild
    property string engineVersion
    property string configVersion
    property string ewsn
    property string mesn

    property color black: "#ff191414"
    property color gray: "#ffcccccc"
    property color blue: "#ff00bfff"
    property color white: "#ffe1f1ff"

    property int layer_pri: 2

    width: 320
    height: 240

    visible: isInEdition

    property bool is_isa_enabled: false

    property  bool is_available_isa_info: is_available_isa_bundle && is_available_isa_version

    property alias pages: footer.quantity


    property  bool is_available_isa_bundle: false

    property  bool is_available_isa_version: false

    property bool is_available_mesn: false

    property bool isInEdition: true


    property string font_family

    anchors.fill: parent

    Image {
        id: info_logo

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 13

        source: "images/about/info-logo.png"

        fillMode: Image.PreserveAspectFit
    }


    Item {
        property string canEntityType: "INFO_ISA_VERSION"
        objectName: "ISA_VERSION"
        property int layer_pri: 0

        function setVisibleSlot(arg0,arg1){
            is_available_isa_version = true;
            canEntityArg2 = arg0;
            canEntityArg3 = arg1;
        }

    }

    Item {
        property string canEntityType: "INFO_ISA_BUNDLE"
        objectName: "ISA_BUNDLE"
        property int layer_pri: 0

        function setVisibleSlot(arg0,arg1){
            is_available_isa_bundle = true;
            canEntityArg = arg0;
            canEntityArg1 = arg1;
        }

    }

    Rectangle {

        width: 220
        height: inforows.height
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 8
        anchors.left: parent.left
        anchors.leftMargin: 30
        color: black

        ColumnLayout {
            id: inforows

            spacing: 3


            InfoRow {
                label: "ME version";
                value: "No CAN Support"
                condition: false
                font_family: about_version.font_family
            }
            InfoRow {
                label: "ME8 SN";
                value: about_version.mesn
                condition: about_version.is_available_mesn
                font_family: about_version.font_family
            }
            InfoRow {
                label: "EW8 Linux";
                value: about_version.osbuild
                condition: about_version.osbuild !== "NA"
                font_family: about_version.font_family
            }
            InfoRow {
                label: "EW8 App";
                value: about_version.engineVersion
                condition: true
                font_family: about_version.font_family
            }
            InfoRow {
                label: "EW8 Config";
                value: about_version.configVersion
                condition: true
                font_family: about_version.font_family
            }
            InfoRow {
                label: "EW8 SN";
                value: about_version.ewsn
                condition: about_version.ewsn !== "NA"
            }
            InfoRow {
                label: "ISA";
                value: about_version.canEntityArg+"."+about_version.canEntityArg1+"."+about_version.canEntityArg2+"."+about_version.canEntityArg3;
                condition: about_version.is_available_isa_info && about_version.is_isa_enabled
                font_family: about_version.font_family
            }
        }
    }


    BallsFooter {
        id: footer
        current: quantity - 1
        quantity: 3
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Timer {
        id: hide_timer
        running: about_version.visible
        interval: 120000
        onTriggered: {
            about_version.visible = false
        }
    }
}


