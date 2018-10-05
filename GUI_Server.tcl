canvas .lienzo -background blue -text "numero 1" -width 300 -height 600 
pack .lienzo
button .conectar -text "Conectar" -font {times -15 bold} -foreground orange -background black -command activate
pack .conectar
.lienzo create rectangle 10 10 100 50 -fill red -tag t1
proc activate {} {
    .lienzo itemconfigure t1 -fill green 
}