import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQml.Models 2.3

//Custom modules:
import MyQMLenums 0.1


ISAProgressBarMenu {
    id: isa_menu

    property bool is_in_error: false

    property alias reqfail_ref: isa_indicator.reqfail_item
    signal forwardReqfailDeactToMain()

    function setVisibleSlot(){hide_timer.start()}
    //function setInvisibleSlot(){visible = false}

    function hide_timer_restart(){hide_timer.restart()}

    function deactivate()
    {
      isa_indicator.deactivate()
    }



    ISAIndicator {
        id: isa_indicator



        anchors.horizontalCenter: mnemonicIconSlot.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 13
        onForwardReqfailDeactivate:
        {
          forwardReqfailDeactToMain()
        }
    }


    Timer {
        id: hide_timer
        running: isa_menu.visible
        interval: 5000
        onTriggered: {
           isa_menu.visible = false
           isa_menu.deactivate()
        }
    }

}



/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}D{i:1}D{i:2}
}
##^##*/
