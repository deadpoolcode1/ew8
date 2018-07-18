import MyQMLenums 0.1


import QtQuick 2.9
//import mynamespace 1.0
import QtQuick.Controls 2.2


//import "qrc:/myfunctions.js" as MyScripts


ApplicationWindow {

    property var current_layerid: dummy_layer

    property int alert: Alert.ALERT_FCW


    function switchVisibility()
    {
        //imgAlert.visible = ((imgAlert.visible == true) ? false : true)
    }

/*

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


    function setAlert(msg, is_active)
    {

        switch(msg)
        {
        case 'pcw':


            current_layerid =  layer1;


            break;

        case 'pdz':

            current_layerid = layer0;


            break;

        case 'fcw':

            break;

        default:
            //switch alerts off

            current_layerid = dummy_layer;

        }
     }
*/


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
  property string myid: "status_panel"

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
    property  string  myid: "main_panel"

    objectName: "main_panel_root"

    visible: true


    Layer { id: dummy_layer }


    Layer_pcw {
        id: layer0;
        property int priority: 1;
        property string myid: "layer0";
    }

    Layer_pdz {id: layer1; property int priority: 0; property string myid: "layer1";}


}

    property var cur: main_panel.children[0];


    Component.onCompleted: {



        for(var i = 0; i < main_panel.children.length; ++i)
        {


           cur = main_panel.children[i];

            console.log("myid:"+cur.myid+""+cur.priority+"is_active:"+cur.is_active);

            if(main_panel.children[i].priority === 0)
            {
                console.log("got one with 0 priority")
            }


        }

     }
}
}
