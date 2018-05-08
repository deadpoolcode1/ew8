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

        id: imgAlert

        objectName: "objAlert"

        source:"qrc:/resources/sp_red_h.png"

    }

    /*put Image here*/
}
