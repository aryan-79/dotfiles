import QtQuick
import qs.theme

Rectangle {
    id: root

    default property alias content: row.data
    property alias spacing: row.spacing

    property int defaultPaddingX: 10

    property int paddingX: defaultPaddingX
    property int paddingY: 4
    property int maxWidth: 0

    implicitWidth: {
        const w = row.implicitWidth + paddingX * 2
        return maxWidth ? Math.min(maxWidth, w) : w
    }
    implicitHeight: row.implicitHeight + paddingY * 2

    radius: Theme.radius
    color: Theme.bg

    Row {
        id: row
        anchors.centerIn: parent
    }
}
