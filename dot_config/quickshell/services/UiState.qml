pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root

    property bool barShown: true
    property bool powermenuShown: false
    property bool wallpaperSwitcherShown: false

    function showBar(){
        barShown = true
    }

    function hideBar(){
        barShown = false
    }

    function showPowermenu(){
        powermenuShown = true
    }

    function hidePowermenu(){
        powermenuShown = false
    }

    function showWallpaperSwitcher(){
        wallpaperSwitcherShown = true
    }

    function hideWallpaperSwitcher(){
        wallpaperSwitcherShown = false
    }
}
