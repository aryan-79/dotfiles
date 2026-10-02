import QtQuick
import Quickshell
import qs.ui
import qs.services

Button {
    Row {
        spacing: 10

        Row {
            spacing: 8

            ThemedText {
                text: "\uf4bc"
                size: ThemedText.Size.Sm
                anchors.verticalCenter: parent.verticalCenter
            }

            ThemedText {
                text: `${Math.round(SystemUsage.cpuPerc * 100)}%`
            }
        }

        Row {
            spacing: 8

            ThemedText {
                text: "\uefc5"
                size: ThemedText.Size.Sm
                anchors.verticalCenter: parent.verticalCenter
            }

            ThemedText {
                text: `${Math.round(SystemUsage.memPerc * 100)}%`
            }
        }
    }

    onClicked: Quickshell.execDetached(["ghostty", "-e", "htop"])
}
