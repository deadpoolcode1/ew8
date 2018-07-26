import MyQMLenums 0.1
import QtQuick 2.9
import QtQuick.Controls 2.2

ApplicationWindow {

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

    visible: true

    //tree instance:
    Item {
        id: group1

        property int layer_pri: 0

        visible: true

        ////////////////////////////////
        //Atomic items:
        Image { id: alert_pcw; visible: true; x: 000; y: 00; width: 300; height: 200; fillMode: Image.PreserveAspectFit;
               source:"qrc:/resources/EWAlerts/Artboard 88 copy 7.png"; rotation: 0;

               property int layer_pri: 0
               property int canEntitityType: Alert.ALERT_PCW
           }
        ///////////////////////////////

        //Groups:
        Item
        {
            id: group2

            property int layer_pri: 1

            visible: true


            ////////////////////////////////
            //Atomic items:

            Image { id: alert_fcw; visible: true; x: 000; y: 00; width: 300; height: 200; fillMode: Image.PreserveAspectFit;
                   source:"qrc:/resources/EWAlerts/Artboard 88 copy 6.png"; rotation: 0;

                   property int layer_pri: 0
                   property int canEntitityType: Alert.ALERT_FCW
               }
            ///////////////////////////////


            //Groups:
            Item
            {
               id: group3

               property int layer_pri: 1

               visible: true

               ////////////////////////////////
               //Atomic items:

               //TODO group lines with Items:

               Item {
                   id: alert_ldwoff; visible: true;


                   property int layer_pri: 2
                   property int canEntitityType: Alert.ALERT_LDWOFF

                   Image {visible: true; x: 000; y: 00; width: 300; height: 200; fillMode: Image.PreserveAspectFit;
                          source:"qrc:/resources/EWAlerts/Artboard 88 copy 3.png"; rotation: 0;
                      }

                   Image {visible: true; x: 000; y: 00; width: 300; height: 200; fillMode: Image.PreserveAspectFit;
                          source:"qrc:/resources/EWAlerts/Artboard 88 copy 2.png"; rotation: 0;
                      }
               }//LDWOFF

               Item {
                   id: alert_ldwon; visible: true;

                   property int layer_pri: 1
                   property int canEntitityType: Alert.ALERT_LDWON

                   Image { visible: true; x: 000; y: 00; width: 300; height: 200; fillMode: Image.PreserveAspectFit;
                          source:"qrc:/resources/EWAlerts/Artboard 88 copy.png"; rotation: 0;}

                   Image { visible: true; x: 000; y: 00; width: 300; height: 200; fillMode: Image.PreserveAspectFit;
                          source:"qrc:/resources/EWAlerts/Artboard 88.png"; rotation: 0;}

               }//LDWON

               Item {id: alert_lldw; visible: true;

                   property int layer_pri: 0
                   property int canEntitityType: Alert.ALERT_LLDW
                   
                   Image { visible: true; x: 000; y: 00; width: 300; height: 200; fillMode: Image.PreserveAspectFit;
                          source:"qrc:/resources/EWAlerts/Artboard 88 copy 5.png"; rotation: 0;}

                   Image { visible: true; x: 000; y: 00; width: 300; height: 200; fillMode: Image.PreserveAspectFit;
                          source:"qrc:/resources/EWAlerts/Artboard 88.png"; rotation: 0;}
               }
               }

               Item {id: alert_rldw; visible: true;

                   property int layer_pri: 0
                   property int canEntitityType: Alert.ALERT_RLDW

                   Image { visible: true; x: 000; y: 00; width: 300; height: 200; fillMode: Image.PreserveAspectFit;
                          source:"qrc:/resources/EWAlerts/Artboard 88 copy.png"; rotation: 0;}

                   Image { visible: true; x: 000; y: 00; width: 300; height: 200; fillMode: Image.PreserveAspectFit;
                          source:"qrc:/resources/EWAlerts/Artboard 88 copy 4.png"; rotation: 0
                      }
               }

               ///////////////////////////////


            }

            Item
            {
               id: group4

               property int layer_pri: 1

               visible: true

               ////////////////////////////////
               //Atomic items:
               Image { id: alert_pdz; visible: true; x: 000; y: 00; width: 300; height: 200; fillMode: Image.PreserveAspectFit;
                      source:"qrc:/resources/sp_yellow_h.png"; rotation: 90;

                      property int layer_pri: 0
                      property int canEntitityType: Alert.ALERT_PDZ
                  }
               ///////////////////////////////


            }


        }


    }



}

    Component.onCompleted: {
    //TBD
     }
}

