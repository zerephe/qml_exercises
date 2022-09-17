import QtQuick 2.15
import "./assets/emojis.js" as Emojis

Item {
    id: mainContainer
    width: parent.width
    height: 200

    property string emojiTabMainColor: "#202c33"
    property string selectedEmojiGroupColor: "#00a884"
    property int selectedGroupIndex: 0

    Component.onCompleted: {
        for(let i = 1; i < 9; i++) {
            emojiGroupModel.append({iconUrl: `./assets/icons/emoji/${i}.png`});
        }

        emojiSectionViewerModel.append({ section: "smileys"})
        emojiSectionViewerModel.append({ section: "animals"})
        emojiSectionViewerModel.append({ section: "food"})
        emojiSectionViewerModel.append({ section: "activities"})
        emojiSectionViewerModel.append({ section: "travel"})
        emojiSectionViewerModel.append({ section: "objects"})
        emojiSectionViewerModel.append({ section: "symbols"})
        emojiSectionViewerModel.append({ section: "flags"})
    }

    Rectangle {
        id: emojiContainer
        anchors.fill: parent
        color: emojiTabMainColor

        Rectangle {
            id: emojiTabContainer
            width: parent.width
            height: 30
            color: emojiTabMainColor
            z: 1

            ListView {
                id: emojiGroups
                anchors.fill: parent
                orientation: ListView.Horizontal
                model: emojiGroupModel
                delegate: emojiGroupIconComponent
            }

            ListModel {
                id: emojiGroupModel
            }

            Component {
                id: emojiGroupIconComponent

                Rectangle {
                    id: emojiIconWrapper
                    width: emojiGroups.width/8; height: 30
                    color: "transparent"

                    required property int index
                    required property string iconUrl

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            selectedEmojiGroupIdentifier.x = parent.x
                            selectedGroupIndex = index
                            emojiSectionViewer.positionViewAtIndex(index, ListView.Beginning)
                        }
                    }

                    Image {
                        id: emojiGroupIcon
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        width: 15; height: width
                        source: iconUrl
                        opacity: selectedGroupIndex === index ? 1 : 0.5

                        Behavior on opacity {
                            NumberAnimation { duration: 100 }
                        }
                    }
                }
            }

            Rectangle {
                id: selectedEmojiGroupIdentifier
                anchors.top: parent.bottom
                width: parent.width/8; height: 2
                x: 0
                color: selectedEmojiGroupColor

                Behavior on x {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.OutQuad;
                    }
                }
            }
        }

        ListView {
            id: emojiSectionViewer
            anchors.top: emojiTabContainer.bottom
            anchors.bottom: parent.bottom
            width: parent.width
            orientation: ListView.Vertical
            model: emojiSectionViewerModel
            delegate: emojiSetGridComponent
            spacing: 5
            clip: true
            section.property: "section"
            section.delegate: Rectangle {
                anchors.left: parent.left
                anchors.margins: 5
                implicitHeight: emojiSectionText.implicitHeight + 10
                color: "transparent"
                Text {
                    id: emojiSectionText
                    text: section
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 12
                    color: textColorSecondary
                }
            }
        }

        ListModel {
            id: emojiSectionViewerModel
        }

        Component {
            id: emojiSetGridComponent

            Item{
                id: emojiSetGridViewWrapper
                width: parent.width; implicitHeight: emojiSetGridView.implicitHeight

                required property string section
                required property int index

                Flow {
                    id: emojiSetGridView
                    anchors.fill: parent

                    Repeater {
                        model: Emojis.emojis[section].length
                        delegate: emojiSetComponent
                    }
                }

                Component {
                    id: emojiSetComponent

                    Rectangle {
                        id: emojiWrapper
                        required property int index
                        width: 40; height: width
                        color: emojiHover.hovered ? textColorSecondary : "transparent"

                        HoverHandler {
                            id: emojiHover
                            cursorShape: Qt.PointingHandCursor
                            target: emojiWrapper
                            onHoveredChanged: {
                                emojiWrapperMouseArea.cursorShape = cursorShape
                            }
                        }

                        MouseArea {
                            id: emojiWrapperMouseArea
                            anchors.fill: parent
                            onClicked: {
                                messageInput.text += emojiItem.text
                            }
                        }

                        Text {
                            id: emojiItem
                            anchors.centerIn: parent

                            font.pixelSize: 20
                            text: Emojis.emojis[section][index].emoji
                        }
                    }
                }
            }
        }
    }
}
