import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Wayland
import qs.services
import qs.theme

Scope {
    id: root

    Timer {
        id: hideTimer
        interval: 10000
        onTriggered: UiState.hideWallpaperSwitcher()
    }

    Connections {
        target: UiState
        function onWallpaperSwitcherShownChanged() {
            if (UiState.wallpaperSwitcherShown) hideTimer.restart()
            else hideTimer.stop()
        }
    }

    IpcHandler {
        target: "wallpaper-switcher"

        function toggle(): void {
            UiState.wallpaperSwitcherShown ? UiState.hideWallpaperSwitcher() : UiState.showWallpaperSwitcher()
        }
    }

    LazyLoader {
        active: UiState.wallpaperSwitcherShown

        PanelWindow {
            id: win
            anchors.bottom: true
            margins.bottom: 30

            implicitWidth: container.implicitWidth
            implicitHeight: container.implicitHeight

            color: "transparent"

            readonly property int padding: 20
            readonly property int itemSize: 200

            exclusiveZone: 0
            WlrLayershell.namespace: "qs-wallpaper-switcher"
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

            property bool firstLoad: true

            property string currentWallpaper
            property list<string> wallpapers: []

            // preview
            property bool previewed: false
            property bool confirmed: false

            property int currentIndex: getCurrentWallpaperIndex()
            readonly property string wallpaperDir: Quickshell.env("HOME") + "/wallpapers"

            Component.onCompleted: firstLoad = false

            // preview: restore the original wallpaper and colors if closed without confirming
            Component.onDestruction: {
                previewTimer.stop()
                if (previewed && !confirmed && currentWallpaper)
                    applyLive(currentWallpaper)
            }

            // preview: wallpaper + colors, nothing written to hyprpaper.conf
            readonly property string previewScript: `
                pkill -x wallust 2>/dev/null || true
                hyprctl hyprpaper wallpaper ",$1,cover"
                wallust run "$1"
            `

            function applyLive(path: string) {
                Quickshell.execDetached(["sh", "-c", win.previewScript, "_", path])
            }

            function forwardFocus(inc: bool) {
                const count = wallpapers.length
                if (count === 0) return

                currentIndex = inc
                    ? (currentIndex + 1) % count
                    : (currentIndex - 1 + count) % count

                hideTimer.restart()
                previewTimer.restart()   // preview
            }

            function getFileName(path: string): string {
                return path.split("/").pop()
            }

            function getCurrentWallpaperIndex(): int {
                const currFileName = getFileName(currentWallpaper)
                return Math.max(0, wallpapers.findIndex(w => getFileName(w) === currFileName))
            }

            // preview: debounced so holding a key doesn't spam hyprctl/wallust
            Timer {
                id: previewTimer
                interval: 300
                onTriggered: {
                    win.previewed = true
                    win.applyLive(win.wallpapers[win.currentIndex])
                }
            }

            Process {
                command: [
                    "find", win.wallpaperDir,
                    "-maxdepth", "1",
                    "-type", "f",
                    "(",
                    "-iname", "*.png",
                    "-o", "-iname", "*.jpg",
                    "-o", "-iname", "*.jpeg",
                    "-o", "-iname", "*.webp",
                    ")"
                ]
                running: true
                stdout: SplitParser {
                    onRead: data => {
                        win.wallpapers = [...win.wallpapers, data]
                    }
                }
            }

            Process {
                command: ["hyprctl", "hyprpaper", "listactive"]
                running: true
                stdout: StdioCollector {
                    onStreamFinished: {
                        const line = text.split("\n")[0] ?? ""
                        const i = line.indexOf(":")
                        win.currentWallpaper = i >= 0 ? line.slice(i + 1).trim() : ""
                    }
                }
            }

            Shortcut {
                sequences: ["Escape", "Q"]
                onActivated: UiState.hideWallpaperSwitcher()
            }

            Shortcut {
                sequences: ["Right", "L"]
                onActivated: win.forwardFocus(true)
            }

            Shortcut {
                sequences: ["Left", "H"]
                onActivated: win.forwardFocus(false)
            }

            readonly property string setWallpaperScript: `
                set -eu
                pkill -x wallust 2>/dev/null || true
                conf="$HOME/.config/hypr/hyprpaper.conf"

                hyprctl hyprpaper wallpaper ",$1,cover"

                esc=$(printf '%s' "$1" | sed 's/[&|\\\\]/\\\\&/g')
                sed -i -E "s|^([[:space:]]*path[[:space:]]*=).*|\\\\1 $esc|" "$conf"

                wallust run "$1"
            `

            function run(idx: number) {
                const path = win.wallpapers[win.currentIndex]
                if (!path) return
                win.confirmed = true     // preview
                previewTimer.stop()      // preview
                Quickshell.execDetached(["sh", "-c", win.setWallpaperScript, "_", path])
                UiState.hideWallpaperSwitcher()
            }

            Shortcut {
                sequences: ["Enter", "Return"]
                onActivated: {
                    win.run(win.currentIndex)
                }
            }

            Rectangle {
                id: container
                anchors.fill: parent
                radius: 12
                color: Theme.bg

                implicitWidth: list.implicitWidth + win.padding * 2
                implicitHeight: list.implicitHeight + win.padding * 2

                ListView {
                    id: list
                    anchors.fill: parent
                    anchors.margins: win.padding
                    orientation: ListView.Horizontal
                    spacing: 16
                    clip: true
                    model: win.wallpapers
                    currentIndex: win.currentIndex

                    implicitWidth: Math.min(contentWidth, win.screen.width * 0.6 - win.padding * 2)
                    implicitHeight: win.itemSize
                    highlightRangeMode:  !win.firstLoad ? ListView.NoHighlightRange : ListView.ApplyRange

                    // highlightRangeMode: contentWidth > width
                    //                     ? ListView.StrictlyEnforceRange
                    //                     : ListView.NoHighlightRange
                    preferredHighlightBegin: width / 2 - win.itemSize / 2
                    preferredHighlightEnd: width / 2 + win.itemSize / 2
                    highlightMoveDuration: 150

                    delegate: ClippingRectangle {
                        required property string modelData

                        width: win.itemSize
                        height: win.itemSize
                        radius: 12
                        color: "transparent"
                        opacity: ListView.isCurrentItem ? 1 : 0.5

                        Image {
                            anchors.fill: parent
                            source: "file://" + modelData
                            sourceSize: Qt.size(win.itemSize * 2, win.itemSize * 2)
                            asynchronous: true
                            fillMode: Image.PreserveAspectCrop
                        }
                    }
                }
            }
        }
    }
}
