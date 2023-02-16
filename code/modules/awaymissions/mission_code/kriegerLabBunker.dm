/obj/item/paper/researchnotes/krieglab

/obj/item/paper/researchnotes/krieglab/New()
	..()
	var/list/possible_techs = list("materials", "biotech", "programming")
	var/mytech = pick(possible_techs)
	var/mylevel = rand(6, 8)
	origin_tech = "[mytech]=[mylevel]"
	name = "research notes - [mytech] [mylevel]"

/obj/structure/safe/krieglab/Initialize()
	var/tech_spawn = pick(list(/obj/item/paper/researchnotes/krieglab))
	new tech_spawn(loc)
	return ..()

/obj/structure/safe/random_documents/Initialize()
	var/doc_spawn = pick(list(/obj/item/documents, /obj/item/documents/nanotrasen, /obj/item/documents/syndicate, /obj/item/documents/syndicate/yellow/trapped))
	new doc_spawn(loc)
	return ..()
