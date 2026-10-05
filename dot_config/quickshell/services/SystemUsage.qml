pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import Quickshell.Services.UPower

Singleton {
    id: root

    // set false to pause polling when UI is hidden
    property bool active: UiState.barShown

    property real cpuPerc: 0        // 0..1
    property real memUsed: 0        // kB
    property real memTotal: 1       // kB
    readonly property real memPerc: memTotal > 0 ? memUsed / memTotal : 0

    property real lastCpuIdle: 0
    property real lastCpuTotal: 0

    // battery
    readonly property var battery: UPower.displayDevice
    readonly property bool hasBattery: battery !== null && battery.isPresent
    readonly property real batteryPerc: hasBattery ? battery.percentage : 0   // 0..1
    readonly property bool charging: hasBattery
        && (battery.state === UPowerDeviceState.Charging
            || battery.state === UPowerDeviceState.FullyCharged)

    // empty -> full (Font Awesome battery glyphs in Nerd Fonts)
    readonly property var batteryIcons: ["\uf244", "\uf243", "\uf242", "\uf241", "\uf240"]
    readonly property int levelIndex: Math.min(4, Math.round(batteryPerc * 4))
    property int chargeTick: 0

    // charging: cycles from the current level up to full, then repeats
    // discharging: static icon for the current level
    readonly property string batteryIcon: charging
        ? batteryIcons[levelIndex + chargeTick % (5 - levelIndex)]
        : batteryIcons[levelIndex]

    Timer {
        interval: 800
        repeat: true
        running: root.charging && root.active
        onTriggered: root.chargeTick = (root.chargeTick + 1) % 60
    }

    property int maxBrightness: 0
    property int brightness: 0
    property real brightnessPerc: maxBrightness <= 0 ? 0 : brightness / maxBrightness

    FileView {
        id: statFile
        path: "/proc/stat"
        onLoaded: {
            const p = text().split("\n")[0].trim().split(/\s+/).slice(1, 9).map(Number)
            const idle = p[3] + p[4]
            const total = p.reduce((a, b) => a + b, 0)

            if (root.lastCpuTotal > 0) {
                const totalDiff = total - root.lastCpuTotal
                const idleDiff = idle - root.lastCpuIdle
                if (totalDiff > 0)
                    root.cpuPerc = 1 - idleDiff / totalDiff
            }
            root.lastCpuIdle = idle
            root.lastCpuTotal = total
        }
    }

    FileView {
        id: memFile
        path: "/proc/meminfo"
        onLoaded: {
            const t = text()
            const total = parseInt(t.match(/MemTotal:\s+(\d+)/)[1])
            const avail = parseInt(t.match(/MemAvailable:\s+(\d+)/)[1])
            root.memTotal = total
            root.memUsed = total - avail
        }
    }

    property real _pending: -1

    function refreshBrightnessStatus() {
        if (!getBrightnessProc.running && !setBrightnessProc.running) getBrightnessProc.running = true
    }

    function setBrightness(v: real) {
        brightnessPerc = Math.max(0.1, Math.min(1, v))
        _pending = brightnessPerc
        debounce.restart()
    }

    function changeBrightness(delta: real) {
        setBrightness(brightnessPerc + delta)
    }

    function getBrightnessIcon(){
        return "󰃠"
    }

    onActiveChanged: if(active) refreshBrightnessStatus()

    Process {
        id: getBrightnessProc
        command: ["sh", "-c", "echo \"$(brightnessctl g):$(brightnessctl m)\""]
        stdout: StdioCollector {
            onStreamFinished: {
                const values = text.trim().split(":")

                root.brightness = parseInt(values[0] ?? 0)
                root.maxBrightness = parseInt(values[1] ?? 0)
            }
        }
    }

    Process {
        id: setBrightnessProc
        onRunningChanged: {
            if (running) return
            if (root._pending >= 0) debounce.restart()
        }
    }

    Timer {
        id: debounce
        interval: 40
        onTriggered: {
            if (setBrightnessProc.running) return
            setBrightnessProc.command = ["brightnessctl", "set", Math.round(root._pending * 100) + "%"]
            root._pending = -1
            setBrightnessProc.running = true
        }
    }

    Timer {
        interval: 2000
        repeat: true
        running: root.active
        triggeredOnStart: true
        onTriggered: {
            statFile.reload()
            memFile.reload()
            root.refreshBrightnessStatus()
        }
    }

    // Component.onCompleted: {
    //     root.refreshBrightnessStatus()
    // }
}
