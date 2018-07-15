import QtQuick 2.0

Layer {

    visible: current_layerid === layer1;

    Image { id: yell0; visible: true; x: 000; y: 00; width: 300; height: 200; fillMode: Image.PreserveAspectFit;
        source:"qrc:/resources/camaro_PNG34.png";
    }

    Image {

        id: yell1

        anchors.leftMargin: 50

        anchors.topMargin: 50

        width: parent.width/2
        height: parent.height/2

        fillMode: Image.PreserveAspectFit

        source:"qrc:/resources/sp_yellow_h.png"

        visible: true
    }



    }
