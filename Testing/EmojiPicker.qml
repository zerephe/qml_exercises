import QtQuick 2.15
import "./assets/emojis.js" as Emojis

Item {
    id: mainContainer
    width: parent.width
    height: 200

    property string emojiTabMainColor: "#202c33"
    property string selectedEmojiGroupColor: "#00a884"
    property int emojiGroupCount: Object.keys(Emojis.emojis).length

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
                model: Object.keys(Emojis.emojis)
                delegate: emojiGroupIconComponent
                highlightFollowsCurrentItem: false
                currentIndex: getGroupIndex()
                focus: true

                highlight: Rectangle {
                    id: selectedEmojiGroupIdentifier
                    anchors.bottom: parent.bottom
                    width: parent.width/emojiGroupCount;
                    height: 2
                    color: selectedEmojiGroupColor
                    x: emojiGroups.currentItem.x

                    Behavior on x {
                        NumberAnimation {
                            duration: 200
                            easing.type: Easing.OutQuad;
                        }
                    }
                }
            }

            Component {
                id: emojiGroupIconComponent

                Rectangle {
                    id: emojiIconWrapper
                    width: emojiGroups.width/emojiGroupCount; height: 30
                    color: "transparent"

                    required property int index

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            emojiSectionViewer.positionViewAtIndex(index, ListView.Beginning)
                        }
                    }

                    Image {
                        id: emojiGroupIcon
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        width: 15; height: width
                        source: `./assets/icons/emoji/${index + 1}.png`
                        opacity: emojiGroups.currentIndex === index ? 1 : 0.5

                        Behavior on opacity {
                            NumberAnimation { duration: 100 }
                        }
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
            model: Object.keys(Emojis.emojis)
            delegate: emojiSetGridComponent
            spacing: 5
            clip: true
        }

        Component {
            id: emojiSetGridComponent

            Item{
                id: emojiSetGridViewWrapper
                width: emojiSectionViewer.width; implicitHeight: emojiSetGridView.implicitHeight

                property string section: Object.keys(Emojis.emojis)[index]

                Flow {
                    id: emojiSetGridView
                    anchors.fill: parent

                    Rectangle {
                        width: emojiSetGridViewWrapper.width
                        height: 20
                        color: "transparent"

                        Text {
                            anchors.left: parent.left
                            anchors.leftMargin: 5
                            anchors.verticalCenter: parent.verticalCenter
                            text: section
                            color: textColorSecondary
                        }
                    }

                    Repeater {
                        model: Emojis.emojis[section]
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

    function getGroupIndex() {
        if(emojiSectionViewer.indexAt(
                    0,emojiSectionViewer.contentY) === -1) {
            return emojiGroups.currentIndex
        }

        return emojiSectionViewer.indexAt(
                    0,emojiSectionViewer.contentY)
    }
}
