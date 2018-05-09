import QtQuick 2.9
import QtQuick.Controls 2.2


ApplicationWindow {

    function setAlert(msg)
    {

        switch(msg)
        {
        case 'pcw':

            //imgAlert.setProperty(0,"visible",true)
            //imgAlert.setProperty(0,"source","qrc:/resources/sp_yellow_h.png")

            imgAlert.visible = true;

            imgAlert.source = "qrc:/resources/sp_red_h.png"

            break;

        case 'pdz':

            //imgAlert.setProperty(0,"visible",true)
            //imgAlert.setProperty(0,"source","qrc:/resources/sp_red_h.png")

            imgAlert.visible = true;

            imgAlert.source = "qrc:/resources/sp_yellow_h.png"

            break;

        default:
            //switch alerts off

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

    }

    /*put Image here*/
}
