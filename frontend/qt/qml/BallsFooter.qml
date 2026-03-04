import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQml.Models 2.3


Rectangle {
    property int current: 0
    property int quantity: 3
    property int ballradius: 14

    property color black: "#ff191414"
    property color gray: "#ffcccccc"
    property color blue: "#ff00bfff"
    property color white: "#ffe1f1ff"

    color: "#00000000"


    width: line.width
    height: ballradius * 2.2

    Row {
        id: line

        anchors.top: parent.top

        spacing: ballradius

        Repeater{
            model: quantity
            delegate: Rectangle {
                width: ballradius
                height: ballradius
                radius: ballradius
                color: index === current ? blue : gray
            }
        }
    }
}








