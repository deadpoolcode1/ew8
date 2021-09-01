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
   property  string wildcard
   property bool hasRing: false
   property  bool isBig: false

   function setVisibleSlot(Arg) { test_status = Arg; hasRing = true}
   function setInvisibleSlot() {test_status = 0; hasRing = false}

    Image{

        z: 0

        id: ring_on

        visible: hasRing

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
            when: test_status == 1 && !isBig
            PropertyChanges {
                target: slot
                source: "images/signal-test/EW8_"+wildcard+"-blu.svg"

            }
        },
        State {
            name: "Grn"
            when: test_status == 2  && !isBig
            PropertyChanges {
                target: slot
                source: "images/signal-test/EW8_"+wildcard+"-grn.svg"
            }
        },
        State {
            name: "Red"
            when: test_status == 3  && !isBig
            PropertyChanges {
                target: slot
                source: "images/signal-test/EW8_"+wildcard+"-red.svg"
            }
        }
        ,
        State {
            name: "Gray_Big"
            when: test_status == 0 && isBig
            PropertyChanges {
                target: slot

                source: "images/signal-test/EW8_"+wildcard+"-gry_120x120.svg"

            }
        }
        ,
        State {
            name: "BlueBig"
            when: test_status == 1 && isBig
            PropertyChanges {
                target: slot

                source: "images/signal-test/EW8_"+wildcard+"-blu_120x120.svg"

            }
        },
        State {
            name: "Grn_Big"
            when: test_status == 2 && isBig
            PropertyChanges {
                target: slot

                source: "images/signal-test/EW8_"+wildcard+"-grn_120x120.svg"
            }
        },
        State {
            name: "Red_Big"
            when: test_status == 3  && isBig
            PropertyChanges {
                target: slot

                source: "images/signal-test/EW8_"+wildcard+"-red_120x120.svg"
            }
        }
    ]

}
