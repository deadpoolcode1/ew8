import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQml.Models 2.3

Image {
    id: beam
    visible: true
    function setVisibleSlot() {beam.opacity = 1.0}
    function setInvisibleSlot() {beam.opacity = 0.0}

    anchors.verticalCenter: parent.verticalCenter
    fillMode: Image.PreserveAspectFit

    source: "images/status_bar/eyewatch_statusbar_ihc-01.png"
    property bool is_hi: true
    width: 15
    height: 18
    opacity: 1.0


/*
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
   */
}
