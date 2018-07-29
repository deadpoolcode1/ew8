import MyQMLenums 0.1
import QtQuick 2.9
import QtQuick.Controls 2.2

ApplicationWindow {


    property bool cond: true;
    id: page
    width: 320
    height: 240

    visible: true

    color: "blue"

Item {

    id: general_panel

    x: 0

    y: 0

    width: parent.width

    height: parent.height

    visible: true


Rectangle {
 id: left_panel

 objectName: "left_panel_root"


 color: "red"

 width: parent.width/5
 height: parent.height*9/10
 anchors.left: parent.left

 visible: true
}



Rectangle {
 id: right_panel

 objectName: "right_panel_root"

 color: "green"

 width: parent.width/5
 height: parent.height*9/10
 anchors.right: parent.right

 visible: true
}

Rectangle {
  id: status_panel

  objectName: "status_panel_root"

  width: parent.width
  height: parent.height/10
  anchors.top: parent.top

  visible: true
}

Rectangle {

    anchors.top: status_panel.bottom
    anchors.left: left_panel.right
    anchors.right: right_panel.left

    id: main_panel

    objectName: "main_panel_root"

    visible: false

    //tree instance:
    Item {
        id: group1
        objectName: "PCW_QtQG"
        property int layer_pri: 0

        property int canEntityType: Alert.QtQG

        visible: false

        ////////////////////////////////
        //Atomic items:
        Image {

            id: alert_pcw
            objectName: "PCW_ALERT"
            property int layer_pri: 0
            property int canEntityType: Alert.ALERT_PCW

            visible: false; x: 000; y: 00; width: 300; height: 200;
            fillMode: Image.PreserveAspectFit;
            source:"qrc:/resources/EWAlerts/Artboard 88 copy 7.png"; rotation: 0;

        }
        ///////////////////////////////

        //Groups:
        Item
        {
            id: group2
            objectName: "FCW_QtQG"

            property int canEntityType: Alert.QtQG

            property int layer_pri: 1

            visible: false


            ////////////////////////////////
            //Atomic items:

            Image {

                id: alert_fcw;
                objectName: "FCW_ALERT"
                property int layer_pri: 0
                property int canEntityType: Alert.ALERT_FCW

                visible: false; x: 000; y: 00; width: 300; height: 200;
                fillMode: Image.PreserveAspectFit;
                source:"qrc:/resources/EWAlerts/Artboard 88 copy 6.png"; rotation: 0;


            }


        }


    }



}

    Component.onCompleted: {
    //TBD
     }
}

}
