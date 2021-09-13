import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQml.Models 2.3

Image{
    id:signaltest

    property string canEntityType: "INFO_TEST_SIGNALS"
    function setVisibleSlot() {visible = true}
    function setInvisibleSlot() {visible = false}

    property bool modeGroup: true

    visible: true


    width: 320
    height: 240


    property int layer_pri: 0
    anchors.fill: parent

    source:  "images/signal-test/Background.png"


    //color: "black"

    ListModel{
        id: signals_model
        ListElement{property  string canType: "TEST_BRAKES"; property string wildca: "Brake" }
        ListElement{property  string canType: "TEST_WIPERS"; property string wildca: "Whip"}
        ListElement{property  string canType: "TEST_HIGH_BEAM"; property string wildca: "Lights"}
        ListElement{property  string canType: "TEST_BLINKER_LEFT"; property string wildca: "Left"}
        ListElement{property  string canType: "TEST_BLINKER_RIGHT"; property string wildca: "Right" }
        ListElement{property  string canType: "TEST_REVERSE"; property string wildca: "R"}
        ListElement{property  string canType: "TEST_SPEED"; property string wildca: "ER20"}
    }




   /*
    Row
    {
        id: upper_row

         property int layer_pri: 0

        height: 49
        anchors.left: parent.left
        anchors.leftMargin: 40
        anchors.top: parent.top
        anchors.topMargin: 12

    }

    Row
    {
        id: lower_row
        height: 49

        property int layer_pri: 0

        anchors.left: parent.left
        anchors.leftMargin: 40
        anchors.top: upper_row.bottom
        anchors.topMargin: 3
    }
    */

    Grid{
        rows: 2
        columns: 5

        height: 49
        spacing: 0
        anchors.left: parent.left
        anchors.leftMargin: 40
        anchors.top: parent.top
        anchors.topMargin: 12
        visible: true

    Repeater {
        model: signals_model

            SignalTestItem{

                property int layer_pri: 0

                //parent: index < 5? upper_row : lower_row
                canEntityType: canType
                wildcard: wildca
                //anchors.leftMargin: 0
                //anchors.verticalCenter: parent.verticalCenter
                isBig: false
            }
    }
    }

    Repeater {

         model: signals_model

        SignalTestItem {

            property int layer_pri: 0

            parent: signaltest

            width: 120
            height: 120
            isBig: true

            anchors.verticalCenterOffset: 49
            anchors.horizontalCenterOffset: 0
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            wildcard: wildca
            canEntityType: canType


        }



    }

}









/*##^##
Designer {
    D{i:30;anchors_height:0;anchors_width:0}D{i:28;anchors_x:50;anchors_y:0}D{i:34;anchors_width:110}
D{i:41;anchors_x:0;anchors_y:0}D{i:38;anchors_width:110;anchors_x:9}D{i:42;invisible:true}
}
##^##*/
