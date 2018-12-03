import MyQMLenums 0.1
import com.mobileye.QRCode 0.1
import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

ApplicationWindow {

    id: page

    objectName: "AppWindow"

    signal itemSelfDeactivated(int canEntityType, string _objectName)

     /*
    //WARNING: used in ticks protocol
    //WARNING: the [indices] are just mnemonics
    property var hmw_nums_arr: [
            [Alert.HMW_01] = "0.1",
            [Alert.HMW_02] = "0.2",
            [Alert.HMW_03] = "0.3",
            [Alert.HMW_04] = "0.4",
            [Alert.HMW_05] = "0.5",
            [Alert.HMW_06] = "0.6",
            [Alert.HMW_07] = "0.7",
            [Alert.HMW_08] = "0.8",
            [Alert.HMW_09] = "0.9",
            [Alert.HMW_10] = "1.0",
            [Alert.HMW_12] = "1.2",
            [Alert.HMW_14] = "1.4",
            [Alert.HMW_16] = "1.6",
            [Alert.HMW_18] = "1.8",
            [Alert.HMW_20] = "2.0",
            [Alert.HMW_25] = "2.5",
            [Alert.HMW_GR] = "  ",
            ]
     */

    //WARNING: the [indices] are just mnemonics
    property var sli_arr: [
        [Alert.SLI_10]  =  "10",
        [Alert.SLI_20]  =  "20",
        [Alert.SLI_30]  =  "30",
        [Alert.SLI_40]  =  "40",
        [Alert.SLI_50]  =  "50",
        [Alert.SLI_60]  =  "60",
        [Alert.SLI_70]  =  "70",
        [Alert.SLI_80]  =  "80",
        [Alert.SLI_90]  =  "90",
        [Alert.SLI_100] = "100",
        [Alert.SLI_110] = "110",
        [Alert.SLI_120] = "120",
        [Alert.SLI_130] = "130",
        [Alert.SLI_140] = "140",
    ]



    width: 320
    height: 240

    //width: 800
    //height: 640

    visible: true

    color: "black"

    Component.onCompleted: {
        // page.showMaximized();
    }



    Item {

        id: general_panel

        x: 0

        y: 0

        width: 320

        height: 240

        visible: true




        Rectangle {
            id: status_panel

            color: "#19191a"

            objectName: "status_panel_root"

            width: parent.width
            height: parent.height/7
            anchors.top: parent.top

            visible: true
        }

        Rectangle {
            id: left_panel

            objectName: "left_panel_root"


            color: "#191919"

            width: 50
            anchors.top: status_panel.bottom
            anchors.left: parent.left
            anchors.bottom: parent.bottom

            visible: true

            Column {
                spacing:5
                id: groupSliSide
                objectName: "SLI_SIDE_QtQG"
                property bool mutexGroup: false

                function setVisibleSlot() {setVisible(true)}
                function setInvisibleSlot() {setVisible(false)}

                function setVisible(isVisible)
                {
                    visible = isVisible
                }

                property int layer_pri: 0
                property int canEntityType: Alert.QtQG

                visible: false;


                TSR {
                    //general features
                    id: alert_sli_side;
                    objectName: "ALERT_SLI_SIDE"
                    property int layer_pri: 0
                    canEntityType: Alert.ALERT_SLI
                    canEntityArg: Alert.SLI_100

                    //special features
                    is_main: false
                    its_pair_alert: alert_sli_main
                    source:"../images/EWAlerts/sli.png";

                    //TODO move text to TSR_SLI
                    Text {
                        text: page.sli_arr[parent.canEntityArg]
                        font.family: "Arial"
                        font.pointSize: parent.is_main ? 40 : 10
                        font.bold: true
                        color: "black"
                        opacity: 1
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter : parent.verticalCenter
                    }
                }


                TSR {

                    //general features
                    id: alert_forward_side;
                    objectName: "ALERT_SLI_SIDE"
                    property int layer_pri: 0
                    canEntityType: Alert.ALERT_FORWARD

                    //special features
                    is_main: false
                    its_pair_alert: alert_forward_main
                    source:"../images/EWAlerts/forward.svg";

                }



                Image {

                    function setVisibleSlot() {setVisible(true)}
                    function setInvisibleSlot() {setVisible(false)}

                    function setVisible(isVisible)
                    {
                        visible = isVisible
                    }

                    visible: false

                    id: alert_motorway_side;
                    objectName: "ALERT_MOTORWAY_SIDE"
                    property int layer_pri: 0
                    property int canEntityType: Alert.ALERT_MOTORWAY

                    x: left_panel.width/8; width: left_panel.width*3/4;
                    fillMode: Image.PreserveAspectFit;
                    source:"../images/EWAlerts/motorway.svg";
                    rotation: 0;
                }
                Image {

                    function setVisibleSlot() {setVisible(true)}
                    function setInvisibleSlot() {setVisible(false)}

                    function setVisible(isVisible)
                    {
                        visible = isVisible
                    }

                    visible: false

                    id: alert_playground_side;
                    objectName: "ALERT_PLAYGROUND_SIDE"
                    property int layer_pri: 0
                    property int canEntityType: Alert.ALERT_PLAYGROUND

                    x: left_panel.width/8; width: left_panel.width*3/4;
                    fillMode: Image.PreserveAspectFit;
                    source:"../images/EWAlerts/playground.svg";
                    rotation: 0;
                }

                TSR {

                    //general features
                    id: alert_no_pass_side;
                    objectName: "ALERT_NO_PASS_SIDE"
                    property int layer_pri: 0
                    canEntityType: Alert.ALERT_NO_PASS

                    //special features
                    is_main: false
                    its_pair_alert: alert_no_pass_main
                    source:"../images/EWAlerts/no_pass.svg";

                }

                Image {

                    function setVisibleSlot() {setVisible(true)}
                    function setInvisibleSlot() {setVisible(false)}

                    function setVisible(isVisible)
                    {
                        visible = isVisible
                    }

                    visible: false

                    id: alert_end_all_restr_side;
                    objectName: "ALERT_END_ALL_RESTR_SIDE"
                    property int layer_pri: 0
                    property int canEntityType: Alert.ALERT_END_ALL_RESTR

                    x: left_panel.width/8; width: left_panel.width*3/4;
                    fillMode: Image.PreserveAspectFit;
                    source:"../images/EWAlerts/end_all_restr.svg";
                    rotation: 0;
                }
                //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
            }





        }


        Rectangle {
            id: right_panel

            objectName: "right_panel_root"

            color: "#191919"

            width: 50
            anchors.top: status_panel.bottom
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            visible: true


            Column
            {

                SmartItem {

                    //general features
                    id: smart_animal_side;
                    objectName: "SMART_ANIMAL_SIDE"
                    property int layer_pri: 0
                    canEntityType: Alert.SMART_ANIMAL

                    //special features
                    is_main: false
                    its_pair_alert: smart_animal_main
                    source:"../images/SmartAlerts/animal.svg";

                }

                SmartItem {

                    //general features
                    id: smart_slippery_side;
                    objectName: "SMART_SLIPPERY_SIDE"
                    property int layer_pri: 0
                    canEntityType: Alert.SMART_SLIPPERY

                    //special features
                    is_main: false
                    its_pair_alert: smart_slippery_main
                    source:"../images/SmartAlerts/slippery.svg";

                }


                SmartItem {

                    //general features
                    id: smart_sev_weather_side;
                    objectName: "SMART_SEV_WEATHER_SIDE"
                    property int layer_pri: 0
                    canEntityType: Alert.SMART_SEV_WEATHER

                    //special features
                    is_main: false
                    its_pair_alert: smart_sev_weather_main
                    source:"../images/SmartAlerts/severWeather.svg";

                }

            }

        }



        Rectangle {

            anchors.left: left_panel.right
            anchors.right: right_panel.left
            anchors.top: status_panel.bottom
            anchors.bottom: parent.bottom



            id: main_panel

            objectName: "main_panel_root"
            property int canEntityType: Alert.QtQG
            property bool mutexGroup: false

            color: "black"

            visible: true


            //tree instance:
            Item {
                id: group1
                objectName: "PCW_QtQG"
                property bool mutexGroup: false

                anchors.fill: parent

                property int layer_pri: 0

                property int canEntityType: Alert.QtQG

                function setVisibleSlot() {setVisible(true)}
                function setInvisibleSlot() {setVisible(false)}

                function setVisible(isVisible)
                {
                    visible = isVisible
                }

                visible: false

                ////////////////////////////////
                //Atomic items:
                Image {

                    id: alert_pcw
                    objectName: "PCW_ALERT"
                    property int layer_pri: 0
                    property int canEntityType: Alert.ALERT_PCW

                    function setVisibleSlot() {setVisible(true)}
                    function setInvisibleSlot() {setVisible(false)}

                    function setVisible(isVisible)
                    {
                        visible = isVisible
                    }

                    visible: false;
                    x: 0; y: 20; width: 210; height: 140;
                    fillMode: Image.PreserveAspectFit;
                    source:"../images/EWAlerts/pcw.png";
                    rotation: 0;

                }
                ///////////////////////////////

                //Groups:
                Item
                {
                    id: group2
                    objectName: "FCW_QtQG"
                    property bool mutexGroup: false

                    property int canEntityType: Alert.QtQG

                    property int layer_pri: 1


                    function setVisibleSlot() {setVisible(true)}
                    function setInvisibleSlot() {setVisible(false)}

                    function setVisible(isVisible)
                    {
                        visible = isVisible
                    }
                    visible: false

                    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                    //Groups:
                    Item
                    {
                        id: group4
                        objectName: "PDZ_QtQG"
                        property bool mutexGroup: false

                        property int canEntityType: Alert.QtQG

                        property int layer_pri: 1

                        function setVisibleSlot() {setVisible(true)}
                        function setInvisibleSlot() {setVisible(false)}

                        function setVisible(isVisible)
                        {
                            visible = isVisible
                        }
                        visible: false

                    }



                    //Atomic items:
                    Image {

                        function setVisibleSlot() {setVisible(true)}
                        function setInvisibleSlot() {setVisible(false)}

                        function setVisible(isVisible)
                        {
                            //blinkTimer_fcw.setRunning(isVisible)
                            visible = isVisible
                        }

                        id: alert_pdz;
                        objectName: "PDZ_ALERT"
                        property int layer_pri: 1
                        property int canEntityType: Alert.ALERT_PDZ
                        opacity: 1.0

                        visible: false;
                        x: main_panel.width/8; y: 20; width: main_panel.width*3/4;
                        fillMode: Image.PreserveAspectFit;
                        source:"../images/EWAlerts/pdz.png";
                        rotation: 0;

                        SequentialAnimation {

                                running: alert_pdz.visible
                                loops: Animation.Infinite

                                PauseAnimation {duration: 300}
                                SmoothedAnimation { target: alert_pdz; property: "opacity"; from: 1.0; to: 0.0; duration: 100}
                                PauseAnimation {duration: 200}
                                SmoothedAnimation { target: alert_pdz; property: "opacity"; from: 0.0; to: 1.0; duration: 200}

                        }

                    }



                    ////////////////////////////////
                    //Atomic items:

                    QRCode{

                        function setVisibleSlot() {visible = true}
                        function setInvisibleSlot() {visible = false}

                         x: main_panel.width/8; y: 20; width: main_panel.width*3/4; height: width;

                        //x:20; y:20; width: 210; height: 210


                        id: alert_qrcode;
                        objectName: "QRCODE"
                        property int layer_pri: 0
                        property int canEntityType: Alert.ALERT_FCW


                        visible: false;
                        rotation: 0;
                    }



                    Image {

                        function setVisibleSlot() {setVisible(true)}
                        function setInvisibleSlot() {setVisible(false)}

                        function setVisible(isVisible)
                        {
                            //blinkTimer_fcw.setRunning(isVisible)
                            visible = isVisible
                        }

                        id: alert_fcw;
                        objectName: "FCW_ALERT"
                        property int layer_pri: 0
                        //property int canEntityType: Alert.ALERT_FCW
                        opacity: 1.0

                        visible: false;
                        x: main_panel.width/8; y: 20; width: main_panel.width*3/4;
                        fillMode: Image.PreserveAspectFit;
                        source:"../images/EWAlerts/fcw.png";
                        rotation: 0;

                        SequentialAnimation {

                                running: alert_fcw.visible
                                loops: Animation.Infinite


/*
                                PropertyAction {target: alert_fcw; property: "opacity"; value: 1.0}
                                PauseAnimation {duration: 500}
                                PropertyAction {target: alert_fcw; property: "opacity"; value: 0.0}
                                PauseAnimation {duration: 300}
*/


                                PauseAnimation {duration: 300}
                                SmoothedAnimation { target: alert_fcw; property: "opacity"; from: 1.0; to: 0.0; duration: 100}
                                PauseAnimation {duration: 200}
                                SmoothedAnimation { target: alert_fcw; property: "opacity"; from: 0.0; to: 1.0; duration: 200}
                        }

                        /*
                        Timer {

                            id: blinkTimer_fcw

                            property int intervalOn: 500
                            property int intervalOff: 300

                            interval: intervalOn
                            running: false
                            repeat: true

                            function setRunning(On)
                            {
                                interval = intervalOn
                                running = On
                            }


                            onTriggered:
                            {
                                parent.visible = !parent.visible
                                interval = (parent.visible ? intervalOn : intervalOff)
                            }

                        }
                        */

                    }

                    TSR {
                        //general features
                        id: alert_sli_main;
                        objectName: "ALERT_SLI_MAIN"
                        property int layer_pri: 1
                        canEntityType: Alert.ALERT_SLI
                        canEntityArg: Alert.SLI_100

                        //special features
                        is_main: true
                        its_pair_alert: alert_sli_side
                        source:"../images/EWAlerts/sli.png";

                        //TODO move text to TSR_SLI
                        Text {
                            text: page.sli_arr[parent.canEntityArg]
                            font.family: "Arial"
                            font.pointSize: parent.is_main ? 40 : 10
                            font.bold: true
                            color: "black"
                            opacity: 1
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter : parent.verticalCenter
                        }
                    }

                    TSR {

                        //general features
                        id: alert_forward_main;
                        objectName: "ALERT_SLI_MAIN"
                        property int layer_pri: 1
                        canEntityType: Alert.ALERT_FORWARD

                        //special features
                        is_main: true
                        its_pair_alert: alert_forward_side
                        source:"../images/EWAlerts/forward.svg";

                    }

                    TSR {

                        //general features
                        id: alert_no_pass_main;
                        objectName: "ALERT_NO_PASS_MAIN"
                        property int layer_pri: 1
                        canEntityType: Alert.ALERT_NO_PASS

                        //special features
                        is_main: true
                        its_pair_alert: alert_no_pass_side
                        source:"../images/EWAlerts/no_pass.svg";

                    }

                    SmartItem {

                        //general features
                        id: smart_animal_main;
                        objectName: "SMART_ANIMAL_MAIN"
                        property int layer_pri: 0
                        canEntityType: Alert.SMART_ANIMAL

                        //special features
                        is_main: true
                        its_pair_alert: smart_animal_side
                        source:"../images/SmartAlerts/animal.svg";

                    }

                    SmartItem {

                        //general features
                        id: smart_slippery_main;
                        objectName: "SMART_SLIPPERY_MAIN"
                        property int layer_pri: 0
                        canEntityType: Alert.SMART_SLIPPERY

                        //special features
                        is_main: true
                        its_pair_alert: smart_slippery_side
                        source:"../images/SmartAlerts/slippery.svg";

                    }

                    SmartItem {

                        //general features
                        id: smart_sev_weather_main;
                        objectName: "SMART_SEV_WEATHER_MAIN"
                        property int layer_pri: 0
                        canEntityType: Alert.SMART_SEV_WEATHER

                        //special features
                        is_main: true
                        its_pair_alert: smart_sev_weather_side
                        source:"../images/SmartAlerts/severWeather.svg";

                    }

                }

                Item
                {
                    id: groupGAG
                    objectName: "GAG_QtQG"
                    property bool mutexGroup: false

                   anchors.fill: parent

                    property int canEntityType: Alert.QtQG

                    property int layer_pri: 2

                    function setVisibleSlot() {setVisible(true)}
                    function setInvisibleSlot() {setVisible(false)}

                    function setVisible(isVisible)
                    {
                        visible = isVisible
                    }
                    visible: false


                    Item {
                        id: groupErrors
                        objectName: "ERR_QtQG"
                        property bool mutexGroup: false

                        function setVisible(isVisible)
                        {
                            visible = isVisible
                        }

                        property int layer_pri: 0
                        property int canEntityType: Alert.QtQG

                        visible: false;
                    }

                    Item {
                        id: groupLanes
                        objectName: "LANES_QtQG"
                        property bool mutexGroup: false

                        anchors.fill: parent

                        function setVisibleSlot() {setVisible(true)}
                        function setInvisibleSlot() {setVisible(false)}

                        function setVisible(isVisible)
                        {
                            visible = isVisible
                        }

                        property int layer_pri: 1
                        property int canEntityType: Alert.QtQG

                        visible: false;

                        ////////////////////////////////
                        //Atomic items:
                        Image {

                            function setVisibleSlot() {setVisible(true)}
                            function setInvisibleSlot() {setVisible(false)}

                            function setVisible(isVisible)
                            {
                                visible = isVisible
                            }

                            id: ldw_off;
                            objectName: "ALERT_LDWOFF"
                            property int layer_pri: 2
                            property int canEntityType: Alert.ALERT_LDWOFF

                            visible: false;
                            height: parent.height;
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter : parent.horizontalCenter


                            fillMode: Image.PreserveAspectFit;
                            source:"../images/EWAlerts/ldwoff.png";
                            rotation: 0;


                        }
                        Image {

                            function setVisibleSlot() {setVisible(true)}
                            function setInvisibleSlot() {setVisible(false)}

                            function setVisible(isVisible)
                            {
                                visible = isVisible
                            }

                            id: ldw_on;
                            objectName: "ALERT_LDWON"
                            property int layer_pri: 1
                            property int canEntityType: Alert.ALERT_LDWON

                            visible: false;
                            height: parent.height;
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter : parent.horizontalCenter

                            fillMode: Image.PreserveAspectFit;
                            source:"../images/EWAlerts/ldwon.png";
                            rotation: 0;


                        }

                        Item
                        {

                            function setVisibleSlot() {setVisible(true)}
                            function setInvisibleSlot() {setVisible(false)}

                            function setVisible(isVisible)
                            {
                                //blinkTimer_lldw.setRunning(isVisible)
                                visible = isVisible
                            }

                            id: alert_lldw;
                            objectName: "ALERT_LLDW"
                            property int layer_pri: 0
                            property int canEntityType: Alert.ALERT_LLDW

                            anchors.fill: parent

                            Image {
                                id: alert_lldw_left
                                visible: true;
                                height: parent.height;
                                anchors.bottom: parent.bottom
                                anchors.horizontalCenter : parent.horizontalCenter

                                fillMode: Image.PreserveAspectFit;
                                source:"../images/EWAlerts/lldw_L.png";
                                rotation: 0;


                                SequentialAnimation {

                                    running: alert_lldw.visible
                                    loops: Animation.Infinite

                                    PropertyAction {target: alert_lldw_left; property: "opacity"; value: 1.0}
                                    PauseAnimation {duration: 500}
                                    PropertyAction {target: alert_lldw_left; property: "opacity"; value: 0.0}
                                    PauseAnimation {duration: 300}

                                    /*
                                        NumberAnimation { target: alert_lldw_left; property: "opacity"; from: 1.0; to: 0.0; duration: 300}
                                        NumberAnimation { target: alert_lldw_left; property: "opacity"; from: 0.0; to: 1.0; duration: 500}
                                        */
                                }



                                /*
                                Timer {

                                    id: blinkTimer_lldw

                                    property int intervalOn: 500
                                    property int intervalOff: 300

                                    interval: intervalOn
                                    running: false
                                    repeat: true

                                    function setRunning(On)
                                    {
                                        interval = intervalOn
                                        running = On
                                    }

                                    onTriggered:
                                    {
                                        parent.visible = !parent.visible
                                        interval = (parent.visible ? intervalOn : intervalOff)
                                    }
                                }
                                */
                            }

                            Image {
                                visible: true;
                                height: parent.height;
                                anchors.bottom: parent.bottom
                                anchors.horizontalCenter : parent.horizontalCenter

                                fillMode: Image.PreserveAspectFit;
                                source:"../images/EWAlerts/lldw_R.png";
                                rotation: 0;



                            }
                        }


                        /////////////////////////////////
                        Item
                        {
                            function setVisibleSlot() {setVisible(true)}
                            function setInvisibleSlot() {setVisible(false)}

                            function setVisible(isVisible)
                            {
                                //blinkTimer_rldw.setRunning(isVisible)
                                visible = isVisible
                            }

                            id: alert_rldw;
                            objectName: "ALERT_RLDW"
                            property int layer_pri: 0
                            property int canEntityType: Alert.ALERT_RLDW

                            anchors.fill: parent

                            Image {
                                visible: true;
                                height: parent.height;
                                anchors.bottom: parent.bottom
                                anchors.horizontalCenter : parent.horizontalCenter

                                fillMode: Image.PreserveAspectFit;
                                source:"../images/EWAlerts/rldw_L.png";
                                rotation: 0;
                            }

                            Image {
                                id:alert_rldw_right
                                visible: true;
                                height: parent.height;
                                anchors.bottom: parent.bottom
                                anchors.horizontalCenter : parent.horizontalCenter


                                fillMode: Image.PreserveAspectFit;
                                source:"../images/EWAlerts/rldw_R.png";
                                rotation: 0;


                                SequentialAnimation {

                                    running: alert_rldw.visible
                                    loops: Animation.Infinite

                                    PropertyAction {target: alert_rldw_right; property: "opacity"; value: 1.0}
                                    PauseAnimation {duration: 500}
                                    PropertyAction {target: alert_rldw_right; property: "opacity"; value: 0.0}
                                    PauseAnimation {duration: 300}

                                    /*
                                        NumberAnimation { target: alert_rldw_right; property: "opacity"; from: 1.0; to: 0.0; duration: 300}
                                        NumberAnimation { target: alert_rldw_right; property: "opacity"; from: 0.0; to: 1.0; duration: 500}
                                        */

                                }


                                /*
                                Timer {

                                    id: blinkTimer_rldw

                                    property int intervalOn: 500
                                    property int intervalOff: 300

                                    interval: intervalOn
                                    running: false
                                    repeat: true

                                    function setRunning(On)
                                    {
                                        interval = intervalOn
                                        running = On
                                    }

                                    onTriggered:
                                    {
                                        parent.visible = !parent.visible
                                        interval = (parent.visible ? intervalOn : intervalOff)
                                    }
                                }
                                */
                            }
                        }



                        //////////////////////////////////

                    }

                    Item {
                        id: groupBeam
                        objectName: "BEAM_QtQG"
                        property bool mutexGroup: true

                        function setVisibleSlot() {setVisible(true)}
                        function setInvisibleSlot() {setVisible(false)}

                        function setVisible(isVisible)
                        {
                            visible = isVisible
                        }

                        property int layer_pri: 1
                        property int canEntityType: Alert.QtQG

                        visible: false;

                        Image {

                            function setVisibleSlot() {setVisible(true)}
                            function setInvisibleSlot() {setVisible(false)}

                            function setVisible(isVisible)
                            {
                                visible = isVisible
                            }

                            id: alert_hi_beam;
                            objectName: "ALERT_HI_BEAM"
                            property int layer_pri: 0
                            property int canEntityType: Alert.ALERT_HI_BEAM

                            visible: false;
                            x: 100; y: 100; width: 60; height: 60;
                            fillMode: Image.PreserveAspectFit;
                            source:"../images/EWAlerts/fla_armed.png";
                            rotation: 0;
                        }

                        Image {

                            function setVisibleSlot() {setVisible(true)}
                            function setInvisibleSlot() {setVisible(false)}

                            function setVisible(isVisible)
                            {
                                visible = isVisible
                            }

                            id: alert_low_beam;
                            objectName: "ALERT_LOW_BEAM"
                            property int layer_pri: 0
                            property int canEntityType: Alert.ALERT_LOW_BEAM

                            visible: false;
                            x: 100; y: 100; width: 60; height: 60;
                            fillMode: Image.PreserveAspectFit;
                            source:"../images/EWAlerts/fla_armed_low.png";
                            rotation: 0;
                        }



                    }


                    Item {
                        id: groupCIPV
                        objectName: "CIPV_QtQG"
                        property bool mutexGroup: false

                        function setVisibleSlot() {setVisible(true)}
                        function setInvisibleSlot() {setVisible(false)}

                        function setVisible(isVisible)
                        {
                            visible = isVisible
                        }

                        property int layer_pri: 1
                        property int canEntityType: Alert.QtQG

                        visible: false;








                        ////////////////////////////////
                        //Atomic items:
                        Image {

                            function setVisibleSlot(arg) {setVisible(true); canEntityArg = arg}
                            function setInvisibleSlot() {setVisible(false)}

                            function setVisible(isVisible)
                            {
                                visible = isVisible
                            }

                            id: alert_hmw_alert;
                            objectName: "ALERT_HMW_ALERT"
                            property int layer_pri: 0
                            property int canEntityType: Alert.ALERT_HMW_ALERT
                            property int canEntityArg: 0x00

                            visible: false;
                            x: main_panel.width/8; y: 20; width: main_panel.width*3/4;
                            fillMode: Image.PreserveAspectFit;
                            source: "../images/EWAlerts/hmw_red.png";
                            rotation: 0;


                            Text {
                                text: (parent.canEntityArg == 0x00 ? "  " : (parent.canEntityArg/10).toFixed(1))
                                font.family: "Arial"
                                font.pointSize: 62
                                font.bold: true
                                color: "red"
                                opacity: 1
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.bottom : parent.bottom
                            }

                        }
                        Image {

                            function setVisibleSlot(arg) {setVisible(true); canEntityArg = arg}
                            function setInvisibleSlot() {setVisible(false)}

                            function setVisible(isVisible)
                            {
                                visible = isVisible
                            }

                            id: alert_hmw_monitor;
                            objectName: "ALERT_HMW_MONITOR"
                            property int layer_pri: 0
                            property int canEntityType: Alert.ALERT_HMW_MONITOR
                            property int canEntityArg: 0x00

                            visible: false;
                            x: main_panel.width/8; y: 20; width: main_panel.width*3/4;
                            fillMode: Image.PreserveAspectFit;
                            source:"../images/EWAlerts/hmw_green.png";
                            rotation: 0;


                            Text {
                                text:  (parent.canEntityArg == 0x00 ? "  " : (parent.canEntityArg/10).toFixed(1))
                                font.family: "Arial"
                                font.pointSize: 62
                                font.bold: true
                                color: "#00ff00"
                                opacity: 1
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.bottom: parent.bottom
                            }

                        }


                    }


                }


            }



        }


        Component.onCompleted: {
            //TBD
        }
    }

}
