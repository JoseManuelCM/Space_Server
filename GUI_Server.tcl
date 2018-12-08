proc GUI_init_server {} \
{
  wm title . {Iniciar Space Server}
  . configure -height 60
  . configure -width 250
  . configure -background white

  canvas .lienzo -background blue -width 175 -height 550

  label .nPort -foreground blue -text "-Número de puerto-" -justify left
  button .activar -text "Activar" -font {times -15 bold} -foreground orange -background black -command Link_init_server
  entry .puerto -font {Helvetica -12 } -width 10 -textvariable n_puerto -justify right
  place .activar -x 150 -y 10 
  place .puerto -x 30 -y 30 
  place .nPort -x 10 -y 10

}

proc  GUI_start_server {} \
{
  global status
  wm title . {Space Server}
  .activar configure -background blue
  .activar configure -foreground blue
  place .activar -x 505 -y 500
  place .puerto -x 505 -y 500
  place .nPort -x 505 -y 500
  place .lienzo -x 25 -y 25 
  . configure -height 600
  . configure -width 225
  . configure -background blue
  .lienzo create text 100 25 -fill goldenrod -justify center -text "   Espacios \n En Sevidor" -font {Helvetica -18 bold}

  set canvas_x1 25
  set canvas_x2 150
  set canvas_y1 50
  set canvas_y2 90

  for {set i 0} {$i < 10} {incr i} \
  {
      #places in canvas
    .lienzo create rectangle $canvas_x1 $canvas_y1 $canvas_x2 $canvas_y2  -fill green -tags names($i)
     #names of places
    .lienzo create text [expr $canvas_x1 + 70] [expr $canvas_y1 + 10] \
     -fill yellow -justify center -text "Lugar Nu. $i" -font {Helvetica -12 bold}

     set status($i) "libre"
     .lienzo create text [expr $canvas_x1 + 70] [expr $canvas_y1 + 25] \
     -fill orange -justify center -text $status($i) -font {Helvetica -12 bold} -tag free($i)
     
    set canvas_y1 [expr $canvas_y1 + 50]
    set canvas_y2 [expr $canvas_y2 + 50]
  }
}

proc GUI_disable_place {id} \
{
  .lienzo itemconfigure names($id) -fill red
  .lienzo itemconfigure free($id) -text ocupado -fill yellow
}

proc GUI_enable_place {id} \
{
  .lienzo itemconfigure names($id) -fill green
  .lienzo itemconfigure free($id) -text libre -fill yellow
}

proc GUI_get_port {} \
{
  global n_puerto
  return $n_puerto
}

wm protocol . WM_DELETE_WINDOW {
    if {[tk_messageBox -message "¿Apagar Servidor?" -type yesno] eq "yes"} {
       exit 1
    }
}