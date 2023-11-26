import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQml.Models 2.3


RowLayout {
    id: row_frame
    width: parent.width
    spacing: 0

    property string label: "Label";
    property string value: "Value";
    property bool condition: false
    property string font_family
    property int pixelsize: 16
    property int cellwidth: 100
    property int cellheight: 18



    property color black: "#ff191414"
    property color gray: "#ffcccccc"
    property color blue: "#ff00bfff"
    property color white: "#ffe1f1ff"

    visible: condition



    Rectangle {
        id: label_rectangle
        height: cellheight
        width: cellwidth
        color: black
        Text {
            id: version_label
            color: gray
            text: label + ":"
            font.pixelSize: pixelsize
            font.family: font_family
            font.weight: Font.Light
        }
    }

    Rectangle{
        height: cellheight
        width: cellwidth + 40
        color: black
        Text {
            id: version_text
            color: white
            text: value
            font.pixelSize: pixelsize
            font.family: font_family
            font.weight: Font.Light
        }
    }
}
