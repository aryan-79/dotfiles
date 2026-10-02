pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Bluetooth

Singleton {
    id: root

    readonly property BluetoothAdapter adapter: Bluetooth.defaultAdapter
    readonly property bool enabled: adapter?.enabled ?? false

    readonly property BluetoothDevice connectedDevice: adapter?.devices.values.find(d => d.connected) ?? null
    readonly property bool connected: !!connectedDevice
    readonly property string name: connectedDevice?.name ?? ""

    readonly property bool batteryAvailable: connectedDevice?.batteryAvailable ?? false
    readonly property real battery: connectedDevice?.battery ?? 0
    readonly property bool batteryLow: batteryAvailable && battery < 0.2

    readonly property string text: !enabled ? "off" : (name !== "" ? name : "on")

    function getIcon(): string {
        if (enabled && connected) return "󰂱"
        if (enabled) return ""

        return "󰂲"
    }

    function toggle() {
        if (adapter) adapter.enabled = !adapter.enabled
    }

    function disconnect() {
        if (connectedDevice && connected) {
            connectedDevice.disconnect()
        }
    }
}
