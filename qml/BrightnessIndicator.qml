import QtQuick 2.9
//import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQml.Models 2.3

//Custom modules:
import MyQMLenums 0.1
import builtin.mobileye.QRCode 0.1

Rectangle
{
    width: 22
    height: 35
    color: "#00000000"
    border.color: "#00000000"

    property int level: 0x0

Image {
    id: level_icon

    source: "images/master-volume/m_mute.png"


}

states: [
    State {
        name: "Low"
        when: level < 3

        PropertyChanges {
            target: level_icon
            source: "images/master-volume/m_vol_low.png"
        }
    },
    State {
        name: "High"
        when:  level > 2

        PropertyChanges {
            target: level_icon
            source: "images/master-volume/m_vol_high.png"
        }
    }
]

}
