/area/vision_change_area/object_sampo
	poweralm = FALSE
	report_alerts = FALSE
	there_can_be_many = TRUE
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED
	ambientsounds = list('sound/ambience/spooky/chill.ogg',\
						'sound/ambience/spooky/angels.ogg',\
						'sound/ambience/spooky/clank1.ogg',\
						'sound/ambience/spooky/decafinatd.ogg',\
						'sound/ambience/spooky/distantclank1.ogg',\
						'sound/ambience/spooky/groan3.ogg',\
						'sound/ambience/spooky/groan2.ogg',\
						'sound/ambience/spooky/metaldoor2.ogg',\
						'sound/ambience/spooky/metaldoor1.ogg',\
						'sound/ambience/spooky/howled_4.ogg',\
						'sound/ambience/spooky/ugrnd_ambient_banging_1.ogg',\
						'sound/ambience/spooky/ugrnd_ambient_banging_2.ogg',\
						'sound/ambience/spooky/ugrnd_drip_3.ogg',\
						'sound/ambience/spooky/ugrnd_drip_4.ogg',\
						'sound/ambience/spooky/ugrnd_drip_5.ogg',\
						'sound/ambience/spooky/ugrnd_drip_6.ogg',\
						'sound/ambience/spooky/ugrnd_drip_7.ogg',\
						'sound/ambience/spooky/argitoth.ogg',\
						'sound/ambience/spooky/crystal_underground.ogg',\
						'sound/ambience/spooky/moon_underground.ogg',\
						'sound/ambience/spooky/horror.ogg',\
						'sound/ambience/spooky/horror_2.ogg',\
						'sound/ambience/spooky/horror_3.ogg',\
						'sound/ambience/spooky/ominous_loop1.ogg',\
						'sound/ambience/spooky/burning_terror.ogg')

	min_ambience_cooldown = 15 SECONDS
	max_ambience_cooldown = 30 SECONDS

/area/ruin/space/test ////////////////////////////не забыть удалить
	name = "Test area" /////////////////////////////////отбалансить хп и шанс отрубания у гориллы; отбалансить количество мясных зомбей и их хп/урон, скорость
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED ////////////////////

/area/vision_change_area/object_sampo/main_lab
	name = "Main laboratory"
	icon_state = "away1"
	var/battle = FALSE
	var/cooldown = FALSE
	var/list/intruders_list
	var/mob/living/simple_animal/hostile/skinner/boss

/area/vision_change_area/object_sampo/entrence
	name = "Entrence"
	icon_state = "away2"

/area/vision_change_area/object_sampo/kitchen
	name = "Kitchen"
	icon_state = "away3"

/area/vision_change_area/object_sampo/dorms
	name = "Dorms"
	icon_state = "away4"

/area/vision_change_area/object_sampo/check_point
	name = "Check point"
	icon_state = "away5"

/area/vision_change_area/object_sampo/virology
	name = "Virology"
	icon_state = "away6"

/area/vision_change_area/object_sampo/second_lab
	name = "Second laboratory"
	icon_state = "away7"

/area/vision_change_area/object_sampo/maintenance
	name = "Maintenance"
	icon_state = "away8"

/area/vision_change_area/object_sampo/cap_office
	name = "Captain's office"
	icon_state = "away9"

/area/vision_change_area/object_sampo/outside
	name = "Outside"
	icon_state = "away10"
	has_gravity = FALSE
	ambientsounds = list('sound/ambience/spooky/bass_ambience.ogg',\
						'sound/ambience/spooky/space_loop1.ogg',\
						'sound/ambience/spooky/space_loop2.ogg',\
						'sound/ambience/spooky/space_loop3.ogg',\
						'sound/ambience/spooky/space_loop4.ogg',\
						'sound/ambience/spooky/space_loop5.ogg')

/area/vision_change_area/object_sampo/near_asteroid
	name = "Space near the asteroid"
	icon_state = "away11"
	has_gravity = FALSE
	ambientsounds = list('sound/ambience/spooky/dark_ambient_ eerie.ogg',\
						'sound/ambience/spooky/deep_ominous_drone.ogg',\
						'sound/ambience/spooky/space_loop1.ogg',\
						'sound/ambience/spooky/space_loop2.ogg',\
						'sound/ambience/spooky/space_loop3.ogg',\
						'sound/ambience/spooky/space_loop4.ogg',\
						'sound/ambience/spooky/space_loop5.ogg')
	min_ambience_cooldown = 15 SECONDS
	max_ambience_cooldown = 30 SECONDS

/area/vision_change_area/object_sampo/self_destruct
	name = "Self destruct"
	icon_state = "away12"
	var/obj/machinery/syndicatebomb/our_bomb
	var/sd_triggered = FALSE

///////////////////////
////////////// BOSS AREA
///////////////////////

/area/vision_change_area/object_sampo/main_lab/proc/BlockBlastDoors()
	if(battle)
		return
	for(var/obj/machinery/door/poddoor/impassable/P in GLOB.airlocks)
		if(P.id_tag == "[name]" && P.z == z)
			INVOKE_ASYNC(P, TYPE_PROC_REF(/obj/machinery/door, close))
	battle = TRUE
	for(var/mob/trapped_one as anything in intruders_list)
		to_chat(trapped_one, span_danger("Обнаружены неизвестные формы жизни! Активирован протокол: КАРАНТИН!"))

/area/vision_change_area/object_sampo/main_lab/proc/ready_or_not()
	SIGNAL_HANDLER
	for(var/mob/living/intruders as anything in intruders_list)
		if(intruders.is_dead() || !boss || boss.is_dead() || !intruders.mind)
			remove_from_intruders(intruders)

	if(length(intruders_list))
		BlockBlastDoors()

/area/vision_change_area/object_sampo/main_lab/Entered(atom/movable/arrived)
	. = ..()
	if(!boss || boss.is_dead())
		return

	var/mob/living/living_mob = arrived
	if(ismecha(arrived))
		var/obj/mecha/mecha = arrived
		if(mecha.occupant)
			living_mob = mecha.occupant

	if(istype(arrived, /obj/structure/closet))
		for(var/mob/living/living in arrived)
			add_to_intruders(living)

	add_to_intruders(living_mob)

	if(cooldown)
		return
	cooldown = TRUE
	addtimer(VARSET_CALLBACK(src, cooldown, FALSE), 5 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(ready_or_not)), 4 SECONDS, TIMER_UNIQUE)

/area/vision_change_area/object_sampo/main_lab/Exited(atom/movable/departed)
	. = ..()
	if(!boss || boss.is_dead())
		return
	var/mob/living/living_mob = departed
	if(ismecha(departed))
		var/obj/mecha/mecha = departed
		if(mecha.occupant)
			living_mob = mecha.occupant

	if(istype(departed, /obj/structure/closet))
		for(var/mob/living/living in departed)
			remove_from_intruders(living)

	remove_from_intruders(living_mob)

/area/vision_change_area/object_sampo/main_lab/proc/add_to_intruders(mob/living/living_mob)
	if(!istype(living_mob))
		return FALSE
	if(!living_mob.mind || living_mob.is_dead())
		return FALSE
	LAZYADD(intruders_list, living_mob)
	RegisterSignal(living_mob, COMSIG_MOB_DEATH, PROC_REF(ready_or_not))
	return TRUE

/area/vision_change_area/object_sampo/main_lab/proc/remove_from_intruders(mob/living/living_mob)
	if(!istype(living_mob))
		return FALSE
	if(living_mob in intruders_list)
		intruders_list.Remove(living_mob)
		UnregisterSignal(living_mob, COMSIG_MOB_DEATH)
		return TRUE

///////////////////////
////////////// PRINCIPAL SKINNER
///////////////////////

/mob/living/simple_animal/hostile/skinner
	name = "Skinner"
	icon = 'icons/mob/winter_mob.dmi'
	icon_state = "placeholder"
	icon_living = "placeholder"
	icon_dead = "placeholder"
	faction = list("hostile", "undead")
	speak_chance = 0
	turns_per_move = 5
	speed = 0
	maxHealth = 150		//if this seems low for a "boss", it's because you have to fight him multiple times, with him fully healing between stages
	health = 150
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	sentience_type = SENTIENCE_OTHER
	robust_searching = 1
	vision_range = 12
	melee_damage_lower = 3
	melee_damage_upper = 7
	var/next_stage = null
	var/death_message
	/// If TRUE you should spawn it only on special area, see bossfight_area
	var/with_area = TRUE

	var/area/vision_change_area/object_sampo/main_lab/bossfight_area

/mob/living/simple_animal/hostile/skinner/Initialize(mapload)
	. = ..()
	if(with_area)
		bossfight_area = get_area(src)
		bossfight_area.boss = src

/mob/living/simple_animal/hostile/skinner/death(gibbed)
	. = ..(gibbed)
	if(!.)
		return FALSE // Only execute the below if we successfully died
	if(death_message)
		visible_message(death_message)
	if(next_stage)
		spawn(1 SECONDS)
			if(!QDELETED(src))
				new next_stage(get_turf(src))
				qdel(src)
			bossfight_area?.ready_or_not()
	else
		new /obj/effect/particle_effect/smoke/vomiting (get_turf(src))
		new /mob/living/simple_animal/hostile/living_limb_flesh (get_turf(src))
		new /mob/living/simple_animal/hostile/living_limb_flesh (get_turf(src))
		new /obj/item/reagent_containers/food/snacks/monstermeat/rotten/jumping (get_turf(src))
		new /obj/item/reagent_containers/food/snacks/monstermeat/rotten/jumping (get_turf(src))
		new /obj/item/nullrod/armblade (get_turf(src))
		gib(src)
		bossfight_area?.ready_or_not()

/mob/living/simple_animal/hostile/skinner/stage_1		//stage 1: weak melee
	desc = "PERISH OR DIE!"
	icon = 'icons/mob/simple_human.dmi'
	icon_state = "skinner"
	icon_living = "skinner"
	icon_dead = "skinner"
	maxHealth = 60
	health = 60
	next_stage = /mob/living/simple_animal/hostile/skinner/stage_2
	death_message = "<span class='danger'>I SMELL YOUR FLESH! PREPARE TO DIE!</span>"
	melee_damage_lower = 10
	melee_damage_upper = 20

/mob/living/simple_animal/hostile/skinner/stage_1/without_area
	with_area = FALSE
	next_stage = /mob/living/simple_animal/hostile/skinner/stage_2/without_area

/mob/living/simple_animal/hostile/skinner/stage_2		//stage 2: strong melee
	desc = "PERISH OR DIE AGAIN!"
	icon = 'icons/mob/simple_human.dmi'
	icon_state = "skinner_transform"
	icon_living = "skinner_transform"
	icon_dead = "skinner_transform"
	death_message = "ROOOOAAA RAAA!"
	maxHealth = 200
	health = 200
	melee_damage_upper = 30
	sharp_attack = TRUE
	canmove = FALSE

/mob/living/simple_animal/hostile/skinner/stage_2/without_area
	with_area = FALSE

/mob/living/simple_animal/hostile/skinner/stage_2/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, update_icon), UPDATE_ICON_STATE), 1.5 SECONDS)
	addtimer(VARSET_CALLBACK(src, canmove, TRUE), 1 SECONDS)

/mob/living/simple_animal/hostile/skinner/stage_2/update_icon_state()
	icon_state = "skinner_monster"
	icon_living = "skinner_monster"

///////////////////////
////////////// SYNT MEAT MONKEY
///////////////////////

/mob/living/simple_animal/hostile/syntmeat_monkey
	name = "\improper meat boy"
	desc = "As tasty as normal cow."
	icon = 'icons/obj/objects.dmi'
	icon_state = "stok_old"
	icon_living = "stok_old"
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/syntiflesh = 4)
	response_help  = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm   = "kicks the"
	attacktext = "царапает"
	death_sound = 'sound/goonstation/voice/monkey_scream.ogg'
	tts_seed = "Bounty"
	speak_chance = 2
	speak = list("Baaa!","ROOOOAAA RAAA!","Hee-haw.")
	speak_emote = list("screams","roars")
	emote_hear = list("screams")
	emote_see = list("scratches itself","waving its paws")
	health = 35
	maxHealth = 35
	flip_on_death = TRUE
	retaliate_only = TRUE
	melee_damage_lower = 7
	melee_damage_upper = 12

/mob/living/simple_animal/hostile/syntmeat_monkey/proc/get_random_name()
	return "[lowertext(name)] ([rand(100,999)])"

///////////////////////
////////////// SELF DESTRUCT
///////////////////////

/area/vision_change_area/object_sampo/self_destruct/Entered(mob/living/interloper)
	. = ..()
	if(!sd_triggered && istype(interloper))
		sd_triggered = TRUE
		add_game_logs("[key_name(interloper)] entered [src]. Self-destruction mechanism activated")
		our_bomb.payload?.adminlog = "[our_bomb] detonated in [src]. Self-destruction activated by [key_name(interloper)]!"
		our_bomb.activate()
		for(var/obj/machinery/power/apc/alarm in GLOB.apcs)
			if(alarm.z == our_bomb.z && get_dist(get_turf(our_bomb), alarm) < 50)
				playsound(alarm, 'sound/effects/alarm_30sec.ogg', 100)

#define NONACTIVE_STATE "hatch"
#define ACTIVATING_STATE "unfloored"
#define DEACTIVATING_STATE "floored"
#define IDLE_STATE "base"

/obj/machinery/syndicatebomb/object_sampo
	name = "self destruct device"
	desc = "High explosive. Don't touch."
	icon = 'icons/obj/machines/nuke_terminal.dmi'
	icon_state = "nuclearbomb_hatch"
	minimum_timer = 30
	timer_set = 30
	payload = /obj/item/bombcore/object_sampo
	can_unanchor = FALSE
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	invisibility = INVISIBILITY_ABSTRACT
	var/activate_state = null

/obj/machinery/syndicatebomb/object_sampo/Initialize(mapload)
	. = ..()
	var/area/vision_change_area/object_sampo/self_destruct/our_area = locate() in GLOB.all_areas
	if(istype(our_area))
		our_area.our_bomb = src

/obj/machinery/syndicatebomb/object_sampo/activate()
	. = ..()
	invisibility = 0
	INVOKE_ASYNC(src, PROC_REF(animate_on))

/obj/machinery/syndicatebomb/object_sampo/proc/animate_on()
	sleep(2 SECONDS)
	activate_state = ACTIVATING_STATE
	update_icon(UPDATE_ICON_STATE)
	sleep(3 SECONDS)
	activate_state = IDLE_STATE
	update_icon(UPDATE_ICON_STATE)

/obj/machinery/syndicatebomb/object_sampo/proc/animate_off()
	sleep(2 SECONDS)
	activate_state = DEACTIVATING_STATE
	update_icon(UPDATE_ICON_STATE)
	sleep(3 SECONDS)
	activate_state = NONACTIVE_STATE
	update_icon(UPDATE_ICON_STATE)


/obj/machinery/syndicatebomb/object_sampo/update_icon_state()
	if(activate_state)
		icon_state = "nuclearbomb_[activate_state]"

#undef NONACTIVE_STATE
#undef ACTIVATING_STATE
#undef DEACTIVATING_STATE
#undef IDLE_STATE

/obj/item/bombcore/object_sampo
	range_heavy = 45
	range_medium = 45
	range_light = 40
	range_flame = 50
	admin_log = TRUE
	ignorecap = TRUE
	special_deletes = TRUE

/obj/item/bombcore/object_sampo/delete_unnecessary(center)
	var/list/deletion_list = typecacheof(list(
								/obj/structure/safe,
								/obj/item/gun,
								/obj/item/card/id,
								/obj/item/clothing/suit/space/hardsuit,
								/obj/machinery/door/poddoor,
								/obj/machinery/power/apc,
								/obj/machinery/ninja_bloodscan_machine,
								/obj/machinery/light,
								/obj/item/decorations/distillator,
								/obj/structure/table))
	for(var/atom/A as anything in range(25, center))
		if(isliving(A))
			var/mob/living/mob = A
			mob.gib()
		if(istype(A, /obj/structure/closet))
			for(var/obj/item/I in A.contents)
				qdel(I)
			qdel(A)
		if(is_type_in_typecache(A, deletion_list))
			qdel(A)

/obj/item/bombcore/object_sampo/defuse()
	var/obj/machinery/syndicatebomb/object_sampo/C = loc
	C.animate_off()
	new /obj/effect/decal/cleanable/ash(get_turf(loc))
	new /obj/effect/particle_effect/smoke(get_turf(loc))
	playsound(src, 'sound/effects/empulse.ogg', 80)

///////////////////////
////////////// CHEMICALS
///////////////////////

/datum/chemical_reaction/syntiflesh2
	name = "Syntiflesh 2.0"
	id = "syntiflesh2"
	result = null
	required_reagents = list("blood" = 5, "meatocreatadone" = 5)
	result_amount = 1

/datum/chemical_reaction/syntiflesh2/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i in 1 to created_volume)
		new /obj/item/reagent_containers/food/snacks/meat/syntiflesh(location)

/datum/chemical_reaction/livingflesh
	name = "Living flesh"
	id = "livingflesh"
	min_temp = 1000
	result = null
	required_reagents = list("mutagen" = 25, "meatocreatadone" = 25)
	result_amount = 1

/datum/chemical_reaction/livingflesh/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i in 1 to created_volume)
		new /mob/living/simple_animal/hostile/living_limb_flesh(location)

/datum/reagent/medicine/meatocreatadone
	data = list("diseases" = null)
	name = "Meatocreatadone"
	id = "meatocreatadone"
	description = "Вязкая тянучая масса с едким и тошнотворным запахом. Если все же принюхаться, то можно уловить нотки тухлого мяса."
	reagent_state = LIQUID
	color = "#4e0303"
	taste_description = "bitterness"
	can_synth = FALSE
	heart_rate_increase = 1

/obj/item/reagent_containers/glass/beaker/large/meatocreatadone
	list_reagents = list("meatocreatadone" = 100)

/obj/item/reagent_containers/glass/beaker/vial/mutagen
	list_reagents = list("mutagen" = 25)
	icon_state = "vial-green"

///////////////////////
////////////// GASEOUS VIRUS
///////////////////////

/obj/effect/viral_gas
	name = "stinky air"
	icon = 'icons/effects/tile_effects.dmi'
	icon_state = "sleeping_agent"
	layer = FLY_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	color = "#024d0cc2"
	var/virus = /datum/disease/virus/cadaver
	var/chance_of_infection = 20
	var/alpha_after_Init = 30

/obj/effect/viral_gas/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/caltrop/virus, probability = chance_of_infection, flags = CALTROP_BYPASS_WALKERS, virus_type = virus)
	alpha = alpha_after_Init

/obj/effect/viral_gas/is_cleanable()
	if(!QDELETED(src))
		return TRUE

/obj/effect/viral_gas/water_act(volume, temperature, source, method)
	. = ..()
	qdel(src)

///////////////////////
////////////// VIRUS PILL
///////////////////////

/obj/item/reagent_containers/food/pill/random_object_sampo_virus
	spawned_disease = /datum/disease/virus/advance/object_sampo_random
	disease_amount = 0.1

/datum/disease/virus/advance/object_sampo_random
	var/static/list/random_symptoms = list(
		/datum/symptom/voice_change,
		/datum/symptom/mind_restoration,
		/datum/symptom/sensory_restoration,
		/datum/symptom/vomit/projectile,
		/datum/symptom/shedding,
		/datum/symptom/laugh,
		/datum/symptom/love,
		/datum/symptom/damage_converter,
		/datum/symptom/oxygen,
		/datum/symptom/painkiller,
		/datum/symptom/epinephrine,
		/datum/symptom/itching,
		/datum/symptom/dizzy,
		/datum/symptom/limb_throw,
		/datum/symptom/bones,
		/datum/symptom/moan,
	)

/datum/disease/virus/advance/object_sampo_random/New()
	var/list/random_symptoms_copy = random_symptoms.Copy()
	for(var/i in 1 to rand(4, 6))
		var/datum/symptom/symptom_path = pick_n_take(random_symptoms_copy)
		symptoms += new symptom_path
	..()
	name = capitalize(pick(GLOB.adjectives)) + " " + capitalize(pick(GLOB.nouns + GLOB.verbs))

/obj/item/reagent_containers/food/pill/random_object_sampo_disease
	disease_amount = 0.1

/obj/item/reagent_containers/food/pill/random_object_sampo_disease/New()
	spawned_disease = pick(
		/datum/disease/virus/transformation/jungle_fever,
		/datum/disease/virus/anxiety,
		/datum/disease/virus/beesease,
		/datum/disease/food_poisoning,
		/datum/disease/vampire,
		/datum/disease/virus/fake_gbs,
		/datum/disease/virus/pierrot_throat,
		/datum/disease/virus/advance/preset/pre_loyalty
	)
	..()

///////////////////////
////////////// PAPRERS
///////////////////////

/obj/item/paper/crumpled/object_sampo
	language = LANGUAGE_NEO_RUSSIAN

/obj/item/paper/crumpled/object_sampo/virus
	name = "Новые вирусы и паталогии"
	info = "<p>Разработка синтетического вируса под кодом █████████████ ведется с переменным успехом. Вирус приобрел некотролируемую форму развития и влияния на геном,\
	в текущем виде он более подходит для боевых задач, нежели для развития синтетических форм. Несмотря на свою смертоносность: █████████████ приподнес некоторые полезные открытия. \
	В частности мы смогли создать из мясных макак более мускулистую и сообразительную... назовем это \"гориллой\". Горилла имеет более выраженный интеллект, \
	однако пока что не поддается дрессировке; но я верю, что мы сможем использовать её в качестве боевой единицы.</p>"

/obj/item/paper/crumpled/object_sampo/meatocreatadone
	name = "Синтетическая плоть"
	info = "<p>После стабилизации meatocreatadone можно использовать не только для создания мясных макак, но и для быстрого взращивания мясных тканей: достаточно смешать \
	meatocreatadone с кровью в пропорции 1 к 1.<br /> \
	Последующие эксперементы по модификации реагента пока что не дают явных успехов. Однако, кажется я приближаюсь к открытию новой реакции на mutagen. \
	Было замечено, что при нагреве meatocreatadone начинает образовывать мышичные ткани, но они отличны от синтетической плоти. Пока что я не приблизился к \
	нужной формуле... Я уверен - еще чуть чуть и будет прорыв! Пока я понял одно: чем больше мутагена и горячее состав - тем быстрее образуются ткани.</p>"

/obj/item/paper/crumpled/object_sampo/lastwords
	name = "Что здесь произошло..."
	info = "<p>БЛЯТЬ! Мне отсюда уже не выбраться... Группа зачистки работает уже несколько часов, но по крикам и стихающим выстрелам — понятно, что эта срань побеждает. \
	Кажется эксперемент Дерповского пошел совсем не по плану... Что там могло произойти то? Я не верю в то, что он говорил о своей жиже, НУ НЕ МОГЛА ОНА ТАК БЫСТРО МУТИРОВАТЬ!</p>"

/obj/item/joke_collection
	name = "1000 и 1 анекдот"
	desc = "Пронумерованный сборник лучших анекдотов и юморесок за 23-ий век."
	icon = 'icons/obj/library.dmi'
	icon_state = "bookHacking"
	throw_speed = 1
	throw_range = 10
	force = 3
	resistance_flags = FLAMMABLE
	attack_verb = list("bashed", "whacked")
	drop_sound = 'sound/items/handling/book_drop.ogg'
	pickup_sound = 'sound/items/handling/book_pickup.ogg'

/obj/item/joke_collection/attack_self(mob/living/user)
	if(!(GLOB.all_languages[LANGUAGE_GALACTIC_COMMON] in user.languages))
		to_chat(user, "<span class='notice'>Вы видите какие-то символы, но не представляете, что они значат.</span>")
		return
	if(user.has_vision())
		if(do_after(user, 1 SECONDS, target = user))
			to_chat(user, "<span class='notice'>Вы прочли анекдот под номером [rand(1,1001)]!</span>")
			if(prob(40))
				user.emote(pick("laugh", "giggle", "smile"))
			else if(!(CLUMSY in user.mutations) && prob(15))
				user.adjustBrainLoss(rand(3,5))
		else
			to_chat(user, "<span class='notice'>Вы не успели дочитать анекдот.</span>")
			return
	else
		to_chat(user, "<span class='notice'>Вы ощупали предмет, скорее всего это дешёвая книга.</span>")
		return

