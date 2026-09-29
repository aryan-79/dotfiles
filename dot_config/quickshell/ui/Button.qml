import QtQuick
import qs.theme

Item {
    id: root

    required property color bg
    required property color fg
    required property string content

    property int maxWidth: text.implicitWidth + 20
    property bool clickable: false
    property bool square: false
    property int maxLine: 1

    signal clicked

    width: Math.min(text.implicitWidth + 20, root.maxWidth)
    height: square ? width : text.implicitHeight + 8

    property bool hovered: mouseArea.containsMouse

    Rectangle {
        anchors.fill: parent
        radius: Theme.radius
        color: root.bg
        opacity: root.clickable && root.hovered ? 0.7 : 1

        Text {
            id: text
            anchors.centerIn: parent
            width: Math.min(implicitWidth, parent.width - 20)

            text: root.content
            color: root.fg
            horizontalAlignment: Text.AlignHCenter

            font.family: Theme.font
            font.pixelSize: Theme.fontSize

            elide: Text.ElideRight
            opacity: root.clickable && root.hovered ? 0.7 : 1
            maximumLineCount: root.maxLine
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: root.clickable ? Qt.PointingHandCursor : Qt.ArrowCursor
            onClicked: {
                if (root.clickable) {
                    root.clicked()
                }
            }
        }

        Behavior on color { ColorAnimation { duration: 200 } }
        Behavior on opacity { NumberAnimation { duration: 120 } }
    }
}
