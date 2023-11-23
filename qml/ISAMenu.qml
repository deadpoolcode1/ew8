import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQml.Models 2.3

//Custom modules:
import MyQMLenums 0.1


ProgressBarMenu {
    id: isa_menu

    mnemonicsModel: isa_model
    isDisplayedValueAnImage: true
    property alias pages: footer.quantity


    ListModel {
     id: isa_model
     ListElement {property url smallIcon: "images/status-bar/ISA_full_deact.png" ; property int centerOffset: 20;
         property url bigIcon: "images/isa-menu/ISA_full_deact_big.png"}
     ListElement {property url smallIcon: "images/status-bar/ISA_part_deact.png" ;  property int centerOffset: 0;
         property url bigIcon: "images/isa-menu/ISA_part_deact_big.png"}
     ListElement {property url smallIcon: "images/status-bar/ISA_full_act.png" ;  property int centerOffset: -20;
         property url bigIcon: "images/isa-menu/ISA_full_act_big.png"}
    }

    lowerLimit: 0
    upperLimit: 2


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

    BallsFooter {
      id: footer
      current: quantity - 2
      quantity: 3
      anchors.bottom: parent.bottom
      anchors.horizontalCenter: parent.horizontalCenter
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
