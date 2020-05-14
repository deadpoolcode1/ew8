import QtQuick 2.9
//import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQml.Models 2.3

import MyQMLenums 0.1

Rectangle {
	id: ims_smartadas_restricted
	property int layer_pri: 1
	function setVisibleSlot(){visible= true; console.log("IMS_SmartADAS_Restricted PANEL")}
	function setInvisibleSlot(){visible = false; console.log("IMS_SmartADAS_Restricted PANEL OFF")}

	//color: "#00000000"
	//anchors.fill:parent
	visible: true

	Item {
		id: groupTop
		objectName: "TOP_QtQG"
        property int canEntityType: Alert.QtQG
        property bool mutexGroup: true
		property int layer_pri: 0

		function setVisibleSlot() {visible = true}
		function setInvisibleSlot() {visible = false}

        width: 80
        height: 80

		anchors.right: parent.right
		anchors.rightMargin: 0
		anchors.top: parent.top
		anchors.topMargin: 0

      SADAS {
            id: smart_crowded
            property string canEntityType: "SMART_CROWDED"
            property int layer_pri: 1
            source: "images/sadas/crowded-01.png"
		}

      SADAS {
            id: smart_ped_hwy
            property string canEntityType: "SMART_PED_HWY"
            property int layer_pri: 2
            source: "images/sadas/ped_highway-01.png"
        }

      SADAS {
            id: smart_cyc_hwy
            property string canEntityType: "SMART_CYC_HWY"
            property int layer_pri: 3
            source: "images/sadas/cyc_highway-01.png"
        }

      SADAS {
            id: smart_wea_road
            property string canEntityType: "SMART_WEA_ROAD"
            property int layer_pri: 5
            source: "images/sadas/w_road.png"
        }

      SADAS {
            id: smart_wea_wtr
            property string canEntityType: "SMART_WEA_HYDRO"
            property int layer_pri: 5
            source: "images/sadas/w_hydro-01.png"
        }


      SADAS {
            id: smart_wea_fg
            property string canEntityType: "SMART_WEA_FG"
            property int layer_pri: 6
            source: "images/sadas/w_fog-01.png"
        }


      SADAS {
            id: smart_wea_wnd
            property string canEntityType: "SMART_WEA_WND"
            property int layer_pri: 7
            source: "images/sadas/w_wind-01.png"
        }

      SADAS {
            id: smart_wea_ra
            property string canEntityType: "SMART_WEA_HAIL"
            property int layer_pri: 7
            source: "images/sadas/w_rain-01.png"
        }

      SADAS {
            id: smart_wea_tstm
            property string canEntityType: "SMART_WEA_TSTM"
            property int layer_pri: 7
            source: "images/sadas/w_lightening-01.png"
        }

      SADAS {
            id: smart_fatigue
            property string canEntityType: "SMART_FATIGUE"
            property int layer_pri: 8
            source: "images/sadas/fatigue.png"
        }

      SADAS {
            id: smart_bumpers
            property string canEntityType: "SMART_BUMPERS"
            property int layer_pri: 8
            source: "images/sadas/bumpers-01.png"
        }

      SADAS {
            id: smart_harsh_dz
            property string canEntityType: "SMART_HARSH_DZ"
            property int layer_pri: 4
            source: "images/sadas/harsh_dz.png"
        }


	}
	Item {
		id: groupBottom
		objectName: "BOTTOM_QtQG"
		property bool mutexGroup: false
		property int layer_pri: 0

        property int canEntityType: Alert.QtQG

        visible: true

        width: 80
        height: 80
		anchors.right: parent.right
		anchors.rightMargin: 0
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 0

	}
}
