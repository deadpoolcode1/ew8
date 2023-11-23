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
    width: 51
    height: 51
    color: "#00000000"
    border.color: "#00000000"
    property alias reqfail_item: isa_reqfail
    signal forwardReqfailDeactivate()


    function timersRestart()
    {
        isa_fail_timer.restart()
    }

    function deactivate()
    {
      isa_reqfail.itemSelfDeactivate()
      isa_fail.itemActionDeactivate()
    }

    Image {
        id: isa_menu_logo
        z: 1
        visible: !(isa_fail.visible || isa_reqfail.visible)

        source: "images/isa-menu/ISA.png"
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }


    Image {
        id: isa_reqfail
        property int canEntityType: Alert.ALERT_REQFAIL
        objectName: "REQFAIL_ISA"
        property int layer_pri: 0

        z: 1

        source: "images/master-volume/m_red alert.png"

        onItemSelfDeactivate:
        {
          forwardReqfailDeactivate()
        }


        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        visible: false

        function setVisibleSlot(arg){visible = true; isa_reqfail_timer.start()}
        function setInvisibleSlot(){visible = false; isa_reqfail_timer.stop()}
        signal  itemSelfDeactivate()

        Timer {
            id: isa_reqfail_timer
            running: isa_reqfail.visible
            interval: 5000
            onTriggered: {
                isa_reqfail.itemSelfDeactivate()
            }
        }
    }

    Image {
        id: isa_fail
        property string canEntityType: "VOLUME_FAIL"
        objectName: "FAIL_ISA"
        property int layer_pri: 0
        z: 1
        source: "images/master-volume/m_red alert.png"


        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        function setVisibleSlot(){visible = true}
        function setInvisibleSlot(){visible = false}
        signal itemActionDeactivate()

        Timer {
            id: isa_fail_timer
            running: isa_fail.visible
            interval: 5000
            onTriggered: {
                isa_fail.itemActionDeactivate()
            }
        }
    }
}
