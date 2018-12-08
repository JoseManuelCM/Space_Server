set eje_y 70
proc GUI_init_client {} \
{
	wm title . {Iniciar Space Client}
	. configure -height 100
	. configure -width 300
	. configure -background white

	label .title -foreground white -background blue -font {Helvetica -20 bold} -text "Lugares en el Server" -justify left
	label .dHost -foreground blue -text "-Dirección del Server-" -justify left
	label .nPort -foreground blue -text "-Número de puerto-" -justify left
	button .conectar -text "Conectar" -font {times -15 bold} -foreground orange -background black -command Link_init_client
	entry .puerto -font {Helvetica -12 } -width 10 -textvariable n_puerto -justify right
	entry .host -font {Helvetica -15 } -width 10 -textvariable d_host -justify right
	place .conectar -x 110 -y 60
	place .puerto -x 30 -y 30 
	place .nPort -x 10 -y 10
	place .dHost -x 150 -y 10 
	place .host -x 170 -y 30
}

proc GUI_conect_server {arg} {
	global eje_y
	GUI_hide_items
	global spaces
	global mine
	convert_to_array $arg
	for {set i 0} {$i < 10} {incr i} {
		if {$spaces($i) == "libre"} {
			button .name($i) -text "Space $i: Libre" -font {times -15 bold} -foreground orange -background green -command "GUI_disabled_button $i"
			button .namefree($i) -text "Liberar Space $i" -font {times -15 bold} -foreground orange -background "indian red" -command "GUI_enable_button $i"
			.namefree($i) configure -state disabled
		} else {
			button .name($i) -text "Space $i: Ocupado" -font {times -15 bold} -foreground yellow -background red -command "GUI_disabled_button $i"
			button .namefree($i) -text "Liberar Space $i" -font {times -15 bold} -foreground orange -background "indian red" -command "GUI_enable_button $i"
			.name($i) configure -state disabled
			.namefree($i) configure -state disabled
		}
		set mine($i) 0
		place .name($i) -x 50 -y $eje_y
		place .namefree($i) -x 200 -y $eje_y
		set eje_y [expr $eje_y + 50]
	}
}

proc GUI_disabled_button {id} {
	global sock
	global mine
	set toggle [request_space $id]
	if {$toggle == "libre"} {
		.name($id) configure -state disabled
		.name($id) configure -text "Space $id: Ocupado"
		.name($id) configure -foreground yellow -background red
		.namefree($id) configure -state normal
		set mine($id) 1
	}
}

proc GUI_enable_button {id} {
	global sock
	global mine
	set toggle [request_space $id]
	if {$toggle == "ocupado"} {
		.name($id) configure -text "Space $id: Libre"
		.name($id) configure -foreground orange -background green
		.name($id) configure -state normal
		.namefree($id) configure -state disabled
		set mine($id) 0
	}
}



proc GUI_hide_items {} {
	place .title -x 20 -y 25
	place .conectar -x 1250 -y 1250
	place .puerto -x 1250 -y 1250
	place .nPort -x 1250 -y 1250
	place .dHost -x 1250 -y 1250
	place .host -x 1250 -y 1250
	. configure -height 575
	. configure -width 375
	. configure -background blue
}

proc GUI_get_port {} \
{
  global n_puerto
  return $n_puerto
}

proc GUI_get_host {} \
{
  global d_host
  return $d_host
}

wm protocol . WM_DELETE_WINDOW {
    if {[tk_messageBox -message "¿Desconectar Cliente?" -type yesno] eq "yes"} {
    	free_spaces
       exit 1
    }
}