import QtQuick 2.12
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.4
import QtQml.Models 2.1

Item {
    property int focusArea: 0
    property int focusIndex: 0


    id: root
    width: 1920
    height: 1096
    function openApplication(url){
        parent.push(url)
    }

    ListView {
        id: lvWidget
        spacing: 10
        orientation: ListView.Horizontal
        width: 1920
        height: 570
        interactive: false

        displaced: Transition {
            NumberAnimation { properties: "x,y"; easing.type: Easing.OutQuad }
        }

        model: DelegateModel {
            id: visualModelWidget
            model: ListModel {
                id: widgetModel
                ListElement { type: "map" }
                ListElement { type: "climate" }
                ListElement { type: "media" }
            }

            delegate: DropArea {
                id: delegateRootWidget
                width: 635; height: 570
                keys: ["widget"]

                onEntered: {
                    visualModelWidget.items.move(drag.source.visualIndex, iconWidget.visualIndex)
                    iconWidget.item.enabled = false
                }
                property int visualIndex: DelegateModel.itemsIndex
                Binding { target: iconWidget; property: "visualIndex"; value: visualIndex }
                onExited: iconWidget.item.enabled = true
                onDropped: {
                    console.log(drop.source.visualIndex)
                }

                Loader {
                    id: iconWidget
                    property int visualIndex: 0
                    width: 635; height: 570
                    anchors {
                        horizontalCenter: parent.horizontalCenter;
                        verticalCenter: parent.verticalCenter
                    }

                    sourceComponent: {
                        switch(model.type) {
                        case "map": return mapWidget
                        case "climate": return climateWidget
                        case "media": return mediaWidget
                        }
                    }

                    Drag.active: iconWidget.item.drag.active
                    Drag.keys: "widget"
                    Drag.hotSpot.x: delegateRootWidget.width/2
                    Drag.hotSpot.y: delegateRootWidget.height/2

                    states: [
                        State {
                            when: iconWidget.Drag.active
                            ParentChange {
                                target: iconWidget
                                parent: root
                            }

                            AnchorChanges {
                                target: iconWidget
                                anchors.horizontalCenter: undefined
                                anchors.verticalCenter: undefined
                            }
                        }
                    ]
                }
            }
        }

        Component {
            id: mapWidget
            MapWidget{
                isFocus : (focusArea == 0 && focusIndex ===0)? true :false
                onPressed: {
                    focusIndex = -1
                }
                onClicked: {
                 openApplication("qrc:/App/Map/Map.qml")

                }
                 onReleased: {
                     focusArea = 0
                     focusIndex = 0
                 }
           }
        }
        Component {
            id: climateWidget
            ClimateWidget {
                isFocus : (focusArea == 0 && focusIndex ===1)? true :false
                onPressed: {
                    focusIndex = -1
                }
                onClicked: {
                    openApplication("qrc:/Qml/App/Climate.qml")
                }
                onReleased: {
                    focusArea = 0
                    focusIndex = 1
                }
            }
        }
        Component {
            id: mediaWidget
            MediaWidget{
                isFocus : (focusArea == 0 && focusIndex ===2)? true :false
                onPressed: {
                    focusIndex = -1
                }
                onClicked: {
                    openApplication("qrc:/App/Media/Media.qml")
            }
                onReleased: {
                    focusArea = 0
                    focusIndex = 2
                }
        }
        }
}




    property string nameApp: ""
    property var itemApp: []
    ListView {
        id:listAppView
        x:0
        y:575
        width: 1920; height: 604
        orientation: ListView.Horizontal
        interactive: false
        spacing: 5

        displaced: Transition {
            NumberAnimation { properties: "x,y"; easing.type: Easing.OutQuad }
        }

        ScrollBar.horizontal:ScrollBar{
            anchors.bottom: listAppView.top
            anchors.left: listAppView.left
            interactive: true
            width: 1920


        }

        model:
            DelegateModel {
            id: visualModel
            model: appsModel

            delegate:
                DropArea {
                id: delegateRoot
                width: 316; height: 604
                keys: "AppButton"

                onEntered: visualModel.items.move(drag.source.visualIndex, icon.visualIndex)

                property int visualIndex: DelegateModel.itemsIndex
                Binding { target: icon; property: "visualIndex"; value: visualIndex }

                Item {
                    id: icon
                    property int visualIndex: 0
                    width: 316; height: 604

                    anchors {
                        horizontalCenter: parent.horizontalCenter;
                        verticalCenter: parent.verticalCenter
                    }

                    AppButton{
                        id: app
                        anchors.fill: parent
                        title: model.title
                        icon: model.iconPath
                        isFocus : (focusArea === 1 && focusIndex === visualIndex )? true :false


                        onClicked: {
                            openApplication(model.url)

                        }
                        onPressed: {
                            focusIndex = -1
                        }

                        onReleased: {
                            console.log(visualIndex)
                            app.focus = true
                            app.state = "Focus"
                            focusArea = 1
                            focusIndex = visualIndex





                            for (var index = 0; index < visualModel.items.count;index++){


                                appx.addItemtoList(visualModel.items.get(index).model.idApp,
                                               visualModel.items.get(index).model.title,
                                               visualModel.items.get(index).model.url,
                                               visualModel.items.get(index).model.iconPath
                                               )
                                if (index !== visualIndex){
                                    visualModel.items.get(index).focus = false
                                }
                                else{
                                    visualModel.items.get(index).focus = true

                                }
                            }
                            appx.xmlWriter()
                            console.log("Save Successfull");

                        }
                        drag.target: icon

                    }

                    onFocusChanged: app.focus = icon.focus


                    Drag.active: app.drag.active
                    Drag.keys: "AppButton"

                    states: [
                        State {
                            when: icon.Drag.active
                            ParentChange {
                                target: icon
                                parent: root
                            }

                            AnchorChanges {
                                target: icon
                                anchors.horizontalCenter: undefined
                                anchors.verticalCenter: undefined
                            }
                        }
                    ]
                }
            }
        }
    }
}
