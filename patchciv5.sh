#!/usr/bin/env bash

# NOTE: Much of this has been copied from https://github.com/bmaupin/civ-be-linux-fixes/blob/main/patchcivbe.sh

# Exit right away if there are any errors (e.g. yq or another tool isn't installed)
set -e

game_directory="/home/${USER}/.local/share/Steam/steamapps/common/Sid Meier's Civilization V"

# Allow game directory to be overridden as a command-line parameter
if [ -n "${1}" ]; then
    game_directory="$1"
fi

# Detect whether we're using native or Proton
if [[ -f "${game_directory}/Civ5XP" ]]; then
    VERSION=linux
    echo "Detected native Linux version of Civ 5"
fi
if [[ -f "${game_directory}/CivilizationV.exe" ]]; then
    VERSION=windows
    echo "Detected Proton version of Civ 5"
fi
if [[ -z "${VERSION}" ]]; then
    echo "Error: Civ 5 installation directory not found. Please provide the path to Civ 5, e.g."
    echo "    $0 \"/home/${USER}/.local/share/Steam/steamapps/common/Sid Meier's Civilization V\""
    exit 1
fi

apply_linux_fixes() {
    echo "Deleting intro videos"
    rm -f "${game_directory}/steamassets/assets/dlc/expansion"/civ5xp_opening_movie*
    rm -f "${game_directory}/steamassets/assets/dlc/expansion2"/civ5xp2_opening_movie*
    rm -f "${game_directory}/steamassets"/civ5_opening_movie*

    echo "Skip legal screen"
    sed -i 's/        UIManager:QueuePopup( Controls.LegalScreen, PopupPriority.LegalScreen );/        -- UIManager:QueuePopup( Controls.LegalScreen, PopupPriority.LegalScreen );/' "${game_directory}/steamassets/assets/ui/frontend/frontend.lua"

    echo "Skip mods EULA dialogue"
    sed -i 's/^g_HasAcceptedEULA = false;/g_HasAcceptedEULA = true;/' "${game_directory}/steamassets/assets/ui/frontend/modding/eula.lua"
    sed -i '/--if not isHide and g_HasAcceptedEULA then/s/--//' "${game_directory}/steamassets/assets/ui/frontend/modding/eula.lua"
    sed -i '/--\s*NavigateForward();/s/--//' "${game_directory}/steamassets/assets/ui/frontend/modding/eula.lua"
    sed -i '/--end/s/--//' "${game_directory}/steamassets/assets/ui/frontend/modding/eula.lua"
    sed -i '/--if(not isHide and g_QueueEulaToHide) then/s/--//' "${game_directory}/steamassets/assets/ui/frontend/modding/eula.lua"
    sed -i '/--\s*NavigateBack();/s/--//' "${game_directory}/steamassets/assets/ui/frontend/modding/eula.lua"
    sed -i '/--end/s/--//' "${game_directory}/steamassets/assets/ui/frontend/modding/eula.lua"

    echo "Enabling achievements with mods"
    sed -i 's/SELECT ModID from Mods where Activated = 1/SELECT ModID from Mods where Activated = 2/' "${game_directory}/Civ5XP"

    # Doesn't work :/
    # echo "Fixing map type achievements"
    # sed -z -i '/^Assets\\Maps\\/s|\\|/|g' "${game_directory}/libCvGameCoreDLL.so"
    # sed -z -i '/^Assets\\Maps\\/s|\\|/|g' "${game_directory}/libCvGameCoreDLL_Expansion1.so"
    # sed -z -i '/^Assets\\Maps\\/s|\\|/|g' "${game_directory}/libCvGameCoreDLL_Expansion2.so"

    # Check to see if system is using Mesa 24 or newer
    if [[ $(glxinfo 2>/dev/null | grep -o "Mesa [0-9]\+\.[0-9]\+" | head -n 1 | awk '{print $2}' | cut -d . -f 1) -ge 24 ]]; then
        # Check to see if system is using Intel Iris graphics
        if lspci | grep VGA | grep -q Iris; then
            echo "⚠️ Intel Iris graphics detected with Mesa >= 24; crashes will occur!"
            echo "    To fix, set the game Launch Options in the Steam properties to:"
            echo "    MESA_LOADER_DRIVER_OVERRIDE=zink %command%"
        elif lspci | grep VGA | egrep -iq "intel|amd"; then
            echo "ⓘ Mesa >= 24 detected; if the game crashes try setting the game Launch Options in the Steam properties to:"
            echo "    MESA_LOADER_DRIVER_OVERRIDE=zink %command%"
        fi
    fi

    # Check to see if the system has more than 8 cores
    if [ "$(nproc --all)" -gt 8 ]; then
        echo "WARNING: System has more than 8 cores. See https://wiki.archlinux.org/title/Steam/Game-specific_troubleshooting#Civilization_V for details on how to fix potential crashes."
    fi
}

apply_windows_fixes() {
    echo "Deleting intro logo videos"
    rm -f "${game_directory}/Assets/DLC/Expansion"/Civ5XP_Opening_Movie*
    rm -f "${game_directory}/Assets/DLC/Expansion2"/Civ5XP2_Opening_Movie*
    rm -f "${game_directory}"/Civ5_Opening_Movie*

    echo "Skip legal screen"
    sed -i 's/        UIManager:QueuePopup( Controls.LegalScreen, PopupPriority.LegalScreen );/        -- UIManager:QueuePopup( Controls.LegalScreen, PopupPriority.LegalScreen );/' "${game_directory}/Assets/UI/FrontEnd/FrontEnd.lua"

    echo "Skip mods EULA dialogue"
    sed -i 's/^g_HasAcceptedEULA = false;/g_HasAcceptedEULA = true;/' "${game_directory}/Assets/UI/FrontEnd/Modding/EULA.lua"
    sed -i '/--if not isHide and g_HasAcceptedEULA then/s/--//' "${game_directory}/Assets/UI/FrontEnd/Modding/EULA.lua"
    sed -i '/--\s*NavigateForward();/s/--//' "${game_directory}/Assets/UI/FrontEnd/Modding/EULA.lua"
    sed -i '/--end/s/--//' "${game_directory}/Assets/UI/FrontEnd/Modding/EULA.lua"
    sed -i '/--if(not isHide and g_QueueEulaToHide) then/s/--//' "${game_directory}/Assets/UI/FrontEnd/Modding/EULA.lua"
    sed -i '/--\s*NavigateBack();/s/--//' "${game_directory}/Assets/UI/FrontEnd/Modding/EULA.lua"
    sed -i '/--end/s/--//' "${game_directory}/Assets/UI/FrontEnd/Modding/EULA.lua"

    echo "See here to enable achievements with mods: https://github.com/bmaupin/civ5-cheevos-with-mods"
}

if [[ "${VERSION}" == "linux" ]]; then
    apply_linux_fixes
elif [[ "${VERSION}" == "windows" ]]; then
    apply_windows_fixes
fi
