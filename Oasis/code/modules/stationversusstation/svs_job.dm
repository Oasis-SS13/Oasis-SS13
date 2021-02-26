#define ACCESS_SVS_RED 			401
#define ACCESS_SVS_BLUE			402
#define SVS_RED_TEAM_ADMIRAL	(1<<13)
#define SVS_RED_TEAM_MEMBER 	(1<<14)
#define SVS_BLUE_TEAM_ADMIRAL	(1<<15)
#define SVS_BLUE_TEAM_MEMBER	(1<<16)

/datum/job/svsblue
	title = "Blue Team Member"
	flag = SVS_BLUE_TEAM_MEMBER
	department_head = list("Blue Team Admiral")
	department_flag = ENGSEC
	faction = "SVS"
	total_positions = 9999 // hacky, but eh
	spawn_positions = 9999
	supervisors = "The Blue Team Admiral"
	selection_color = "#0000ff"
	chat_color = "#500bc0"

	outfit = /datum/outfit/job/svs/blue

	access = list(ACCESS_SVS_BLUE)
	minimal_access = list(ACCESS_SVS_BLUE)

/datum/job/svsblue_admiral
	title = "Blue Team Admiral"
	flag = SVS_BLUE_TEAM_ADMIRAL
	faction = "SVS"
	total_positions = 1
	spawn_positions = 1
	supervisors = "Yourself"
	selection_color = "#0000ff"
	chat_color = "#500bc0"

	outfit = /datum/outfit/job/svs/blue/admiral

/datum/job/svsblue_admiral/get_access()
	return (get_all_accesses() | ACCESS_SVS_BLUE)

/datum/job/svsred
	title = "Red Team Member"
	flag = SVS_RED_TEAM_MEMBER
	department_head = list("Red Team Admiral")
	department_flag = ENGSEC
	faction = "SVS"
	total_positions = 9999
	spawn_positions = 9999
	supervisors = "The Red Team Admiral"
	selection_color = "#ff0000"
	chat_color = "#cc0909"

	outfit = /datum/outfit/job/svs/red

	access = list(ACCESS_SVS_RED)
	minimal_access = list(ACCESS_SVS_RED)

/datum/job/svsred_admiral
	title = "Red Team Admiral"
	flag = SVS_RED_TEAM_ADMIRAL
	faction = "SVS"
	total_positions = 1
	spawn_positions = 1
	supervisors = "Yourself"
	selection_color = "#ff0000"
	chat_color = "#cc0909"

	outfit = /datum/outfit/job/svs/red/admiral

/datum/job/svsred_admiral/get_access()
	return (get_all_accesses() | ACCESS_SVS_RED)
