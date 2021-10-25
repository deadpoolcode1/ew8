import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQml.Models 2.3

Rectangle{
    id:signaltest

    property int curr_test_index;
    property int curr_test_state;
    property ListModel tests_model    
    property string feature_title: "     "

    visible: true

    property string canEntityType
    function setVisibleSlot(Result, Status) {
        curr_test_index = Status;
        curr_test_state = Result;
    }

    function setInvisibleSlot() {}

    width: 320
    height: 80
    color: "#00000000"
    border.color: "#00000000"


    property int layer_pri: 0

    property color red: "#ef000c"
    property color green: "#03f921"
    property color blue: "#5392ff"
    property color gray: "#99a0a6"
    property color white: "#ffffff"


    FontLoader { id: intelFont; source: "fonts/intelone-display-font-family-ttf/intelone-display-regular.ttf" }






    Row{
        id: row
        anchors.verticalCenter: parent.verticalCenter
         anchors.left: parent.left
         anchors.leftMargin: 0
         anchors.top: parent.top
         anchors.topMargin: 0



         Text {
             width: test_check.width * 2 / 3
             height: test_check.height
             id: test_name
             color: white
             z: 40
             text: feature_title
             wrapMode: Text.NoWrap
             verticalAlignment: Text.AlignVCenter
             style: Text.Raised
             anchors.verticalCenter: parent.verticalCenter
             font.letterSpacing: -1.0
             leftPadding: 0
             font.family: intelFont.name
             font.bold: true
         }

         Repeater {
             id: repeater
            model: tests_model
            visible: true

            PeripheralTestItem
            {
                anchors.verticalCenter: parent.verticalCenter
                wildcard: wildca
                my_title: titl

                //NOTE: When interval's right overpassed its tests result is green:
                test_status: (_right == curr_test_index)? curr_test_state : ((_right < curr_test_index)? (0) : (2))
                visible:  _left <= curr_test_index


            }

        }
    }

     PeripheralTestItem
     {
         id: test_check
         wildcard: "Empty"
         color: icon_color
         anchors.verticalCenter: parent.verticalCenter
         anchors.right: parent.right
        anchors.rightMargin: 0
        test_status: curr_test_state
        visible: curr_test_state != 2
     }
}









/*##^##
Designer {
    D{i:30;anchors_height:0;anchors_width:0}D{i:28;anchors_x:50;anchors_y:0}D{i:34;anchors_width:110}
D{i:41;anchors_x:0;anchors_y:0}D{i:38;anchors_width:110;anchors_x:9}D{i:42;invisible:true}
}
##^##*/
