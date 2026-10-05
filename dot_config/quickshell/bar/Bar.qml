import Quickshell
import QtQuick
import Quickshell.Wayland
import qs.services

Scope {
    id: root
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: panel
            WlrLayershell.namespace: "qs-bar"

            required property ShellScreen modelData

            visible: UiState.barShown

            margins {
                top: 2
                bottom: -5
                left: 6
                right: 6
            }


            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 40
            color: "transparent"

            Row {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                spacing: 6

                Workspaces {
                    screen: panel.modelData
                }

                SystemsInfo {}
            }

            Clock {
                anchors.centerIn: parent
            }

            Row {
                spacing: 6
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter


                Volume {}
                Brightness {}

                Bluetooth {}
                NetworkInfo {}

                Battery {}
            }
        }
    }
}
