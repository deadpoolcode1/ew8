import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQml.Models 2.3


Item{

    id: hmw_item

    function setVisibleSlot(arg) {setVisible(true); canEntityArg = arg}
    function setInvisibleSlot() {setVisible(false)}

    function setVisible(isVisible)
    {
        visible = isVisible
    }

    property int canEntityArg: 0x00

    property url vehicle_source;
    property url strips_source;
    property color text_color;



    visible: false;

    y: 20

    x: main_panel.width/8;

    width: main_panel.width*3/4;

    height: main_panel.height*4/5

    Image{

        id: vehicle_img
        visible: true
        width: main_panel.width*3/4;
        fillMode: Image.PreserveAspectFit;
        source: vehicle_source
        rotation: 0;

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top : parent.top

    }

    Rectangle{
    //Padding
    id: padding_img
    anchors.top : vehicle_img.bottom
    height: 20;
    }

    Image{

        id: strips_img

        visible: true
        width: main_panel.width*3/4;
        fillMode: Image.PreserveAspectFit;
        source: strips_source
        scale: 3
        rotation: 0;

        property int canEntityArg: parent.canEntityArg

        anchors.horizontalCenter: parent.horizontalCenter
        //anchors.bottom: parent.bottom
        anchors.top : vehicle_img.bottom




    }

    Rectangle{

        transform: Scale{origin.x: 43; origin.y: 0; yScale: 3}

        anchors.horizontalCenter: strips_img.horizontalCenter
        anchors.verticalCenter:  strips_img.verticalCenter

    Text {

        visible: true
        width: main_panel.width*3/4;



        text: (hmw_item.canEntityArg == 0x00 ? "  " : (hmw_item.canEntityArg/10).toFixed(1))
        font.family: "Helvetica"
        font.pointSize: 45
        font.bold: true
        font.weight: Font.Black
        color: text_color
        opacity: 1
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter:  parent.verticalCenter

        transform: Rotation {
            origin.x: 43; origin.y: 43; axis { x: 1; y: 0; z: 0 } angle: 80
        }
    }

    }




}
