import QtQuick 2.0

Image {


    function setVisibleSlot(arg) {setVisible(true); canEntityArg = arg}
    function setInvisibleSlot() {setVisible(false)}


    function setVisible(isVisible)
    {
        if(is_main)
        { // on main panel

            x = main_panel.width/8
            y = 20
            width = main_panel.width*3/4

            visible = isVisible

            if(visible === true)
            {
                itsTimer.running = true
            }
        }
        else // on side panel
        {
            x = left_panel.width/8;
            width = left_panel.width*3/4;

            is_ready = isVisible
        }
    }

    property bool is_main: true
    property bool is_ready: false
    property var its_pair_alert

    property int canEntityType
    property int canEntityArg

    function setCanEntityArg(arg){canEntityArg = arg}//WARNING: win32 workaround

    visible: is_main? false : (is_ready && !its_pair_alert.visible)

    fillMode: Image.PreserveAspectFit;

    rotation: 0;

    Timer {

        id: itsTimer

        interval: 500
        running: false
        repeat: false

        onTriggered:
        {
            page.itemSelfDeactivated(parent.canEntityType, parent.objectName);
        }
    }
}
