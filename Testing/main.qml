import QtQuick 2.15
import QtQuick.Window 2.15
import QtGraphicalEffects 1.15

Window {
    width: 345
    height: 640
    visible: true
    title: qsTr("Hello World")

    property string colorMain: "#202c33"
    property string textColorMain: "#fff"
    property string textColorSecondary: "#667781"

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

        ListView {
            id: messagesListView
            anchors.top: parent.top
            anchors.bottom: emojiPicker.top
            anchors.topMargin: tabBar.height
            anchors.leftMargin: 10
            width: parent.width
            spacing: 4
            clip: true
            model: messagesModel
            orientation: ListView.Vertical
            delegate: messageElement
            opacity: 1

            add: Transition {
                    NumberAnimation {
                        properties: "x"
                        from: 10
                        duration: 500
                        easing.type: Easing.OutCubic
                    }

                    NumberAnimation {
                        properties: "opacity"
                        from: 0
                        to: 1
                        duration: 500
                        easing.type: Easing.OutCubic
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
                color: colorMain

                required property string author
                required property string message

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

        EmojiPicker {
            id: emojiPicker
            anchors.bottom: messageInputWrapper.top

            state: "closed"

            states: [
                State {
                    name: "opened"
                    PropertyChanges {
                        target: emojiPicker
                        height: 200
                    }
                },
                State {
                    name: "closed"
                    PropertyChanges {
                        target: emojiPicker
                        height: 0
                    }
                }
            ]

            Behavior on height {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic;
                }
            }
        }

        Rectangle {
            id: messageInputWrapper
            anchors.bottom: parent.bottom
            width: parent.width
            height: 50
            color: colorMain


            function onSendClicked() {
                messagesModel.append({author: "William", message: messageInput.text});
                messageInput.text = qsTr("");
                sendButton.state = "flyOut"
            }

            Image {
                id: emojiPickerButton
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 10
                width: 20; height: width
                opacity: emojiPicker.state !== "closed" ? 1 : 0.6
                source: "./assets/icons/emoji/1.png"

                Behavior on opacity {
                    NumberAnimation {duration: 100}
                }

                HoverHandler {
                    cursorShape: Qt.PointingHandCursor
                    target: emojiPickerButton
                    onHoveredChanged: emojiPickerButtonMouseArea.cursorShape = cursorShape
                }

                MouseArea {
                    id: emojiPickerButtonMouseArea
                    anchors.fill: parent
                    onClicked: {
                        emojiPicker.state = (emojiPicker.state !== "closed") ? "closed" : "opened"
                    }
                }
            }

            TextInput {
                id: messageInput
                anchors.left: emojiPickerButton.right
                anchors.right: sendButton.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 10
                anchors.rightMargin: 50
                text: qsTr("Write some message...")
                color: textColorMain

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
                width: 20; height: width
                source: "https://cdn-icons-png.flaticon.com/64/3682/3682321.png"

                MouseArea {
                    id: sendButtonMouseArea
                    anchors.fill: parent
                    onClicked: messageInputWrapper.onSendClicked()
                }

                state: "ground"

                states: [
                    State {
                        name: "flyOut"
                        PropertyChanges {
                            target: sendButton
                            anchors.rightMargin: -50
                            opacity: 0
                        }
                    },

                    State {
                        name: "flyIn"
                        PropertyChanges {
                            target: sendButton
                            anchors.rightMargin: 50
                            opacity: 0
                        }
                    },

                    State {
                        name: "ground"
                        PropertyChanges {
                            target: sendButton
                            anchors.rightMargin: 20
                            opacity: 1
                        }
                    }
                ]

                transitions: [
                    Transition {
                        from: "ground"; to: "flyOut"
                        // from: "*"; to: "*"
                        NumberAnimation {
                            target: sendButton
                            properties: "anchors.rightMargin, opacity"
                            duration: 500
                            easing.type: Easing.InQuad;
                        }
                        onRunningChanged: if(running == false) {
                                              sendButton.state = "flyIn"
                                              sendButton.state = "ground"
                                          }
                    },

                    Transition {
                        from: "flyIn"; to: "ground"
                        // from: "*"; to: "*"
                        NumberAnimation {
                            target: sendButton
                            properties: "anchors.rightMargin, opacity"
                            duration: 500
                            easing.type: Easing.OutQuad;
                        }
                    }
                ]
            }
        }
    }
}
