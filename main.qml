import QtQuick 2.9
import QtQuick.Controls 2.2


ApplicationWindow {


    function switchVisibility()
    {
        imgAlert.visible = ((imgAlert.visible == true) ? false : true)
    }


    Timer {

        id: blinkTimer

        interval: 0
        running: false
        repeat: true
        onTriggered: switchVisibility()
    }





    function startBlinking(freq)
    {

     var interval = 0

     if(freq !== 0)
     {
       interval = 1000/(freq*2)
         //start

       blinkTimer.interval = interval
       blinkTimer.running = true

     }
    }


     function stopBlinking()
     {
        //stop
         blinkTimer.running = false
     }


    function setAlert(msg)
    {

        switch(msg)
        {
        case 'pcw':

            imgAlert.visible = true;

            imgAlert.source = "qrc:/resources/sp_red_h.png"


            startBlinking(3)

            break;

        case 'pdz':

            stopBlinking()

            imgAlert.visible = true;

            imgAlert.source = "qrc:/resources/sp_yellow_h.png"



            break;

        default:
            //switch alerts off

            stopBlinking()

            imgAlert.visible = false;

            //imgAlert.setProperty(0,"visible",false)
        }
     }



    property bool cond: true;
    id: page
    width: 300
    height: 200

    visible: true
    title: qsTr("Scroll")

    color: "blue"

    Image {

        id: imgAlert

        objectName: "objAlert"

        source:"qrc:/resources/sp_red_h.png"

        visible: false
    }

}
