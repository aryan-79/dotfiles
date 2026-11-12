pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Bluetooth

Singleton {
    id: root

    readonly property BluetoothAdapter adapter: Bluetooth.defaultAdapter
    readonly property bool enabled: adapter?.enabled ?? false

    // hide nameless, unpaired devices (BLE spam)
    property bool hideUnnamed: true

    readonly property var devices: adapter?.devices.values ?? []
    readonly property var connectedDevice: devices.find(d => d.connected) ?? null
    readonly property bool connected: !!connectedDevice
    readonly property string name: connectedDevice?.name ?? ""

    readonly property bool batteryAvailable: connectedDevice?.batteryAvailable ?? false
    readonly property real battery: connectedDevice?.battery ?? 0
    readonly property bool batteryLow: batteryAvailable && battery < 0.2

    readonly property string text: !enabled ? "off" : (name !== "" ? name : "on")

    // connected first, then paired, then by name
    readonly property var sortedDevices: devices
        .filter(d => !hideUnnamed || d.connected || d.paired || (d.name ?? "") !== "")
        .sort((a, b) => (b.connected - a.connected) || (b.paired - a.paired)
            || (a.name || a.address).localeCompare(b.name || b.address))

    function getIcon(): string {
        if (enabled && connected)
            return "󰂱";
        if (enabled)
            return "";

        return "󰂲";
    }

    function toggle() {
        if (adapter)
            adapter.enabled = !adapter.enabled;
    }

    function disconnect() {
        if (connectedDevice && connected)
            connectedDevice.disconnect();
    }

    function setScanning(on: bool) {
        if (!adapter || !adapter.enabled) return
        if (adapter.discovering !== on) adapter.discovering = on
    }

    function toggleConnect(d) {
        if (!d) return;
        d.connected ? d.disconnect() : d.connect();
    }

    function pair(d) {
        if (!d) return;
        if (d.pairing) d.cancelPair();
        else if (!d.paired) {
            d.trusted = true;
            d.pair();
        }
    }

    function unpair(d) {
        if (d && d.paired)
            d.forget();
    }
}
