/*
                {"value": 1, "action": "SUPP_RAIN", "description": "Suppliment: Rain"}
                        ,{"value": 2, "action": "SUPP_SNOW", "description": "Suppliment:  Snow"}
                        ,{"value": 3, "action": "SUPP_TRAILER", "description": "Suppliment"}
                        ,{"value": 4, "action": "SUPP_TIME", "description": "Supplimentary"}
                        ,{"value": 5, "action": "SUPP_ARROW_LEFT", "description": "Supplimentary"}
                        ,{"value": 6, "action": "SUPP_ARROW_RIGHT", "description": "Supplimentary"}
                        ,{"value": 7, "action": "SUPP_BEND_ARROW_LEFT", "description": "Supplimentary"}
                        ,{"value": 8, "action": "SUPP_BEND_ARROW_RIGHT", "description": "Supplimentary: Bend Arrow Right"}
                        ,{"value": 9, "action": "SUPP_TRUCK", "description": "Supplimentaryi: Truck"}
                        ,{"value": 10, "action": "SUPP_DISTANCE_ARROW", "description": "Supplimentary: "}
                        ,{"value": 11, "action": "SUPP_WEIGHT", "description": "Supplimentary: Weight"}
                        ,{"value": 12, "action": "SUPP_DISTANCE_IN", "description": "Supplimentary: Distance in"}
                        ,{"value": 13, "action": "SUPP_TRACTOR", "description": "Supplimentary: Tractor"}
                        ,{"value": 14, "action": "SUPP_SNOW_RAIN", "description": "Supplimentary: Snow rain"}
                        ,{"value": 15, "action": "SUPP_SCHOOL", "description": "Supplimentary: School"}
                        ,{"value": 16, "action": "SUPP_RAIN_CLOUD", "description": "Supplimentary: Rain cloud"}
                        ,{"value": 17, "action": "SUPP_FOG", "description": "Supplimentary: Fog"}
                        ,{"value": 18, "action": "SUPP_HAZARD_MAT", "description": "Supplimentary: Hazardous material"}
                        ,{"value": 19, "action": "SUPP_NIGHT", "description": "Supplimentaryi: Night"}
                        ,{"value": 20, "action": "SUPP_GENERIC", "description": "Supplimentary: Generic sign (the type of sign is not detected)"}
                        ,{"value": 21, "action": "SUPP_RAPEL", "description": "Supplimentary: Rapel"}
                        ,{"value": 22, "action": "SUPP_ZONE", "description": "Supplimentary: Zone"}
                        ,{"value": 23, "action": "SUPP_RAMP", "description": "Supplimentary: ramp"}
                        ,{"value": 24, "action": "SUPP_END", "description": "Supplimentary: end"}
                        ,{"value": 25, "action": "SUPP_EXIT", "description": "Supplimentary: exit"}
                        ,{"value": 26, "action": "SUPP_ADVISORY", "description": "Supplimentary: advisory"}
                        ,{"value": 27, "action": "SUPP_MINIMUM", "description": "Supplimentary: minimum"}
                        ,{"value": 28, "action": "SUPP_REDUCED_AHEAD", "description": "Supplimentary: reduced ahead"}
 */


import QtQuick 2.9


Image
{
  id: rect

  property int supp: 0
  source: "images/left-panel/Supp/snow.png"
  visible: false

  states: [
      State { name: "SUPP_RAIN"; when: supp === 1
          PropertyChanges { target: rect; visible: true; source: "images/left-panel/Supp/rain.png" }
      }
      ,State { name: "SUPP_SNOW"; when: supp === 2
          PropertyChanges { target: rect; visible: true; source: "images/left-panel/Supp/snow.png" }
      }
      ,State { name: "SUPP_TIME"; when: supp === 4
          PropertyChanges { target: rect; visible: true; source: "images/left-panel/Supp/time.png" }
      }
      ,State { name: "SUPP_ARROW_LEFT"; when: supp === 5
          PropertyChanges { target: rect; visible: true; source: "images/left-panel/Supp/left_arrow.png" }
      }
      ,State { name: "SUPP_ARROW_RIGHT"; when: supp === 6
          PropertyChanges { target: rect; visible: true; source: "images/left-panel/Supp/right_arrow.png" }
      }
      ,State { name: "SUPP_BEND_ARROW_LEFT"; when: supp === 7
          PropertyChanges { target: rect; visible: true; source: "images/left-panel/Supp/left_bottom_arrow.png" }
      }
      ,State { name: "SUPP_BEND_ARROW_RIGHT"; when: supp === 8
          PropertyChanges { target: rect; visible: true; source: "images/left-panel/Supp/right_bottom_arrow.png" }
      }
      ,State { name: "SUPP_TRUCK"; when: supp === 9
          PropertyChanges { target: rect; visible: true; source: "images/left-panel/Supp/truck.png" }
      }
      ,State { name: "SUPP_WEIGHT"; when: supp === 11
          PropertyChanges { target: rect; visible: true; source: "images/left-panel/Supp/weight.png" }
      }
      ,State { name: "SUPP_DISTANCE_IN"; when: supp === 12
          PropertyChanges { target: rect; visible: true; source: "images/left-panel/Supp/distance.png" }
      }
      ,State { name: "SUPP_TRACTOR"; when: supp === 13
          PropertyChanges { target: rect; visible: true; source: "images/left-panel/Supp/tractor.png" }
      }
      ,State { name: "SUPP_SNOW_RAIN"; when: supp === 14
          PropertyChanges { target: rect; visible: true; source: "images/left-panel/Supp/snow_with_rain.png" }
      }
      ,State { name: "SUPP_ZONE"; when: supp === 22
          PropertyChanges { target: rect; visible: true; source: "images/left-panel/Supp/zone.png" }
      }
  ]
}
