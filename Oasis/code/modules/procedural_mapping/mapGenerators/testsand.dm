CLUSTER_CHECK_ALL				30

defineRegion(locate(1,1,1),locate(25,25,1),0)

/datum/mapGeneratorModule/bottomLayer/sandtest
	spawnableTurfs = list(/obj/structure/flora/tree/dead = 20)
	spawnableAtoms = list(/obj/structure/flora/rock = 25, /obj/structure/flora/rock/pile = 15)
/*
Simple Workflow:

	1. Define a/some mapGeneratorModule(s) to your liking, choosing atoms and turfs to spawn
	 #Note: I chose to split Turfs and Atoms off into separate modules, but this is NOT required.
	 #Note: A mapGeneratorModule may have turfs AND atoms, so long as each is in it's appropriate list

	2. Define a mapGenerator type who's modules list contains the typepath(s) of all the module(s) you wish to use
	 #Note: The order of the typepaths in the modules list is the order they will happen in, this is important for clusterCheckFlags.

	3. Take notes of the Bottom Left and Top Right turfs of your rectangular "map"'s coordinates
	 #Note: X,Y AND Z, Yes you can created 3D "maps" by having differing Z coords

	4. Create the mapGenerator type you created

	5. Call yourMapGeneratorType.defineRegion(locate(X,Y,Z), locate(X,Y,Z))
	 #Note: The above X/Y/Zs are the coordinates of the start and end turfs, the locate() simply finds the turf for the code

	6. Call yourMapGeneratorType.generate(), this will cause all the modules in the generator to build within the map bounds

Option Suggestions:

	* Have separate modules for Turfs and Atoms, this is not enforced, but it is how I have structured my nature example.
	* If your map doesn't look quite to your liking, simply jiggle with the variables on your modules and the type probabilities
	* You can mix and map premade areas with the procedural generation, for example mapping an entire flat land but having code generate just the grass tufts


Using the Modules list

	Simply think of it like each module is a layer in a graphics editing program!
	To help you do this templates such as /mapGeneratorModule/bottomLayer have been provided with appropriate default settings.
	These are located near the bottom of mapGeneratorModule.dm
	you would order your list left to right, top to bottom, e.g:
	modules = list(bottomLayer,nextLayer,nextNextLayer) etc.


Variable Breakdown (For Mappers):

	mapGenerator
		map - INTERNAL, do not touch
		modules - A list of typepaths of mapGeneratorModules

	mapGeneratorModule
		mother - INTERNAL, do not touch
		spawnableAtoms - A list of typepaths and their probability to spawn, eg: spawnableAtoms = list(/obj/structure/flora/tree/pine = 30)
		spawnableTurfs - A list of typepaths and their probability to spawn, eg: spawnableTurfs = list(/turf/unsimulated/floor/grass = 100)
		clusterMax - The max range to check for something being "too close" for this atom/turf to spawn, the true value is random between clusterMin and clusterMax
		clusterMin - The min range to check for something being "too close" for this atom/turf to spawn, the true value is random between clusterMin and clusterMax
		clusterCheckFlags - A Bitfield that controls how the cluster checks work, All based on clusterMin and clusterMax guides
		allowAtomsOnSpace - A Boolean for if we allow atoms to spawn on space tiles

		clusterCheckFlags flags:
			CLUSTER_CHECK_NONE	0 			   //No checks are done, cluster as much as possible
			CLUSTER_CHECK_DIFFERENT_TURFS	2  //Don't let turfs of DIFFERENT types cluster
			CLUSTER_CHECK_DIFFERENT_ATOMS	4  //Don't let atoms of DIFFERENT types cluster
			CLUSTER_CHECK_SAME_TURFS		8  //Don't let turfs of the SAME type cluster
			CLUSTER_CHECK_SAME_ATOMS		16 //Don't let atoms of the SAME type cluster

			CLUSTER_CHECK_SAMES				24 //Don't let any of the same type cluster
			CLUSTER_CHECK_DIFFERENTS		6  //Don't let any different types cluster
			CLUSTER_CHECK_ALL_TURFS			10 //Don't let ANY turfs cluster same and different types
			CLUSTER_CHECK_ALL_ATOMS			20 //Don't let ANY atoms cluster same and different types

			CLUSTER_CHECK_ALL				30 //Don't let anything cluster, like, at all
