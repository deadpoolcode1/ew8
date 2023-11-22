import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQml.Models 2.3

import Qt.labs.settings 1.0

//Custom modules:
import MyQMLenums 0.1
import builtin.mobileye.QRCode 0.1


ProgressBarMenu {
    id: bar_menu

    Settings
    {
        id: bri_setting

        category: "Brightness"
        property alias brightness: bar_menu.displayedValue
    }

    displayedValue: 5

    lowerLimit: 1
    upperLimit: 5

    function up()
    {
        if (displayedValue < upperLimit)
        {
            displayedValue++
            brightnessChanged(displayedValue)
        }
        hide_timer.restart()
    }

    function down()
    {
        if (displayedValue > lowerLimit)
        {
            displayedValue--
            brightnessChanged(displayedValue)
        }
        hide_timer.restart()
    }

    BrightnessIndicator {
        id: brightness_indicator

        level: displayedValue

        anchors.horizontalCenter: mnemonicIconSlot.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 13
    }

    Timer {
        id: hide_timer
        running: bar_menu.visible
        interval: 5000
        onTriggered: {
           bar_menu.visible = false
        }
    }
}


