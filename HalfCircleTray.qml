import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQml.Models 2.3
import com.mobileye 1.0


QQuickHalfCircleTray{

    id: id_circle

    //TODO add model, try to display in inner column

    width: background.width

    anchors.top: status_panel.bottom
    anchors.bottom: parent.bottom

    property string src_left: "../images/Containers/Circle_L@brd.png";
    property string src_right: "../images/Containers/Circle_R@brd.png";

    property string side;

    Image{
        objectName: "background"
        id: background
        fillMode: Image.PreserveAspectFit
        source: (side === "left")? src_left:src_right
        visible: true
    }
}


