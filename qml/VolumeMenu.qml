import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQml.Models 2.3

//Custom modules:
import MyQMLenums 0.1


ProgressBarMenu {
    id: volume_menu

    property bool is_active: false
    property bool is_suppressed: false

    property alias reqfail_ref: volume_done.reqfail_item
    property alias volume_done_ref: volume_done.volume_done_item
    property alias volume_fail_ref: volume_done.volume_fail_item

    property bool isRequestGuardArmed: false

    signal forwardReqfailDeactToMain()

    visible: is_active && !is_suppressed

    function timersRestart()
    {
        volume_done.timersRestart()
    }

    function invokeLimitFail()
    {
      volume_done.isLimitFail =  true
    }

    function suppressLimitFail()
    {
      volume_done.isLimitFail =  false
    }

    displayedValue: volume_done.canEntityArg

    lowerLimit: volume_done.canEntityArg1
    upperLimit: volume_done.canEntityArg2

    function setVisibleSlot(){
        if(is_suppressed)
        {
            volume_done_ref.itemActionDeactivate()
        }
        else
        {
            is_active = true
        }

    }

    function setInvisibleSlot(){is_active = false}

    VolumeIndicator {
        id: volume_done

        onDisarmRequestGuard: {
            isRequestGuardArmed = false
        }

        anchors.horizontalCenter: mnemonicIconSlot.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 13
        onForwardReqfailDeactivate:
        {
          forwardReqfailDeactToMain()
        }
    }
}


