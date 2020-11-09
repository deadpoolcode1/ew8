import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQml.Models 2.3

import MyQMLenums 0.1

Rectangle {
	id: ims_smartadas_restricted
	property int layer_pri: 1
    function setVisibleSlot(){visible = true; console.log("IMS_SmartADAS_Restricted PANEL")}
    function setInvisibleSlot(){visible = false; console.log("IMS_SmartADAS_Restricted PANEL OFF")}

    visible: true

    Item {
		id: groupTop
		objectName: "TOP_QtQG"
        property int canEntityType: Alert.QtQG
        property bool mutexGroup: true
        property int layer_pri: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0

        function setVisibleSlot() {visible = true}
		    function setInvisibleSlot() {visible = false}

        z: 5

        /*
        SequentialAnimation on z {

            running: groupTop.visibleChildren.length

            PropertyAction{
                value: 5
            }

            PauseAnimation {
                duration: 1200
            }

            PropertyAction{
                value: 3
            }
        }
        */


      SADAS {
            id: smart_crowded
            property string canEntityType: "SMART_CROWDED"
            property int layer_pri: 1
            source: "images/right-panel/SADAS/right_crowded.png"
		}

      SADAS {
            id: smart_ped_hwy
            property string canEntityType: "SMART_PED_HWY"
            property int layer_pri: 2
            source: "images/right-panel/SADAS/right_ped_highway.png"
        }

      SADAS {
            id: smart_cyc_hwy
            property string canEntityType: "SMART_CYC_HWY"
            property int layer_pri: 3
            source: "images/right-panel/SADAS/right_cyc_highway.png"
        }

      SADAS {
            id: smart_wea_road
            property string canEntityType: "SMART_WEA_ROAD"
            property int layer_pri: 5
            source: "images/right-panel/SADAS/right_w_road.png"
        }

      SADAS {
            id: smart_wea_wtr
            property string canEntityType: "SMART_WEA_HYDRO"
            property int layer_pri: 5
            source: "images/right-panel/SADAS/right_w_hydro.png"
        }


      SADAS {
            id: smart_wea_fg
            property string canEntityType: "SMART_WEA_FG"
            property int layer_pri: 6
            source: "images/right-panel/SADAS/right_w_fog.png"
        }


      SADAS {
            id: smart_wea_wnd
            property string canEntityType: "SMART_WEA_WND"
            property int layer_pri: 7
            source: "images/right-panel/SADAS/right_w_wind.png"
        }

      SADAS {
            id: smart_wea_ra
            property string canEntityType: "SMART_WEA_HAIL"
            property int layer_pri: 7
            source: "images/right-panel/SADAS/right_w_rain.png"
        }

      SADAS {
            id: smart_wea_tstm
            property string canEntityType: "SMART_WEA_TSTM"
            property int layer_pri: 7
            source: "images/right-panel/SADAS/right_w_lightening.png"
        }

      SADAS {
            id: smart_fatigue
            property string canEntityType: "SMART_FATIGUE"
            property int layer_pri: 8
            source: "images/right-panel/SADAS/right_fatigue.png"
        }

      SADAS {
            id: smart_bumpers
            property string canEntityType: "SMART_BUMPERS"
            property int layer_pri: 8
            source: "images/right-panel/SADAS/right_bumpers.png"
        }

      SADAS {
            id: smart_harsh_dz
            property string canEntityType: "SMART_HARSH_DZ"
            property int layer_pri: 4
            source: "images/right-panel/SADAS/right_harsh_acc.png"
        }
	}

    Item {
		id: groupBottom
		objectName: "BOTTOM_QtQG"
		property bool mutexGroup: false
		property int layer_pri: 0

        property int canEntityType: Alert.QtQG
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0

        z: 4

        visible: true

        function setVisibleSlot() {visible = true}
        function setInvisibleSlot() {visible = false}

        /*
        SideIcon
        {
            id: sign

            source:"images/right-panel/fms_alert.png"
            property string canEntityType: "FMS_ALERT"

            quadrant: 4
        }
        */
	}
}
/*##^##
Designer {
    D{height:165; width:110}
}
##^##*/
