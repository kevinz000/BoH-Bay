/obj/item/weapon/gun/projectile/manualcycle
	var/bolt_open = 0

/obj/item/weapon/gun/projectile/manualcycle/update_icon()
	..()
	if(bolt_open)
		icon_state = "[initial(icon_state)]_alt"
	else
		icon_state = "[initial(icon_state)]"

/obj/item/weapon/gun/projectile/manualcycle/attack_self(mob/user as mob)
	playsound(src.loc, 'sound/weapons/flipblade.ogg', 50, 1)
	bolt_open = !bolt_open
	if(bolt_open)
		if(chambered)
			user << "<span class='notice'>You work the bolt open, ejecting [chambered]!</span>"
			chambered.loc = get_turf(src)
			loaded -= chambered
			chambered = null
		else
			user << "<span class='notice'>You work the bolt open.</span>"
	else
		user << "<span class='notice'>You work the bolt closed.</span>"
		bolt_open = 0
	add_fingerprint(user)
	update_icon()

/obj/item/weapon/gun/projectile/manualcycle/special_check(mob/user)
	if(bolt_open)
		user << "<span class='warning'>You can't fire [src] while the bolt is open!</span>"
		return 0
	return ..()

/obj/item/weapon/gun/projectile/manualcycle/load_ammo(var/obj/item/A, mob/user)
	if(!bolt_open)
		return
	..()

/obj/item/weapon/gun/projectile/manualcycle/unload_ammo(mob/user, var/allow_dump=1)
	if(!bolt_open)
		return
	..()