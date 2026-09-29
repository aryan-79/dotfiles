pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    readonly property alias bg: adapter.bg
    readonly property alias surface: adapter.surface
    readonly property alias hover: adapter.hover
    readonly property alias fg: adapter.fg
    readonly property alias fgMuted: adapter.fgMuted
    readonly property alias accent: adapter.accent
    readonly property alias accentMuted: adapter.accentMuted
    readonly property alias info: adapter.info
    readonly property alias infoMuted: adapter.infoMuted
    readonly property alias warn: adapter.warn
    readonly property alias danger: adapter.danger
    readonly property alias font: adapter.font
    readonly property alias fontSize: adapter.fontSize
    readonly property alias radius: adapter.radius

    FileView {
        id: themeFile

        path: Quickshell.env("HOME") + "/.config/quickshell/theme/theme.json"
        watchChanges: true

        onFileChanged: reload()

        JsonAdapter {
            id: adapter

            property color bg: "#171A1A"
            property color fg: "#F4DBCB"
            property color surface: "#414545"
            property color hover: "#A28879"
            property color fgMuted: "#E7C2AD"
            property color accent: "#CB8C66"
            property color accentMuted: "#A77E66"
            property color info: "#7D877C"
            property color infoMuted: "#6C746B"
            property color warn: "#F59E0B"
            property color danger: "#EF4444"

            property string font: "Maple Mono NF CN"
            property int fontSize: 16

            property int radius: 6
        }
    }
}
