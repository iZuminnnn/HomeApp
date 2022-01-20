import QtQuick 2.0
import QtGraphicalEffects 1.0

MouseArea {
    id: root
    implicitWidth: 635
    implicitHeight: 570
    property bool isFocus: false
    Image {
        id: headerItem
        source: "qrc:/App/Media/Image/title.png"

        Text {
            id: headerTitleText
            text: qsTr("Climate")
            anchors.centerIn: parent
            color: "white"
            font.pixelSize: 46
        }
    }


    states: [
        State {
            name: "Focus"
            PropertyChanges {
                target: idBackgroud
                source: icon + "_f.png"
            }
        },
        State {
            name: "Pressed"
            PropertyChanges {
                target: idBackgroud
                source: icon + "_p.png"
            }
        },
        State {
            name: "Normal"
            PropertyChanges {
                target: idBackgroud
                source: icon + "_n.png"
            }
        }
    ]

    onPressed: root.state = "Pressed"
    onReleased:{
        root.focus = true
        root.state = "Focus"
    }
    onFocusChanged: {
        if (root.focus == true )
            root.state = "Focus"
        else
            root.state = "Normal"
    }

    onIsFocusChanged: {
        if (root.isFocus === true )
        {
            root.state = "Focus"
        }

        else{
            root.state = "Normal"
        }
    }



}
