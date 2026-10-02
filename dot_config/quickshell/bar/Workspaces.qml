import Quickshell
import QtQuick
import Quickshell.Hyprland
import qs.theme
import qs.ui
import qs.services

Item {
    id: root

    required property ShellScreen screen
    property HyprlandMonitor monitor: Hyprland.monitorFor(screen)

    implicitWidth: wsRow.implicitWidth
    implicitHeight: wsRow.implicitHeight

    Row {
        id: wsRow

        spacing: 4

        anchors.fill: parent

        readonly property HyprlandWorkspace activeWs: root.monitor ? root.monitor.activeWorkspace : null
        readonly property bool focused: activeWs ? activeWs.focused : false
        readonly property bool urgent: activeWs ? activeWs.urgent : false

        Button {
            spacing: 14

            ThemedText {
                text: ""
                color: PowerProfiles.activeProfile === "performance" ? Theme.accent : PowerProfiles.activeProfile === "balanced" ? Theme.accentMuted: Theme.fgMuted
            }


            ThemedText {
                id: wsName
                text:  wsRow.activeWs ? wsRow.activeWs.name : ""
            }

            onClicked: PowerProfiles.cycleProfile()
        }

        Pill {
            color: Theme.bg

            ThemedText {
                width: Math.min(implicitWidth, 250)
                text: Hyprland.activeToplevel ? Hyprland.activeToplevel.title : "~ aryan"
            }
        }
    }
}
