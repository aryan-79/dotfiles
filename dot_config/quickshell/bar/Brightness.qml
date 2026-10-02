import qs.ui
import qs.services

Button {
    spacing: 8

    ThemedText {
        text: SystemUsage.getBrightnessIcon()
        size: ThemedText.Size.Sm
        anchors.verticalCenter: parent.verticalCenter
    }

    ThemedText {
        text: `${Math.round(SystemUsage.brightnessPerc * 100)}%`
    }

    onScrolledUp: SystemUsage.changeBrightness(0.05)
    onScrolledDown: SystemUsage.changeBrightness(-0.05)
}
