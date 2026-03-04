import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQml.Models 2.3

//Custom modules:
import MyQMLenums 0.1
import builtin.mobileye.QRCode 0.1


Image {
    id: sadas_status
    anchors.top: parent.top
    anchors.topMargin: 0
    source: "images/status-bar/sadas/Far.png"
    width: 46
    height: 35

    property int distance: 3

    fillMode: Image.Stretch

    property int layer_pri: 0

    visible: false

    states: [
        State {
            name: "Near"; when: distance === 1
            PropertyChanges {
                target: sadas_status
                visible: true
                source: "images/status-bar/sadas/Near.png"
            }
        }
        ,
        State {
            name: "Mid"; when: distance === 2
            PropertyChanges {
                target: sadas_status
                visible: true
                source: "images/status-bar/sadas/Med.png"
            }
        }
        ,
        State {
            name: "Far"; when: distance === 3
            PropertyChanges {
                target: sadas_status
                visible: true
            }
        }
    ]

}
