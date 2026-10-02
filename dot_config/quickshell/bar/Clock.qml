import Quickshell
import QtQuick
import qs.ui
import qs.theme


Pill {
    paddingX: 14

    Row {
        spacing: 12
        SystemClock {
            id: clock
            precision: SystemClock.Minutes
        }

        ThemedText {
            text: Qt.formatTime(clock.date,"hh:mm AP")
        }

        ThemedText {
            size: ThemedText.Size.Xs
            anchors.verticalCenter: parent.verticalCenter
            text: Qt.formatDate(clock.date, "ddd, MMM dd")
            color: Theme.fgMuted
        }
    }
}
