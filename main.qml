import QtQuick 2.9
import QtQuick.Controls 2.2


ApplicationWindow {


    property bool cond: true;
    id: page
    width: 300
    height: 200

    visible: true
    title: qsTr("Scroll")

    color: "blue"

    Image {


        function setAlert(msg)
        {

            console.log("Received alert type:",msg)

            switch(msg)
            {
            case 'pcw':

                imgAlert.setProperty(index,"visible",true)
                imgAlert.setProperty(index,"source","qrc:/resources/sp_yellow_h.png")

                break;

            case 'pdz':

                imgAlert.setProperty(index,"visible",true)
                imgAlert.setProperty(index,"source","qrc:/resources/sp_red_h.png")

                break;

            default:
                //switch alerts off
                imgAlert.setProperty(index,"visible",false)
            }
         }


        id: imgAlert

        objectName: "objAlert"

        source:"qrc:/resources/sp_red_h.png"

    }

    /*put Image here*/
}
