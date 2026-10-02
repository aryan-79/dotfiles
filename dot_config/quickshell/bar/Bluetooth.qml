import Quickshell
import QtQuick
import qs.ui
import qs.theme
import qs.services

Button {
    Row {
        spacing: 8

        ThemedText {
            text: Bt.getIcon()
            anchors.verticalCenter: parent.verticalCenter
            color: Bt.batteryLow ? Theme.danger : Theme.fg
        }

        ThemedText {
            text: Bt.text
        }
    }

    onClicked: Bt.toggle()
    onRightClicked: Quickshell.execDetached(["blueberry"])
    onMiddleClicked: Bt.disconnect()
}
