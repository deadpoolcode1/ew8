import QtQuick 2.0

Layer {

    visible: current_layerid === layer0;

Image {

   id: red0
   property string myid: "red0";

   x: parent.width/2
   y: parent.height/2


   width: parent.width/2
   height: parent.height/2

   fillMode: Image.PreserveAspectFit


   source:"qrc:/resources/sp_red_h.png"

   visible: true
}

Image {

   id: red1
   property string myid: "red0";

   anchors.leftMargin: 50

   anchors.topMargin: 50


   width: parent.width/2
   height: parent.height/2

   fillMode: Image.PreserveAspectFit

   source:"qrc:/resources/alfa_romeo_PNG75.png"

   visible: true
}

}


