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
    property bool is_in_alert: false

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

        z: (smart_crowded.sign_visible? smart_crowded.z : 1)
             * (smart_ped_hwy.sign_visible? smart_ped_hwy.z : 1)
             * (smart_cyc_hwy.sign_visible? smart_cyc_hwy.z : 1)
             * (smart_wea_road.sign_visible? smart_wea_road.z : 1)
             * (smart_wea_wtr.sign_visible? smart_wea_wtr.z : 1)
             * (smart_wea_fg.sign_visible? smart_wea_fg.z : 1)
             * (smart_wea_wnd.sign_visible? smart_wea_wnd.z : 1)
             * (smart_wea_ra.sign_visible? smart_wea_ra.z : 1)
             * (smart_wea_tstm.sign_visible? smart_wea_tstm.z : 1)
             * (smart_harsh_dz.sign_visible? smart_harsh_dz.z : 1)



      SADAS {
            id: smart_crowded
            is_in_alert: ims_smartadas_restricted.is_in_alert
            property string canEntityType: "SMART_CROWDED"
            property int layer_pri: 1
            source: "images/right-panel/SADAS/right_crowded.png"
      }

      SADAS {
            id: smart_ped_hwy
            is_in_alert: ims_smartadas_restricted.is_in_alert
            property string canEntityType: "SMART_PED_HWY"
            property int layer_pri: 2
            source: "images/right-panel/SADAS/right_ped_highway.png"
        }

      SADAS {
            id: smart_cyc_hwy
            is_in_alert: ims_smartadas_restricted.is_in_alert
            property string canEntityType: "SMART_CYC_HWY"
            property int layer_pri: 3
            source: "images/right-panel/SADAS/right_cyc_highway.png"
        }

      SADAS {
            id: smart_wea_road
            is_in_alert: ims_smartadas_restricted.is_in_alert
            property string canEntityType: "SMART_WEA_ROAD"
            property int layer_pri: 5
            source: "images/right-panel/SADAS/right_w_road.png"
        }

      SADAS {
            id: smart_wea_wtr
            is_in_alert: ims_smartadas_restricted.is_in_alert
            property string canEntityType: "SMART_WEA_HYDRO"
            property int layer_pri: 5
            source: "images/right-panel/SADAS/right_w_hydro.png"
        }


      SADAS {
            id: smart_wea_fg
            is_in_alert: ims_smartadas_restricted.is_in_alert
            property string canEntityType: "SMART_WEA_FG"
            property int layer_pri: 6
            source: "images/right-panel/SADAS/right_w_fog.png"
        }


      SADAS {
            id: smart_wea_wnd
            is_in_alert: ims_smartadas_restricted.is_in_alert
            property string canEntityType: "SMART_WEA_WND"
            property int layer_pri: 7
            source: "images/right-panel/SADAS/right_w_wind.png"
        }

      SADAS {
            id: smart_wea_ra
            is_in_alert: ims_smartadas_restricted.is_in_alert
            property string canEntityType: "SMART_WEA_HAIL"
            property int layer_pri: 7
            source: "images/right-panel/SADAS/right_w_hail.png"
        }

      SADAS {
            id: smart_wea_tstm
            is_in_alert: ims_smartadas_restricted.is_in_alert
            property string canEntityType: "SMART_WEA_TSTM"
            property int layer_pri: 7
            source: "images/right-panel/SADAS/right_w_lightening.png"
        }


      SADAS {
            id: smart_harsh_dz
            is_in_alert: ims_smartadas_restricted.is_in_alert
            property string canEntityType: "SMART_HARSH_DZ"
            property int layer_pri: 4
            source: "images/right-panel/SADAS/right_harsh_break.png"
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

        z: 2

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
        SADAS2 {
            id: smart_crowded_sec
            is_in_alert: ims_smartadas_restricted.is_in_alert
            property string canEntityType: "SMART_CROWDED_SEC"
            property int layer_pri: 1
            source: "images/right-panel/SADAS/right_crowded.png"
        }

        SADAS2 {
            id: smart_ped_hwy_sec
            is_in_alert: ims_smartadas_restricted.is_in_alert
            property string canEntityType: "SMART_PED_HWY_SEC"
            property int layer_pri: 2
            source: "images/right-panel/SADAS/right_ped_highway.png"
        }

        SADAS2 {
            id: smart_cyc_hwy_sec
            is_in_alert: ims_smartadas_restricted.is_in_alert
            property string canEntityType: "SMART_CYC_HWY_SEC"
            property int layer_pri: 3
            source: "images/right-panel/SADAS/right_cyc_highway.png"
        }

        SADAS2 {
            id: smart_wea_road_sec
            is_in_alert: ims_smartadas_restricted.is_in_alert
            property string canEntityType: "SMART_WEA_ROAD_SEC"
            property int layer_pri: 5
            source: "images/right-panel/SADAS/right_w_road.png"
        }

        SADAS2 {
            id: smart_wea_wtr_sec
            is_in_alert: ims_smartadas_restricted.is_in_alert
            property string canEntityType: "SMART_WEA_HYDRO_SEC"
            property int layer_pri: 5
            source: "images/right-panel/SADAS/right_w_hydro.png"
        }


        SADAS2 {
            id: smart_wea_fg_sec
            is_in_alert: ims_smartadas_restricted.is_in_alert
            property string canEntityType: "SMART_WEA_FG_SEC"
            property int layer_pri: 6
            source: "images/right-panel/SADAS/right_w_fog.png"
        }


        SADAS2 {
            id: smart_wea_wnd_sec
            is_in_alert: ims_smartadas_restricted.is_in_alert
            property string canEntityType: "SMART_WEA_WND_SEC"
            property int layer_pri: 7
            source: "images/right-panel/SADAS/right_w_wind.png"
        }

        SADAS2 {
            id: smart_wea_ra_sec
            is_in_alert: ims_smartadas_restricted.is_in_alert
            property string canEntityType: "SMART_WEA_HAIL_SEC"
            property int layer_pri: 7
            source: "images/right-panel/SADAS/right_w_hail.png"
        }

        SADAS2 {
            id: smart_wea_tstm_sec
            is_in_alert: ims_smartadas_restricted.is_in_alert
            property string canEntityType: "SMART_WEA_TSTM_SEC"
            property int layer_pri: 7
            source: "images/right-panel/SADAS/right_w_lightening.png"
        }


        SADAS2 {
            id: smart_harsh_dz_sec
            is_in_alert: ims_smartadas_restricted.is_in_alert
            property string canEntityType: "SMART_HARSH_DZ_SEC"
            property int layer_pri: 4
            source: "images/right-panel/SADAS/right_harsh_break.png"
        }

    }
}
/*##^##
Designer {
    D{height:165; width:110}
}
##^##*/
