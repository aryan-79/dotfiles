import Quickshell
import QtQuick

Scope {
    id: root
    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property ShellScreen modelData

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 40
            color: "transparent"

            Workspaces {
                screen: modelData
            }

            // Clock {}
        }
    }
}
