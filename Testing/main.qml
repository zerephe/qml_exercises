import QtQuick 2.15
import QtQuick.Window 2.15
import QtGraphicalEffects 1.15

Window {
    width: 345
    height: 640
    visible: true
    title: qsTr("Hello World")

    property string colorMain: "#41cd52"
    property string textColorMain: "#fff"
    property var colors: ["#297c33", "#00ff1f", "#41cd52"]

    Item {
        id: mainContainer
        anchors.fill: parent

        Rectangle {
            id: tabBar
            x: 0; y:0
            width: parent.width
            height: 50
            color: colorMain
            z: 1

            Behavior on color {
                PropertyAnimation { duration: 300 }
            }

            Rectangle {
                id: imageMask
                width: 40; height: 40
                radius: 250
                visible: false
            }

            Row {
                id: tabContent
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.margins: 10
                spacing: 8

                Image {
                    id: profileImage
                    width: 40; height: 40
                    source: "https://picsum.photos/id/1025/100/100"
                    fillMode: Image.PreserveAspectCrop
                    layer.enabled: true
                    layer.effect: OpacityMask {
                        maskSource: imageMask
                    }
                }

                Text {
                    id:tabBarText
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("William Gates")
                    font.family: "Ubuntu"
                    font.pixelSize: 16
                    color: textColorMain
                }
            }
        }

        ListModel {
            id: messagesModel
        }

        Component {
            id: messageElement

            Rectangle {
                id: messageBody
                width: parent.width*0.9
                height: 50
                radius: 20
                color: "#09102B"

                required property string author
                required property string message

                state: "invisible"

                states: [
                    State {
                        name: "visible"
                        PropertyChanges {
                            target: messageBody
                            opacity: 1
                        }
                    },
                    State {
                        name: "invisible"
                        PropertyChanges {
                            target: messageBody
                            opacity: 0
                        }
                    }
                ]

                transitions: [
                    Transition {
                        from: "invisible"; to: "visible"
                        // from: "*"; to: "*"
                        ColorAnimation { target: messageBody; properties: "opacity"; duration: 500 }
                    }
                ]

                Column {
                    id: messageWrapper
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.margins: 10
                    spacing: 4

                    Text {
                        id: authorText
                        color: textColorMain
                        text: qsTr(author)
                        font.bold: true
                        font.pixelSize: 10
                    }

                    Text {
                        id: messageText
                        color: textColorMain
                        text: qsTr(message)
                        font.pixelSize: 12
                    }
                }

            }
        }

        ListView {
            id: messagesListView
            anchors.fill: parent
            anchors.topMargin: tabBar.height
            anchors.bottomMargin: messageInputWrapper.height
            anchors.leftMargin: 10
            spacing: 4
            clip: true
            model: messagesModel
            orientation: ListView.Vertical
            delegate: messageElement
        }

        Rectangle {
            id: messageInputWrapper
            anchors.bottom: parent.bottom
            width: parent.width
            height: 50


            function onSendClicked() {
                messagesModel.append({author: "William", message: messageInput.text});
                messageInput.text = qsTr("");
            }

            function changeTabColor() {
                tabBar.color = colors[Math.floor(Math.random()*3)];
            }

            TextInput {
                id: messageInput
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 20
                anchors.rightMargin: 50
                text: qsTr("Write some message...")
                onTextChanged: messageInputWrapper.changeTabColor()

                Keys.onEnterPressed: messageInputWrapper.onSendClicked()
                Keys.onReturnPressed: messageInputWrapper.onSendClicked()

                MouseArea {
                    id: messageInputMouseArea
                    anchors.fill: parent
                    onClicked: {
                        parent.text = qsTr("")
                        parent.focus = true
                    }
                }
            }

            Image {
                id: sendButton
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 20
                width: 30; height: 30
                source: "https://cdn-icons-png.flaticon.com/64/3682/3682321.png"

                MouseArea {
                    id: sendButtonMouseArea
                    anchors.fill: parent
                    onClicked: messageInputWrapper.onSendClicked()
                }
            }
        }
    }
}
