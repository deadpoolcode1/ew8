import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQml.Models 2.3

Image{
    id:peripheral_tests

    property string canEntityType: "INFO_TEST_PERIPHERALS"
    function setVisibleSlot() {visible = true}
    function setInvisibleSlot() {visible = false}


    property bool modeGroup: true

    visible: true


    width: 320
    height: 240


    property int layer_pri: 0
    anchors.fill: parent

    source:  "images/peripheral-test/Peripherals_Test_Background.svg"


    PeripheralTestGroup{

        feature_title: "Gsm  "

        canEntityType: "INFO_TEST_GSM"
        height: 80
        id: gsm
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.left: parent.left
        tests_model:
            ListModel{
            ListElement{property string titl: "Module"; property string wildca: "Test_GSM_1"; property int _left: 1; property int _right: 3}
            ListElement{property string titl: "N/W"; property string wildca: "Test_GSM_2"; property int _left: 4; property int _right: 7}
            ListElement{property string titl: "Upload"; property string wildca: "Test_GSM_3"; property int _left: 8; property int _right: 9}
        }
    }

    PeripheralTestGroup{

        feature_title: "Gps  "

        canEntityType: "INFO_TEST_GPS"
        height: 80
        id: gps
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        tests_model:
            ListModel{
            ListElement{property string titl: "MSGs";property string wildca: "Test_GPS_1"; property int _left: 1; property int _right: 2}
            ListElement{property string titl: "Locked";property string wildca: "Test_GPS_2"; property int _left: 3; property int _right: 4}
        }
    }


    PeripheralTestGroup{

        feature_title: "Gyro "

        canEntityType: "INFO_TEST_GYRO"
        height: 80
        id: gyro
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
         tests_model:
             ListModel{
             ListElement{property string titl: "MSG";property string wildca: "Test_Gyro_1"; property int _left: 1; property int _right: 1}
             ListElement{property string titl: "Range";property string wildca: "Test_Gyro_2"; property int _left: 2; property int _right: 2}
         }

    }

}









/*##^##
Designer {
    D{i:30;anchors_height:0;anchors_width:0}D{i:28;anchors_x:50;anchors_y:0}D{i:34;anchors_width:110}
D{i:41;anchors_x:0;anchors_y:0}D{i:38;anchors_width:110;anchors_x:9}D{i:42;invisible:true}
}
##^##*/
