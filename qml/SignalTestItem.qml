import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQml.Models 2.3

Item {

    id: upp

    width: 49
    height: 49

    property int test_status: 0;
    property  string wildcard: "Brake"
    property bool isEnabled: false
    property bool isOn: false
    property  bool isBig: false
    property alias isSlotVisible: slot.visible
    property color icon_color: gray

    //Style constants:
    property color red: "#ef000c"
    property color green: "#03f921"
    property color blue: "#5392ff"
    property color gray: "#99a0a6"
    property color white: "#ffffff"

    visible: true

    function setVisibleSlot(Arg1, Arg2) {test_status = Arg1; isEnabled = true; isOn = (Arg2 === 1)}
    function setInvisibleSlot() {isEnabled = false; isOn = false}

    Image{
        id: slot
        anchors.fill: parent

        visible: !isBig

        z: 1


        fillMode: Image.PreserveAspectFit
        source: "images/signal-test/EW8_"+wildcard+"-gry.svg"
    }

    states: [

        State {
            name: "Blue"
            when: isEnabled && (test_status === 0 || test_status === 1) && !isBig && !isOn
            PropertyChanges {
                target: slot
                source: "images/signal-test/EW8_"+wildcard+"-blu.svg"

            }
            PropertyChanges {
                target: upp
                icon_color: blue
            }
        },
        State {
            name: "Grn"
            when: isEnabled && (test_status === 2)  && !isBig && !isOn
            PropertyChanges {
                target: slot
                source: "images/signal-test/EW8_"+wildcard+"-grn.svg"
            }
            PropertyChanges {
                target: upp
                icon_color: green
            }
        },
        State {
            name: "Red"
            when: isEnabled && (test_status === 3)  && !isBig && !isOn
            PropertyChanges {
                target: slot
                source: "images/signal-test/EW8_"+wildcard+"-red.svg"
            }
            PropertyChanges {
                target: upp
                icon_color: red
            }
        }
        ,
        State {
            name: "BlueOn"
            when: isEnabled && (test_status === 0 || test_status === 1) && !isBig && isOn
            PropertyChanges {
                target: slot
                source: "images/signal-test/EW8_"+wildcard+"-blu-on.svg"

            }
            PropertyChanges {
                target: upp
                icon_color: white
            }
        },
        State {
            name: "GrnOn"
            when: isEnabled && (test_status === 2)  && !isBig && isOn
            PropertyChanges {
                target: slot
                source: "images/signal-test/EW8_"+wildcard+"-grn-on.svg"
            }
            PropertyChanges {
                target: upp
                icon_color: white
            }
        },
        State {
            name: "RedOn"
            when: isEnabled && (test_status === 3)  && !isBig && isOn
            PropertyChanges {
                target: slot
                source: "images/signal-test/EW8_"+wildcard+"-red-on.svg"
            }
            PropertyChanges {
                target: upp
                icon_color: white
            }
        },
        //////////////////////////////////////////////
        State {
            name: "GrnBig"
            when: isEnabled && (test_status === 2) && isBig && !isOn
            PropertyChanges {
                target: slot
                source: "images/signal-test/EW8_"+wildcard+"-grn_120x120.svg"
            }
            PropertyChanges {
                target: slot
                visible: false
            }
            PropertyChanges {
                target: upp
                icon_color: green
            }
        },
        State {
            name: "GrnBigOn"
            when: isEnabled && (test_status === 2) && isBig && isOn
            PropertyChanges {
                target: slot
                source: "images/signal-test/EW8_"+wildcard+"-grn-on_120x120.svg"
            }
            PropertyChanges {
                target: slot
                visible: false
            }
            PropertyChanges {
                target: upp
                icon_color: white
            }
        },
        State {
            name: "RedBig"
            when: isEnabled && (test_status === 3) && isBig && !isOn
            PropertyChanges {
                target: slot
                source: "images/signal-test/EW8_"+wildcard+"-red_120x120.svg"
            }
            PropertyChanges {
                target: slot
                visible: false
            }
            PropertyChanges {
                target: upp
                icon_color: red
            }
        },
        State {
            name: "RedBigOn"
            when: isEnabled && (test_status === 3) && isBig && isOn
            PropertyChanges {
                target: slot
                source: "images/signal-test/EW8_"+wildcard+"-red-on_120x120.svg"
            }
            PropertyChanges {
                target: slot
                visible: false
            }
            PropertyChanges {
                target: upp
                icon_color: white
            }
        },
        State {
            name: "BlueBig"
            when: isEnabled && (test_status === 1) && isBig && !isOn
            PropertyChanges {
                target: slot
                source: "images/signal-test/EW8_"+wildcard+"-blu_120x120.svg"
            }
            PropertyChanges {
                target: slot
                visible: true
            }
            PropertyChanges {
                target: upp
                icon_color: blue
            }
        },
        State {
            name: "BlueBigOn"
            when: isEnabled && (test_status === 1) && isBig && isOn
            PropertyChanges {
                target: slot
                source: "images/signal-test/EW8_"+wildcard+"-blu-on_120x120.svg"
            }
            PropertyChanges {
                target: slot
                visible: true
            }
            PropertyChanges {
                target: upp
                icon_color: white
            }
        }
    ]
    transitions: [
        Transition {to: "RedBigOn";
            ParallelAnimation {
                PropertyAnimation {target: slot; property: "visible"; duration: 500}
                PropertyAnimation {target: slot; property: "source"; duration: 0}
            }
        }
        ,Transition {to: "RedBig";
            ParallelAnimation {
                PropertyAnimation {target: slot; property: "visible"; duration: 500}
                PropertyAnimation {target: slot; property: "source"; duration: 0}
            }
        }
        ,Transition {to: "GrnBigOn";
            ParallelAnimation {
                PropertyAnimation {target: slot; property: "visible"; duration: 500}
                PropertyAnimation {target: slot; property: "source"; duration: 0}
            }
        }
        ,Transition {to: "GrnBig";
            ParallelAnimation {
                PropertyAnimation {target: slot; property: "visible"; duration: 500}
                PropertyAnimation {target: slot; property: "source"; duration: 0}
            }
        }
    ]
}
