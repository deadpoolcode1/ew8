import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQml.Models 2.3

//Custom modules:
import MyQMLenums 0.1
import builtin.mobileye.QRCode 0.1

Image {
    id: beam
    function setVisibleSlot() {visible = true}
    function setInvisibleSlot() {visible = false}
    
    anchors.verticalCenter: parent.verticalCenter
    fillMode: Image.PreserveAspectFit
    source: "images/status_bar/eyewatch_statusbar_ihc-01.png"
    property bool is_hi: true



    states: [
        State {
            name: "Hi"; when: is_hi
            PropertyChanges {
                target: beam
                source: "images/status_bar/ihc_white-01.png"
            }
        },
        State {
            name: "Low"; when: !is_hi
            PropertyChanges {
                target: beam
                source: "images/status_bar/eyewatch_statusbar_ihc-01.png"
            }
        }
    ]
}
