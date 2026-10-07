import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import qs.services
import qs.theme
import qs.ui

Scope {
    id: root

    Timer {
        id: hideTimer
        interval: 10000
        onTriggered: UiState.hidePowermenu()
    }

    Connections {
        target: UiState
        function onPowermenuShownChanged() {
            if (UiState.powermenuShown) hideTimer.restart()
            else hideTimer.stop()
        }
    }

    IpcHandler {
        target: "powermenu"

        function show(): void {
            UiState.showPowermenu()
        }

        function hide(): void {
            UiState.hidePowermenu()
        }

        function toggle(): void {
            UiState.powermenuShown ? UiState.hidePowermenu() : UiState.showPowermenu()
        }
    }

    LazyLoader {
        active: UiState.powermenuShown

        PanelWindow {
            id: win
            anchors.top: true
            anchors.bottom: true
            anchors.right: true
            margins.right: 30

            implicitWidth: layoutContainer.implicitWidth

            exclusiveZone: 0
            color: "transparent"

            WlrLayershell.namespace: "qs-powermenu"
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

            readonly property var entries : [
                { icon: "󰍁", label: "Lock",     cmd: ["loginctl", "lock-session"] },
                { icon: "󰗼", label: "Logout",   cmd: ["hyprctl", "dispatch", "hl.dsp.exit()"] },
                { icon: "󰒲", label: "Suspend",  cmd: ["systemctl", "suspend"] },
                { icon: "󰜉", label: "Reboot",   cmd: ["systemctl", "reboot"] },
                { icon: "󰐥", label: "Shutdown", cmd: ["systemctl", "poweroff"] }
            ]

            property int currentIndex: 0

            function run(i: int) {
                if(i < 0 || i >= entries.lenght) return
                Quickshell.execDetached(entries[i].cmd)
                UiState.hidePowermenu()
            }

            function forwardFocus(inc: bool) {
                const count = entries.length
                currentIndex = inc
                       ? (currentIndex + 1) % count
                       : (currentIndex - 1 + count) % count
                hideTimer.restart()
            }

            Shortcut {
                sequences: ["Escape", "Q"]
                onActivated: UiState.hidePowermenu()
            }

            Shortcut {
                sequences: ["Up", "K"]
                onActivated:  win.forwardFocus(false)
            }

            Shortcut {
                sequences: ["Down", "J"]
                onActivated:  win.forwardFocus(true)
            }

            Shortcut {
                sequences: ["Enter", "Return"]
                onActivated: win.run(win.currentIndex)
            }

            Rectangle {
                id: layoutContainer
                anchors.centerIn: parent
                radius: 32
                color: Qt.alpha(Theme.surface, 0.7)
                border.color: Theme.infoMuted
                implicitWidth: list.implicitWidth + 40
                implicitHeight: list.implicitHeight + 40

                ColumnLayout {
                    id: list
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 8

                    Repeater {
                        model: win.entries

                        Item {
                            id: c
                            required property var modelData
                            required property int index
                            readonly property bool selected: win.currentIndex === index

                            Layout.fillWidth: true
                            implicitWidth: label.implicitWidth + 40
                            implicitHeight: label.implicitHeight

                            Rectangle {
                                id: btn
                                anchors.fill: parent
                                color: c.selected ? Theme.hover: Theme.surface
                                radius: 12

                                Row {
                                    id: label
                                    spacing: 12
                                    leftPadding: 8
                                    rightPadding: 8
                                    topPadding: 4
                                    bottomPadding: 4

                                    Rectangle {
                                        implicitWidth: 64
                                        implicitHeight: 64
                                        radius: width / 2
                                        color: Theme.bg

                                        ThemedText {
                                            id: icon
                                            anchors.centerIn: parent
                                            anchors.horizontalCenterOffset: -2
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            font.pixelSize: 40
                                            text: c.modelData.icon
                                        }
                                    }

                                    ThemedText {
                                        text: c.modelData.label
                                        size: ThemedText.Size.Xl
                                        anchors.verticalCenter: parent.verticalCenter
                                    }
                                }
                            }

                            TapHandler {
                                onTapped: {
                                    Quickshell.execDetached(c.modelData.cmd)
                                }
                            }

                            HoverHandler {
                                id: hoverProc
                                cursorShape: Qt.PointingHandCursor
                                enabled: true
                            }
                        }
                    }
                }
            }
        }
    }
}
