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
    width: 23
    height: 35
    color: "#00000000"
    border.color: "#00000000"

    property int level: 0x0

Image {
    id: level_icon

    width: 23
    height: 35

    fillMode: Image.PreserveAspectFit

    source: "images/brightness/brightness_high.png"


}

states: [
    State {
        name: "VeryLow"
        when: level === 1

        PropertyChanges {
            target: level_icon
            source: "images/brightness/brightness-0.png"
        }
    },
    State {
        name: "Low"
        when:  level === 2 || level === 3

        PropertyChanges {
            target: level_icon
            source: "images/brightness/brightness-1.png"
        }
    },
        State {
            name: "Half"
            when:  level === 4

            PropertyChanges {
                target: level_icon
                source: "images/brightness/brightness-3.png"
            }
    },
    State {
        name: "High"
        when:  level === 5

        PropertyChanges {
            target: level_icon
            source: "images/brightness/brightness-5.png"
        }
    }
]

}
