import QtQuick 2.0

Image {

    function setVisibleSlot() {setVisible(true);}
    function setInvisibleSlot() {setVisible(false)}


    function setVisible(isVisible)
    {
        if(is_main)
        { // on main panel

            x = main_panel.width/8
            y = 20
            width = main_panel.width*3/4

            visible = isVisible
        }
        else // on side panel
        {
            x = left_panel.width/8;
            width = left_panel.width*3/4;
        }



        if(isVisible === true)
        {
            itsTimer.running = true
        }
        else
        {
           visible = false
           itsTimer.running = false
        }
    }

    property bool is_main: true
    property bool is_ready: false
    property var its_pair_alert

    property string canEntityType
    property int canEntityArg

    visible:  false

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
            if(!is_main)
            {
                console.log("side alert activated")
                visible = true
            }
        }
    }
}
