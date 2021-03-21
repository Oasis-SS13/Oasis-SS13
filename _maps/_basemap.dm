//#define LOWMEMORYMODE //uncomment this to load centcom and runtime station and thats it.

#include "map_files\generic\CentCom.dmm"

#ifndef LOWMEMORYMODE
	#ifdef ALL_MAPS
		#include "map_files\Mining\Lavaland.dmm"
		#include "map_files\Mining\Lavaland-SvS.dmm"
		#include "map_files\Mining\Caves.dmm"

		#include "map_files\debug\runtimestation.dmm"
		#include "map_files\Deltastation\DeltaStation2.dmm"
		#include "map_files\MetaStation\MetaStation.dmm"
		#include "map_files\PubbyStation\PubbyStation.dmm"
		#include "map_files\BoxStation\BoxStation.dmm"
		#include "map_files\Donutstation\Donutstation.dmm"
		#include "map_files\KiloStation\KiloStation.dmm"
		#include "map_files\EndoStation\EndoStation.dmm"
		#include "map_files\ShipStation\ShipStation.dmm"
		#include "map_files\ScorchStation\ScorchStation.dmm"

		#ifdef CIBUILDING
			#include "templates.dm"
		#endif
	#endif
#endif
