import Quickshell
import QtQuick
import qs.ui
import qs.services

Button {
    Row {
        spacing: 8

        ThemedText {
            text: Audio.getAudioIcon()
            anchors.verticalCenter: parent.verticalCenter
        }

        ThemedText {
            text: `${Math.round(Audio.volume * 100)}%`
            font.strikeout: Audio.muted
        }
    }

    onClicked: Audio.toggleMute()
    onMiddleClicked: Quickshell.execDetached(["pavucontrol"])
    onRightClicked: Quickshell.execDetached(["pavucontrol"])
    onScrolledUp: Audio.changeVolume(0.05)
    onScrolledDown: Audio.changeVolume(-0.05)
}
