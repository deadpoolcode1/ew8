import QtQuick 2.9
//import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQml.Models 2.3

//Custom modules:
import MyQMLenums 0.1
import builtin.mobileye.QRCode 0.1

Item {
    id:test_group
    visible: false
    anchors.fill: parent
    
    property int canEntityType: Alert.QtQG
    property int layer_pri: 0
    z: 12
    function setVisibleSlot(){visible= true; console.log("LOGO BACKGROUND")}
    function setInvisibleSlot(){visible = false; console.log("LOGO BACKGROUND OFF")}
    
    antialiasing: true
    smooth: true
    
    Rectangle
    {
        id: rgb_red
        property string canEntityType: "RGB_RED"
        color : "red"
        
        property int layer_pri: 0
        function setVisibleSlot(){visible= true;}
        function setInvisibleSlot(){visible = false;}
        
        
        
        visible:true
        anchors.fill: parent
        
    }
    
    Rectangle
    {
        id: rgb_green
        property string canEntityType: "RGB_GREEN"
        color : "green"
        
        property int layer_pri: 0
        function setVisibleSlot(){visible= true;}
        function setInvisibleSlot(){visible = false;}
        
        
        
        visible: true
        anchors.fill: parent
        
    }
    
    Rectangle
    {
        id: rgb_blue
        property string canEntityType: "RGB_BLUE"
        color: "BLUE"
        
        property int layer_pri: 0
        function setVisibleSlot(){visible= true;}
        function setInvisibleSlot(){visible = false;}
        
        
        
        visible: true
        anchors.fill: parent
        
    }
    
    
    
    
    Image {
        id:tv_patern
        property string canEntityType: "TV_PATTERN"
        
        property int layer_pri: 0
        function setVisibleSlot(){visible= true;}
        function setInvisibleSlot(){visible = false;}
        
        
        
        visible: true
        anchors.fill: parent
        source: "images/test/SMPTE.jpg"
    }
}
