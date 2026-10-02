import QtQuick
import qs.theme

Text {
    id: root

    enum Size { Default, Sm, Xs, Lg, Xl }

    property int size: ThemedText.Size.Default

    font.family: Theme.font
    font.pixelSize: {
        switch (root.size) {
            case ThemedText.Size.Sm: return Theme.fontSize - 2
            case ThemedText.Size.Xs: return Theme.fontSize - 6
            case ThemedText.Size.Lg: return Theme.fontSize + 2
            case ThemedText.Size.Xl: return Theme.fontSize + 6
            default: return Theme.fontSize
        }
    }

    color: Theme.fg

    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter

    elide: Text.ElideRight
}
