import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQml.Models 2.3



Row {

    property string label: "Label";
    property string value: "Value";
    property bool condition: false
    property string font_family
    property int pixelsize: 20


    property color black: "#ff191414"
    property color gray: "#ffcccccc"
    property color blue: "#ff00bfff"
    property color white: "#ffe1f1ff"

    Text {
        id: version_label
        color: gray
        text: label
        font.pixelSize: pixelsize
        font.family: font_family
        font.weight: Font.Light
        visible: condition
    }

    Text {
        id: version_text
        color: white
        text: value
        font.pixelSize: pixelsize
        font.family: font_family
        font.weight: Font.Light
        visible: condition
    }
}
