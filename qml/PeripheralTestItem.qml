import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQml.Models 2.3

Rectangle {

    id: upp

    width: 60
    height: 60
    color: "#00000000"

    property int test_status: 3;
    property  string wildcard: "Empty"
    property alias isSlotVisible: slot.visible
    property color icon_color: gray

    //Style constants:
    property color red: "#ef000c"
    property color green: "#03f921"
    property color blue: "#5392ff"
    property color gray: "#99a0a6"
    property color white: "#ffffff"

    property string my_title: ""
    property string base: "images/peripheral-test/Peripherals_"

    visible: true

    Image{
        id: slot
        anchors.fill: parent

        visible: test_status < 3

        z: 1


        fillMode: Image.PreserveAspectFit
        source: base+wildcard+"_grn.png"
    }

    states: [

        State {
            name: "Grn"
            when: (test_status === 0)
            PropertyChanges {
                target: slot
                source: base+wildcard+"_grn.png"
            }
            PropertyChanges {
                target: upp
                icon_color: green
            }
        },
        State {
            name: "Red"
            when: (test_status === 1)
            PropertyChanges {
                target: slot
                source: base+wildcard+"_red.png"
            }
            PropertyChanges {
                target: upp
                icon_color: red
            }
        },
        State {
            name: "Blue"
            when:  (test_status === 2)
            PropertyChanges {
                target: slot
                source: base+wildcard+"_blu.png"

            }
            PropertyChanges {
                target: upp
                icon_color: blue
            }
        }

   ]

}
