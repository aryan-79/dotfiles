pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root

    property bool barShown: true
    property bool powermenuShown: false

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
}
