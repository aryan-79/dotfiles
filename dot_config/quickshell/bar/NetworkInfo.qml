import QtQuick
import Quickshell
import qs.ui
import qs.services

Button {
    id: root

    property var wired: Network.wired
    property var wifiNet: Network.wifiNet
    property bool hasInternetAccess: Network.hasInternetAccess

    Row {
        spacing: 8

        ThemedText {
            size: ThemedText.Size.Sm
            text: root.wired ? "\uef09"
            : root.wifiNet ?
                Network.getWifiIcon(root.wifiNet.signalStrength, root.hasInternetAccess)
                : "\udb82\udd2b"
            anchors.verticalCenter: parent.verticalCenter
        }

        ThemedText {
            text: root.wired ? "Wired"
                : root.wifiNet ? root.wifiNet.name
                : "Disconnected"
        }
    }

    onClicked: Quickshell.execDetached(["ghostty", "-e", "impala"])
}
