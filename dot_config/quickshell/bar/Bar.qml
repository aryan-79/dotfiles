import Quickshell
import QtQuick

Scope {
    id: root
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: panel
            required property ShellScreen modelData

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
