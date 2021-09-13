import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQml.Models 2.3

Item {

   id: upp

   width: 49
   height: 49


   property string canEntityType

   property int test_status: 0;
   property  string wildcard: "Brake"
   property bool isEnabled: false
   property bool hasRing: false
   property  bool isBig: false

   visible: true

   function setVisibleSlot(Arg1, Arg2) {test_status = Arg1; isEnabled = true; hasRing = ((Arg2 === 1)?true : false)}
   function setInvisibleSlot() {isEnabled = false; hasRing = false}

   Image{

       z: 0

       id: ring_on

       visible: hasRing && slot.visible

       anchors.fill: parent

       fillMode: Image.PreserveAspectFit
       source: isBig? "images/signal-test/EW8_Just_Ring_120x120.svg" : "images/signal-test/EW8_Just_Ring.svg"


   }



   Image{
       id: slot
       anchors.fill: parent


       z: 1


       fillMode: Image.PreserveAspectFit
       source: "images/signal-test/EW8_"+wildcard+"-gry.svg"
   }

   states: [

       State {
           name: "Blue"
           when: isEnabled && (test_status === 0 || test_status === 1) && !isBig
           PropertyChanges {
               target: slot
               source: "images/signal-test/EW8_"+wildcard+"-blu.svg"

           }
       },
       State {
           name: "Grn"
           when: isEnabled && (test_status === 2)  && !isBig
           PropertyChanges {
               target: slot
               source: "images/signal-test/EW8_"+wildcard+"-grn.svg"
           }
       },
       State {
           name: "Red"
           when: isEnabled && (test_status === 3)  && !isBig
           PropertyChanges {
               target: slot
               source: "images/signal-test/EW8_"+wildcard+"-red.svg"
           }
       }
       ,
       State {
           name: "InvisibleBig"
           when: (!isEnabled || test_status !== 1) && isBig
           PropertyChanges {
               target: slot
               visible: false
           }
       }
       ,
       State {
           name: "TestedBig"
           when: isEnabled && (test_status === 1) && isBig
           PropertyChanges {
               target: slot
               source: "images/signal-test/EW8_"+wildcard+"-blu_120x120.svg"
           }
           PropertyChanges {
               target: slot
               visible: true
           }
       }
   ]

}
