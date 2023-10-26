import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQml.Models 2.3

//Custom modules:
import MyQMLenums 0.1
import builtin.mobileye.QRCode 0.1


ProgressBarMenu {
    id: volume_menu

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

    function setVisibleSlot(){visible= true}
    function setInvisibleSlot(){visible = false}

    VolumeIndicator {
        id: volume_done



        anchors.verticalCenter: mnemonicIconSlot.verticalCenter
        anchors.left:mnemonicIconSlot.left
        anchors.leftMargin: 0
    }
    
}


