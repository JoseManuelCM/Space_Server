
# Echo_Server --
#	Open the server listening socket
#	and enter the Tcl event loop
#
# Arguments:
#	port	The server's port number
proc Echo_Server {port} {
    set s [socket -server EchoAccept $port]
}

proc waiting {} {
    vwait forever    
}

# Echo_Accept --
#	Accept a connection from a new client.
#	This is called after a new socket connection
#	has been created by Tcl.
#
# Arguments:
#	sock	The new socket connection to the client
#	addr	The client's IP address
#	port	The client's port number
	
proc EchoAccept {sock addr port} {
    global clients
    global status
    # Record the client's information

    #set status_echo "Accept $sock from $addr port $port"
    set clients(addr,$sock) [list $addr $port $sock]

    #puts $status_echo

    # Ensure that each "puts" by the server
    # results in a network transmission

    fconfigure $sock -buffering line

    # Set up a callback for when the client sends data

    fileevent $sock readable [list Echo $sock]
    puts $sock [convert_to_string]
}

# Echo --
#	This procedure is called when the server
#	can read data from the client
#
# Arguments:
#	sock	The socket connection to the client

proc Echo {sock} {
    global clients
    # Check end of file or abnormal connection drop,
    # then echo data back to the client.
    if {[eof $sock] || [catch {gets $sock line}]} {
    	close $sock
    	unset clients(addr,$sock)
    } else {
       if {$line != ""} {
            set answer [check_space $line]
            puts $sock $answer
            Update $sock $line
       }
    }
}

proc check_space {id} \
{
    global status
    set ans $status($id) 
    set_status $id
    return $ans
}

proc set_status {id} \
{
    global status
    if {$status($id) == "libre"} {
        set status($id) "ocupado"
        GUI_disable_place $id
    } else {
        set status($id) "libre"
        GUI_enable_place $id
    }
}

proc Update {s p} \
{
    global clients
    set size [array size clients]
    foreach x [array get clients] {
        set sock [lindex $x 2]
        if {$sock != ""} {
            if {$s != $sock} {
                puts $sock [convert_to_string]
                puts $sock $p
            }
        }
    }
}


proc convert_to_string {} {
    global status
    set cad ""
    set sp " "
    set size [array size status]    
    for {set i 0} {$i<$size} {incr i} {
        set cad $cad$sp$status($i)    
    }
return $cad
}