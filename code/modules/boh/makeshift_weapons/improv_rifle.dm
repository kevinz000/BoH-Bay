/obj/item/weapon/gun/projectile/manualcycle/imprifle
	item_icons = list(
		slot_l_hand_str = 'icons/mob/onmob/items/lefthand_guns.dmi',
		slot_r_hand_str = 'icons/mob/onmob/items/righthand_guns.dmi',
		)
	name = "improvised rifle"
	icon = 'icons/boh/items/guns.dmi'
	desc = "A shoddy 7.62 improvised rifle."
	wielded_item_state = "woodarifle-wielded"
	icon_state = "308bolt"
	item_state = "dshotgun" //placeholder
	w_class = 5
	one_hand_penalty = 4
	force = 10
	slot_flags = SLOT_BACK
	origin_tech = list(TECH_COMBAT=2, TECH_MATERIALS=1)
	caliber = "7mmR"
	//fire_sound = 'sound/weapons/sniper.ogg'
	handle_casings = HOLD_CASINGS
	load_method = SINGLE_CASING
	max_shells = 3
	ammo_type = /obj/item/ammo_casing/rifle
	accuracy = -1


/obj/item/weapon/gun/projectile/manualcycle/imprifle/impriflesawn
	item_icons = list(
		slot_l_hand_str = 'icons/mob/onmob/items/lefthand_guns.dmi',
		slot_r_hand_str = 'icons/mob/onmob/items/righthand_guns.dmi',
		)
	name = "improvised short rifle"
	icon = 'icons/boh/items/guns.dmi'
	desc = "A crudely cut down 7.62 improvised rifle."
	icon_state = "308boltsawed"
	item_state = "sawnshotgun" //placeholder
	w_class = 4
	one_hand_penalty = 0
	force = 4
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	origin_tech = list(TECH_COMBAT=2, TECH_MATERIALS=1)
	caliber = "7mmR"
	//fire_sound = 'sound/weapons/sniper.ogg'
	handle_casings = HOLD_CASINGS
	load_method = SINGLE_CASING
	max_shells = 3
	ammo_type =	/obj/item/ammo_casing/rifle
	accuracy = -2

/obj/item/weapon/imprifleframe/imprifleframesawn
	name = "unfinished improvised short rifle"
	desc = "An almost-complete improvised short rifle."
	icon = 'icons/boh/items/guns.dmi'
	icon_state = "308boltsawed"
	item_state = "sawnshotgun"

/obj/item/weapon/imprifleframe
	name = "improvised rifle stock"
	desc = "A half-finished improvised rifle."
	icon = 'icons/boh/items/guns.dmi'
	icon_state = "308boltframe0"
	item_state = "sawnshotgun"
	var/buildstate = 0

/obj/item/weapon/imprifleframe/update_icon()
	icon_state = "308boltframe[buildstate]"

/obj/item/weapon/imprifleframe/examine(mob/user)
	. = ..(user)
	switch(buildstate)
		if(1) user << "It has an unfinished pipe barrel in place on the wooden furniture."
		if(2) user << "It has an unfinished pipe barrel wired in place."
		if(3) user << "It has an unfinished reinforced pipe barrel wired in place."
		if(4) user << "It has a reinforced pipe barrel secured on the wooden furniture."
		if(5) user << "It has an unsecured reciever in place."
		if(6) user << "It has a secured reciever in place."
		if(7) user << "It has an unfinished pipe bolt in place."
		if(8) user << "It has a finished unsecured pipe bolt in place."

/obj/item/weapon/imprifleframe/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/pipe))
		if(buildstate == 0)
			user.drop_from_inventory(W)
			qdel(W)
			user << "<span class='notice'>You place the piping on the stock.</span>"
			buildstate++
			update_icon()
			return
		if(buildstate == 7)
			user.drop_from_inventory(W)
			qdel(W)
			user << "<span class='notice'>You install a bolt on the frame.</span>"
			buildstate++
			playsound(src.loc, 'sound/items/syringeproj.ogg', 100, 1)
			update_icon()
			return
	else if(istype(W,/obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/C = W
		if(buildstate == 1)
			if(C.use(10))
				user << "<span class='notice'>You secure the barrel to the wooden furniture with wire.</span>"
				buildstate++
				update_icon()
			else
				user << "<span class='notice'>You need at least ten segments of cable coil to complete this task.</span>"
			return
	else if(istype(W,/obj/item/weapon/screwdriver))
		if(buildstate == 2)
			user << "<span class='notice'>You further secure the barrel to the wooden furniture.</span>"
			buildstate++
			playsound(src.loc, 'sound/items/Screwdriver2.ogg', 100, 1)
			return
		if(buildstate == 6)
			user << "<span class='notice'>You secure the metal reciever.</span>"
			buildstate++
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 100, 1)
			return
	else if(istype(W,/obj/item/stack/material) && W.get_material_name() == "plasteel")
		if(buildstate == 3)
			var/obj/item/stack/material/P = W
			if(P.use(5))
				user << "<span class='notice'>You reinforce the barrel with plasteel.</span>"
				buildstate++
				playsound(src.loc, 'sound/items/Deconstruct.ogg', 100, 1)
			else
				user << "<span class='notice'>You need at least five plasteel sheets to complete this task.</span>"
			return
	else if(istype(W,/obj/item/weapon/wrench))
		if(buildstate == 4)
			user << "<span class='notice'>You secure the reinforced barrel.</span>"
			buildstate++
			playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
			return
	else if(istype(W,/obj/item/stack/material) && W.get_material_name() == DEFAULT_WALL_MATERIAL)
		if(buildstate == 5)
			var/obj/item/stack/material/P = W
			if(P.use(10))
				user << "<span class='notice'>You assemble and install a metal reciever onto the frame</span>"
				buildstate++
				update_icon()
				playsound(src.loc, 'sound/items/Crowbar.ogg', 100, 1)
			else
				user << "<span class='notice'>You need at least ten steel sheets to complete this task.</span>"
			return
	else if(istype(W,/obj/item/weapon/weldingtool))
		if(buildstate == 8)
			var/obj/item/weapon/weldingtool/T = W
			if(T.remove_fuel(5,user))
				if(!src || !T.isOn()) return
				playsound(src.loc, 'sound/items/Welder2.ogg', 100, 1)
			user << "<span class='notice'>You secure the improvised rifle's various parts.</span>"
			var/obj/item/weapon/gun/projectile/manualcycle/imprifle/emptymag = new /obj/item/weapon/gun/projectile/manualcycle/imprifle(get_turf(src))
			emptymag.loaded = list()
			qdel(src)
		return
	else if(istype(W,/obj/item/weapon/circular_saw))
		if(buildstate == 8)
			user << "<span class='notice'>You saw the barrel on the unfinished improvised rifle down.</span>"
			new /obj/item/weapon/imprifleframe/imprifleframesawn(get_turf(src))
			playsound(src.loc, 'sound/weapons/circsawhit.ogg', 100, 1)
			qdel(src)
		return
	else
/obj/item/weapon/imprifleframe/imprifleframesawn/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/weldingtool))
		if(buildstate == 0)
			var/obj/item/weapon/weldingtool/T = W
			if(T.remove_fuel(5,user))
				if(!src || !T.isOn()) return
				playsound(src.loc, 'sound/items/Welder2.ogg', 100, 1)
			user << "<span class='notice'>You secure the improvised rifle's various parts.</span>"
			var/obj/item/weapon/gun/projectile/manualcycle/imprifle/impriflesawn/emptymag = new /obj/item/weapon/gun/projectile/manualcycle/imprifle/impriflesawn(get_turf(src))
			emptymag.loaded = list()
			qdel(src)
		return
	..()