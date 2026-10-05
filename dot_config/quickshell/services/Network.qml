pragma Singleton
import Quickshell
import Quickshell.Networking

Singleton {
    id: root

    readonly property WiredDevice wired: Networking.devices.values
           .find(d => d.type === DeviceType.Wired && d.connected) ?? null

    readonly property WifiNetwork wifiNet: {
        for (const d of Networking.devices.values) {
            if (d.type !== DeviceType.Wifi || !d.connected) continue
            const n = d.networks.values.find(n => n.connected)
            if (n) return n
        }
        return null
    }

    readonly property bool hasInternetAccess: Networking.connectivity === NetworkConnectivity.Full

    function getWifiIcon(s: real, internetAccess: bool): string {
        if (!wifiNet || !wifiNet.connected) {
            return "󰤭"
        }

        if (internetAccess){
            if (s >= 0.9){
                return "󰤨"
            }
            if (s >= 0.75 && s < 0.9) {
                return "󰤥"
            }
            if (s >= 0.5 && s < 0.75) {
                return "󰤢"
            }
            if (s >= 0.25 && s < 0.5) {
                return "󰤟"
            }

            return "󰤯"
        } else {
            if (s >= 0.9){
                return "󰤩"
            }
            if (s >= 0.75 && s < 0.9) {
                return "󰤦"
            }
            if (s >= 0.5 && s < 0.75) {
                return "󰤣"
            }

            if (s >= 0.25 && s < 0.5) {
                return "󰤠"
            }
            return "󰤫"
        }
    }
}
