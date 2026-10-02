pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire

Singleton {
    id: root

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property PwNodeAudio audio: sink?.audio ?? null

    readonly property real volume: audio?.volume ?? 0
    readonly property bool muted: audio?.muted ?? false
    readonly property bool ready: audio !== null

    readonly property var props: sink?.properties ?? ({})
    readonly property int deviceId: parseInt(props["device.id"] ?? "-1")
    readonly property bool isBluetooth: (props["device.api"] ?? "") === "bluez5"
        || (sink?.name ?? "").startsWith("bluez_output")
    readonly property bool isAlsa: (sink?.name ?? "").startsWith("alsa_output")

    property string deviceIcon: ""
    property string deviceFormFactor: ""
    property string deviceBus: ""

    readonly property string iconName: props["device.icon-name"] || deviceIcon
    readonly property string formFactor: props["device.form-factor"] || deviceFormFactor
    readonly property string bus: props["device.bus"] || deviceBus

    property bool jackHeadphones: false

    readonly property string kind: {
        if (!ready) return "none"
        if (isBluetooth || bus === "bluetooth") return "bluetooth"
        if (isAlsa && jackHeadphones) return "headphones"
        switch (formFactor) {
        case "headphone":
        case "headset":
        case "hands-free": return "headphones"
        case "speaker":
        case "hifi":
        case "portable": return "speaker"
        case "tv": return "display"
        case "internal": return "internal"
        default: return bus === "usb" ? "usb" : "unknown"
        }
    }

    PwObjectTracker {
        objects: [root.sink]
    }

    function setVolume(v: real): void {
        if (!audio) return
        audio.volume = Math.max(0, Math.min(1, v))
    }

    function changeVolume(delta: real): void {
        setVolume(volume + delta)
    }

    function toggleMute(): void {
        if (!audio) return
        audio.muted = !audio.muted
    }

    function getAudioIcon() : string {
        if (!ready || muted || volume <= 0 || kind === "unknown" || kind === "none") return ""

        switch (kind) {
            case "bluetooth": return "󰥰"

            case "headphones": return "󰋋"

            case "speaker":
            case "tv":
            case "internal":
            case "usb": {
                if (volume >= 0.9) return ""
                if (volume >= 0.75 && volume < 0.9) return ""
                if (volume >= 0.5 && volume < 0.75) return ""
                if (volume >= 0.25 && volume < 0.5) return ""
                return ""
            }
            default: return ""
        }
    }

    Process {
        id: deviceProc
        command: ["sh", "-c",
            `pw-dump ${root.deviceId} | jq -r '.[0].info.props | [(."device.icon-name" // ""), (."device.form-factor" // ""), (."device.bus" // "")] | @tsv'`]
        stdout: SplitParser {
            onRead: line => {
                const [icon, ff, bus] = line.split("\t")
                root.deviceIcon = icon ?? ""
                root.deviceFormFactor = ff ?? ""
                root.deviceBus = (bus ?? "").trim()
            }
        }
    }

    function refreshDevice(): void {
        deviceIcon = ""
        deviceFormFactor = ""
        deviceBus = ""
        deviceProc.running = false
        if (deviceId >= 0) deviceProc.running = true
    }

    onDeviceIdChanged: refreshDevice()

    // ── Jack monitor: prints active port now and on every sink event ──
    Process {
        id: portProc
        running: true
        command: ["sh", "-c", `
            get() {
                pactl list sinks | awk '/Name: alsa_output/{f=1; next} f && /Active Port:/{print $3; exit}'
            }
            get
            pactl subscribe | grep --line-buffered "sink" | while read -r _; do get; done
        `]
        stdout: SplitParser {
            onRead: port => root.jackHeadphones = port.trim() === "analog-output-headphones"
        }
    }
}
