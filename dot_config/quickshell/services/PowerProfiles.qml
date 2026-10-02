pragma Singleton

import Quickshell
import Quickshell.Services.UPower

// sudo pacman -S upower power-profiles-daemon
// sudo systemctl enable --now upower power-profiles-daemon

Singleton {
    id: root

    readonly property string activeProfile: {
        switch (PowerProfiles.profile) {
        case PowerProfile.Performance: return "performance"
        case PowerProfile.PowerSaver:  return "power-saver"
        default:                       return "balanced"
        }
    }

    readonly property list<string> availableProfiles: PowerProfiles.hasPerformanceProfile
        ? ["performance", "balanced", "power-saver"]
        : ["balanced", "power-saver"]

    function setProfile(profile: string) {
        if (!availableProfiles.includes(profile)) return
        PowerProfiles.profile = {
            "performance": PowerProfile.Performance,
            "balanced":    PowerProfile.Balanced,
            "power-saver": PowerProfile.PowerSaver
        }[profile]
    }

    function cycleProfile() {
        const idx = availableProfiles.indexOf(activeProfile)
        console.log("profile index: ", idx)
        if (idx < 0){
            setProfile("balanced")
            return
        }


        const nextIdx = (idx + 1) % availableProfiles.length
        setProfile(availableProfiles[nextIdx])
    }
}
