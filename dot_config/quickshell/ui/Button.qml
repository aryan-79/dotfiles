import QtQuick
import qs.theme

Pill {
    id: root

    property color bg: Theme.bg
    property color hoveredColor: Theme.hover
    property bool square: false

    property bool hovered: hoverProc.hovered

    signal clicked
    signal rightClicked
    signal middleClicked
    signal scrolledUp
    signal scrolledDown


    paddingX: square ? defaultPaddingX - 1 : defaultPaddingX
    // width defaults to implicitWidth (padding + maxWidth already handled in Pill)
    height: square ? width : implicitHeight
    color: hovered ? hoveredColor : bg

    TapHandler {
        onTapped: root.clicked()
    }

    TapHandler {
        acceptedButtons: Qt.RightButton
        onTapped: root.rightClicked()
    }

    TapHandler {
        acceptedButtons: Qt.MiddleButton
        onTapped: root.middleClicked()
    }

    WheelHandler {
        orientation: Qt.Vertical
        property: "y"
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        onRotationChanged: {
              if (rotation > 0)
                  root.scrolledUp()
              else if (rotation < 0)
                  root.scrolledDown()

              rotation = 0
          }
    }

    HoverHandler {
        id: hoverProc
        cursorShape: Qt.PointingHandCursor
        enabled: true
    }

    Behavior on color { ColorAnimation { duration: 150 } }
    Behavior on opacity { NumberAnimation { duration: 150 } }
}
