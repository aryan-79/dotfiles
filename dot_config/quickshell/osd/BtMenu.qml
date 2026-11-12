import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Bluetooth
import qs.services
import qs.theme
import qs.ui

Scope {
    id: root

    property bool shown: false

    IpcHandler {
        target: "bluetooth"

        function showMenu(): void { root.shown = true }
        function hideMenu(): void { root.shown = false }
        function toggle(): void { root.shown = !root.shown }
    }

    LazyLoader {
        active: root.shown

        FloatingWindow {
            id: win
            title: "qs-bluetooth"
            color: Theme.bg
            implicitWidth: 440
            implicitHeight: 520

            property bool showHelp: false

            // selection is tracked by address so it survives re-sorting;
            // if the device vanishes (unpair), stay at the same position
            property string selAddr: ""
            property int lastIdx: 0
            readonly property var rows: Bt.sortedDevices
            readonly property int sel: {
                const i = rows.findIndex(d => d.address === selAddr);
                return i >= 0 ? i : Math.max(0, Math.min(lastIdx, rows.length - 1));
            }
            readonly property var current: rows[sel] ?? null

            function select(i: int) {
                if (rows.length > 0)
                    selAddr = rows[Math.max(0, Math.min(rows.length - 1, i))].address;
            }

            onSelChanged: {
                lastIdx = sel;
                list.positionViewAtIndex(sel, ListView.Contain);
            }
            onVisibleChanged: if (!visible) root.shown = false

            Component.onDestruction: Bt.setScanning(false)

            Timer {
                id: scanRetry
                property int attempts: 0
                interval: 1000
                repeat: true
                triggeredOnStart: true
                running: Bt.enabled && Bt.adapter !== null && !Bt.adapter.discovering && attempts < 5
                onTriggered: {
                    attempts++
                    Bt.setScanning(true)
                }
            }

            Connections {
                target: Bt.adapter
                function onDiscoveringChanged() {
                    if (Bt.adapter.discovering) scanRetry.attempts = 0
                }
            }

            // always active
            Shortcut {
                sequences: ["Escape", "Q"]
                onActivated: {
                    if (win.showHelp) win.showHelp = false;
                    else root.shown = false;
                }
            }
            Shortcut {
                sequences: ["?", "H", "F1"]
                onActivated: win.showHelp = !win.showHelp
            }

            // disabled while help is open
            Shortcut { enabled: !win.showHelp; sequences: ["J", "Down"]; onActivated: win.select(win.sel + 1) }
            Shortcut { enabled: !win.showHelp; sequences: ["K", "Up"]; onActivated: win.select(win.sel - 1) }
            Shortcut { enabled: !win.showHelp; sequence: "G"; onActivated: win.select(0) }
            Shortcut { enabled: !win.showHelp; sequence: "Shift+G"; onActivated: win.select(win.rows.length - 1) }
            Shortcut { enabled: !win.showHelp; sequences: ["Return", "Enter", "Space", "L"]; onActivated: Bt.toggleConnect(win.current) }
            Shortcut { enabled: !win.showHelp; sequence: "P"; onActivated: Bt.pair(win.current) }
            Shortcut { enabled: !win.showHelp; sequence: "U"; onActivated: Bt.unpair(win.current) }
            Shortcut { enabled: !win.showHelp; sequence: "B"; onActivated: Bt.toggle() }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 12

                RowLayout {
                    Layout.fillWidth: true

                    ThemedText {
                        text: "Bluetooth"
                        size: ThemedText.Size.Xl
                        Layout.fillWidth: true
                    }

                    ThemedText {
                        text: !Bt.enabled ? "off" : (Bt.adapter?.discovering ? "on · scanning" : "on")
                        color: Bt.enabled ? Theme.fg : Theme.danger
                    }
                }

                ThemedText {
                    visible: !Bt.enabled || win.rows.length === 0
                    text: !Bt.enabled ? "Bluetooth is off (b to turn on)" : "No devices found"
                    opacity: 0.6
                }

                ListView {
                    id: list
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    spacing: 6
                    model: ScriptModel { values: win.rows }

                    delegate: Rectangle {
                        id: row
                        required property var modelData
                        required property int index
                        readonly property bool selected: win.sel === index
                        readonly property string status: {
                            const d = modelData;
                            if (d.pairing) return "pairing…";
                            if (d.state === BluetoothDeviceState.Connecting) return "connecting…";
                            if (d.state === BluetoothDeviceState.Disconnecting) return "disconnecting…";
                            if (d.connected)
                                return d.batteryAvailable ? `connected · ${Math.round(d.battery * 100)}%` : "connected";
                            return (d.paired || d.bonded) ? "paired" : "new";
                        }

                        width: ListView.view.width
                        height: 56
                        radius: 12
                        color: selected ? Theme.hover : Theme.surface

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 12
                            anchors.rightMargin: 12
                            spacing: 12

                            ThemedText {
                                Layout.preferredWidth: 24
                                Layout.alignment: Qt.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                text: "󰂯"
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignVCenter
                                spacing: 0

                                ThemedText {
                                    Layout.fillWidth: true
                                    horizontalAlignment: Text.AlignLeft
                                    elide: Text.ElideRight
                                    text: row.modelData.name
                                }
                                ThemedText {
                                    Layout.fillWidth: true
                                    horizontalAlignment: Text.AlignLeft
                                    text: row.status
                                }
                            }
                        }

                        TapHandler {
                            onTapped: win.selAddr = row.modelData.address
                            onDoubleTapped: Bt.toggleConnect(row.modelData)
                        }

                        HoverHandler { cursorShape: Qt.PointingHandCursor }
                    }
                }

                ThemedText {
                    text: "? help · q close"
                    opacity: 0.6
                }
            }

            // help overlay
            Rectangle {
                anchors.fill: parent
                visible: win.showHelp
                z: 10
                color: Qt.alpha(Theme.bg, 0.96)

                // MouseArea accepts the event, so clicks don't reach the list below
                MouseArea {
                    anchors.fill: parent
                    onClicked: win.showHelp = false
                }

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 8

                    ThemedText {
                        text: "Keybinds"
                        size: ThemedText.Size.Xl
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Repeater {
                        model: [
                            { key: "j / ↓",         desc: "Next device" },
                            { key: "k / ↑",         desc: "Previous device" },
                            { key: "g / G",         desc: "First / last device" },
                            { key: "⏎ / Space / l", desc: "Connect / disconnect" },
                            { key: "p",             desc: "Pair (again to cancel)" },
                            { key: "u",             desc: "Unpair" },
                            { key: "b",             desc: "Bluetooth on / off" },
                            { key: "?",             desc: "Toggle this help" },
                            { key: "q / Esc",       desc: "Close (closes help first)" }
                        ]

                        RowLayout {
                            id: helpRow
                            required property var modelData
                            spacing: 16

                            ThemedText {
                                text: helpRow.modelData.key
                                color: Theme.infoMuted
                                Layout.preferredWidth: 120
                            }
                            ThemedText { text: helpRow.modelData.desc }
                        }
                    }
                }
            }
        }
    }
}
