# Map type achievement fix

Map type achievements don't work in Linux.

The relevant code is in the Civ 5 game core source in `CvGame.cpp`:

```c++
					if(winnerMapName == "Assets\\Maps\\Continents.lua" )
						gDLL->UnlockAchievement( ACHIEVEMENT_MAPTYPE_CONTINENTS );
					else if(winnerMapName == "Assets\\Maps\\Pangaea.lua" )
						gDLL->UnlockAchievement( ACHIEVEMENT_MAPTYPE_PANGAEA);
					else if(winnerMapName == "Assets\\Maps\\Archipelago.lua" )
						gDLL->UnlockAchievement( ACHIEVEMENT_MAPTYPE_ARCHIPELAGO );
					else if(winnerMapName == "Assets\\Maps\\Earth_Duel.Civ5Map" || winnerMapName == "Assets\\Maps\\Earth_Huge.Civ5Map"
						|| winnerMapName == "Assets\\Maps\\Earth_Large.Civ5Map" || winnerMapName == "Assets\\Maps\\Earth_Small.Civ5Map"
						|| winnerMapName == "Assets\\Maps\\Earth_Standard.Civ5Map" || winnerMapName == "Assets\\Maps\\Earth_Tiny.Civ5Map")
						gDLL->UnlockAchievement( ACHIEVEMENT_MAPTYPE_EARTH );
```

But note that in a Linux save game, the actual map file is lower-cased:

```
$ strings AutoSave_Initial_0000\ BC-4000.Civ5Save | grep -i 'assets.*maps'
Assets\Maps\continents.lua
```

The fix is simple: lower-case just the map file name; before:

```
$ strings libCvGameCoreDLL.so | grep -i 'assets.*maps'
Assets\Maps\Continents.lua
Assets\Maps\Pangaea.lua
Assets\Maps\Archipelago.lua
Assets\Maps\Earth_Duel.Civ5Map
Assets\Maps\Earth_Huge.Civ5Map
Assets\Maps\Earth_Large.Civ5Map
Assets\Maps\Earth_Small.Civ5Map
Assets\Maps\Earth_Standard.Civ5Map
Assets\Maps\Earth_Tiny.Civ5Map
```

After:

```
$ strings libCvGameCoreDLL.so | grep -i 'assets.*maps'
Assets\Maps\continents.lua
Assets\Maps\pangaea.lua
Assets\Maps\archipelago.lua
Assets\Maps\earth_duel.civ5map
Assets\Maps\earth_huge.civ5map
Assets\Maps\earth_large.civ5map
Assets\Maps\earth_small.civ5map
Assets\Maps\earth_standard.civ5map
Assets\Maps\earth_tiny.civ5map
```
