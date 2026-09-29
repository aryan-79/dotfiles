import Quickshell
import QtQuick
import qs.theme

Item {
    anchors.centerIn: parent
    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    Rectangle {
        Text {
            text: Qt.formatDateTime(clock.date, "hh:mm AP  yyyy-MM-dd")
            color: Theme.fg
        }
    }
}
