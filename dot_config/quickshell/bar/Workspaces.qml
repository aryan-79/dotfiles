import Quickshell
import QtQuick
import Quickshell.Hyprland
import qs.theme
import qs.ui

Item {
    id: root

    anchors.fill: parent

    required property ShellScreen screen
    property HyprlandMonitor monitor: Hyprland.monitorFor(screen)

    implicitWidth: wsRow.implicitWidth
    implicitHeight: wsRow.implicitHeight

    Row {
        id: wsRow

        spacing: 4
        leftPadding: 6
        rightPadding: 6
        topPadding: 2
        bottomPadding: 2

        anchors.fill: parent

        property  HyprlandWorkspace activeWs: root.monitor.activeWorkspace
        property bool focused: activeWs.focused
        property bool urgent: activeWs.urgent


        Button {
            bg: Theme.bg
            fg: Theme.fg
            content: wsRow.activeWs.name
            square: true
        }

        Button {
            bg: Theme.bg
            fg: Theme.fg
            maxWidth: 300
            content: {
                const window = Hyprland.activeToplevel

                if (!window){
                    return "~ aryan"
                }

                return window.title
            }
        }
    }
}
