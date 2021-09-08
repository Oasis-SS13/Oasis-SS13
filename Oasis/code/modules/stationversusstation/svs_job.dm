#define ACCESS_SVS_RED 			401	// odd = Red
#define ACCESS_SVS_BLUE			402 // !odd = Blue
#define ACCESS_SVS_RADMIRAL 	403	// Red admiral
#define ACCESS_SVS_BADMIRAL		404	// Blue Admiral
#define ACCESS_SVS_RMINER		405	// Red Miner
#define ACCESS_SVS_BMINER		406	// Blue Miner
#define SVS_RED_TEAM_ADMIRAL	(1<<13)
#define SVS_RED_TEAM_MEMBER 	(1<<14)
#define SVS_BLUE_TEAM_ADMIRAL	(1<<15)
#define SVS_BLUE_TEAM_MEMBER	(1<<16)

///// BLUE TEAM /////

/*/datum/job/svs/blue/proc/egality()		//Makes sure there is not 10 people on blue team while only 2 in red team, and the other way
	num_positions_blue = current_positions
	if(num_positions_blue>num_positions_red)
		total_positions = 0
	else
		total_positions = 5*/

/datum/job/svs
	faction = "SVS"
	total_positions = 10
	spawn_positions = 10

/datum/job/svs/blue
	title = "Blue Team Member"
	flag = SVS_BLUE_TEAM_MEMBER
	department_head = list("Blue Team Admiral")
	department_flag = ENGSEC
	supervisors = "The Blue Team Admiral"
	selection_color = "#3532ff"
	chat_color = "#500bc0"

	outfit = /datum/outfit/job/svs/blue
	access = list(ACCESS_SVS_BLUE)

	var/num_positions_blue = 0

/datum/job/svs/blue/miner
	title = "Blue Team Miner"
	flag = SVS_BLUE_TEAM_MEMBER
	department_head = list("Blue Team Admiral")
	department_flag = ENGSEC
	selection_color = "#3532ff"
	chat_color = "#500bc0"
	total_positions = 3
	spawn_positions = 3

	outfit = /datum/outfit/job/svs/blue/miner
	access = list(ACCESS_SVS_BLUE, ACCESS_SVS_BMINER)

/datum/job/svs/blue/admiral
	title = "Blue Team Admiral"
	flag = SVS_BLUE_TEAM_ADMIRAL
	total_positions = 1
	spawn_positions = 1
	supervisors = "Yourself"
	selection_color = "#3532ff"
	chat_color = "#500bc0"

	outfit = /datum/outfit/job/svs/blue/admiral

	access = list(ACCESS_SVS_BADMIRAL, ACCESS_SVS_BLUE, ACCESS_SVS_BMINER)


///// RED TEAM /////


/*/datum/job/svs/red/proc/egality()		//Makes sure there is not 10 people on red team while only 2 in blue team, and the other way
	num_positions_red = current_positions
	if(num_positions_red>num_positions_blue)
		total_positions = 0
	else
		total_positions = 5*/

/datum/job/svs/red
	title = "Red Team Member"
	flag = SVS_RED_TEAM_MEMBER
	department_head = list("Red Team Admiral")
	department_flag = ENGSEC
	supervisors = "The Red Team Admiral"
	selection_color = "#ff3333"
	chat_color = "#cc0909"

	outfit = /datum/outfit/job/svs/red

	access = list(ACCESS_SVS_RED, ACCESS_SVS_RMINER)

	var/num_positions_red = 0

/datum/job/svs/red/miner
	title = "Red Team Miner"
	flag = SVS_RED_TEAM_MEMBER
	department_head = list("Red Team Admiral")
	department_flag = ENGSEC
	selection_color = "#ff3333"
	chat_color = "#cc0909"
	total_positions = 3
	spawn_positions = 3

	outfit = /datum/outfit/job/svs/red/miner

/datum/job/svs/red/admiral
	title = "Red Team Admiral"
	flag = SVS_RED_TEAM_ADMIRAL
	total_positions = 1
	spawn_positions = 1
	supervisors = "Yourself"
	selection_color = "#ff3333"
	chat_color = "#cc0909"

	outfit = /datum/outfit/job/svs/red/admiral
	access = list(ACCESS_SVS_RADMIRAL, ACCESS_SVS_RED, ACCESS_SVS_RMINER)
