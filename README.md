Various fixes and workarounds for Sid Meier's Civilization: V on Linux

📌 [See my other Civ projects here](https://github.com/search?q=user%3Abmaupin+topic%3Acivilization&type=Repositories)

💡 Much of the information here may also apply to the Steam Deck

## Native or Proton?

👉 Most people will have a better experience playing the game with Proton (better performance, fewer bugs, better graphics)

The native version of the game has the following issues:

- Security vulnerability ([CVE-2026-116111](https://www.rapid7.com/db/vulnerabilities/cve-2026-116111/))
- Crashes with Mesa 24 and newer on Intel graphics
  - A workaround is available; see or run patch script for more information
- [Map type achievements are broken](https://steamcommunity.com/app/8930/discussions/0/558756256352674968/)
  - The patch script will fix this


#### Choose the native Linux version or Proton

1. Open Steam and go to _Library_

1. Find _Sid Meier's Civilization V_ and right-click on it > _Properties_

1. _Compatibility_ > check _Force the use of a specific Steam Play compatibility tool_

1. Click the dropdown

   - To use Proton, choose a version of _Proton_

     - Normally the latest stable version is fine. If you have issues, try another version.

   - To use native, choose _Steam Linux Runtime 1.0_

1. (Recommended) Run the [all-in-one patch script](#all-in-one-patch-script)

## All-in-one patch script

ⓘ This includes fixes for many issues (mostly for the native Linux version) as well as quality-of-life changes like enabling achievements with mods, disabling intro videos and EULA dialogues, etc.

1. Download the patch script: [patchciv5.sh](patchciv5.sh)

1. (Optional) Open the patch script and comment out any undesired changes

1. Run the patch script

   ```
   ./patchciv5.sh
   ```

   ⓘ It will default to `"/home/${USER}/.steam/steam/steamapps/common/Sid Meier's Civilization V"` for the Civ V installation directory. If you have it installed somewhere else you can provide it as a parameter to the script, e.g.

   ```
   ./patchciv5.sh /some/other/path
   ```

⚠️ If you switch between Proton and native, uninstall the game, or verify the integrity of the game files, the patches will be uninstalled and will need to be re-applied.

## Uninstall

To uninstall the all-in-one patch script or any other modifications:

1. Open Steam and go to _Library_

1. Find _Sid Meier's Civilization V_ and right-click on it > _Properties_

1. _Installed Files_ > _Verify integrity of game files_
