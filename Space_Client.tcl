#
# A client of the echo service.
#
proc Echo_Client {host port} {
    set s [socket $host $port]

    fconfigure $s -buffering line
    fileevent $s readable [list Update $s]

    return $s
}

proc sesion {host port} \
{
	global sock
 	set sock [Echo_Client $host $port]	
 	gets $sock space
 	GUI_conect_server $space
}

proc request_space {id} \
{
	global sock
	puts $sock $id
	gets $sock answer
	return $answer	
}

proc convert_to_array {args} \
{
	global spaces
	set i 0
	foreach x [split $args " "] {
		set spc($i) $x
		incr i
	}
	if {$spc(10) == "libre\}"} {
		set spc(10) "libre"
	} else {
		set spc(10) "ocupado"
	}
	for {set i 0} {$i < 10} {incr i} {
		set spaces($i) $spc([expr $i +1])
	}
}

proc Update {sock} \
{
	global spaces
	global mine
	gets $sock spc
	gets $sock place
	if {$spc != ""} {
		convert_to_array $spc
		if {$spaces($place) == "ocupado"} {
			.name($place) configure -state disabled
			.name($place) configure -text "Space $place: Ocupado"
			.name($place) configure -foreground yellow -background red
			if {$mine($place) == 1} {
				.namefree($place) configure -state normal	
			}
		} else {
			.name($place) configure -text "Space $place: Libre"
			.name($place) configure -foreground orange -background green
			.name($place) configure -state normal
			.namefree($place) configure -state disabled	
		}
	} else {
		exit 0
	}
}

proc free_spaces {} \
{
	global mine
	for {set i 0} {$i < 10} {incr i} {
		if {$mine($i) == 1} {
			GUI_enable_button $i			
		}
	}
}
# A sample client session looks like this
#   set sock [Echo_Client localhost 9999]
#   puts $s "Hello!"
#   gets $s line