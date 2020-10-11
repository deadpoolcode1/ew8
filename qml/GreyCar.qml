import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQml.Models 2.3

//Custom modules:
import MyQMLenums 0.1
import builtin.mobileye.QRCode 0.1

AnimatedImage {
    id: greyCar
    width: 133
    height: 51

    anchors.horizontalCenter: parent.horizontalCenter
    anchors.horizontalCenterOffset: 0
    fillMode: Image.PreserveAspectCrop
    visible: groupGAG.visible || groupCIPV.visible
    playing: visible
    z: 5
    anchors.bottom: parent.bottom
    source: "images/cars/grey_car_bright.png"


    
    function moveLeft(){console.log("moveLeft"); move.from = 0; move.to = -70; move.duration = 200; move.restart()}
    function moveRight(){console.log("moveRight"); move.from = 0; move.to = 70; move.duration = 200; move.restart()}
    function moveLeftReset(){console.log("moveLeftReset"); move.from = -70; move.to = 0; move.duration = 600; move.restart() }
    function moveRightReset(){console.log("moveRightReset");  move.from = 70; move.to = 0; move.duration = 600; move.restart() }
    
    NumberAnimation {
        id: move
        target: greyCar
        property: "anchors.horizontalCenterOffset"
        from: 0
        to: 70
        duration: 200
        easing.type: Easing.InOutQuad
    }    
}
