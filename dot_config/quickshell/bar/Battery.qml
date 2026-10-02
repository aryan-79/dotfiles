import QtQuick
import qs.ui
import qs.theme
import qs.services

Pill {
    visible: SystemUsage.hasBattery
    paddingX: 10
    Row {
        spacing: 8

        ThemedText {
            text: SystemUsage.batteryIcon
            color: SystemUsage.charging ? "#236122" : SystemUsage.batteryPerc <= 0.2 ? Theme.danger : Theme.fg
        }

        ThemedText {
            size: ThemedText.Size.Sm
            text: `${Math.round(SystemUsage.batteryPerc * 100)}%`
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
