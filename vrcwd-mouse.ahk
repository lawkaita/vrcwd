scale := 15
reverse := -1 ; 1 for normal direction, -1 for mirror
mode := "nokon"

stretch_x_coeff := 0.5

sleep_draw := 40 ;40
sleep_skip := 15 ;15
sleep_changeline = 5
sleep_keydown = 30
mvsize := 2


handlePauseOff() {
  if (penIsDown == 1) {
    %penDown%()
  }
}

signum(var) {
  if ( var < 0 ) {
    return -1
  }
  if ( var = 0 ) {
    return 0
  }
  return 1
}

mouse_konDown() {
  global penIsDown
  global sleep_keydown

  penIsDown = 1

  sleep, sleep_keydown
  Send, {LShift down}
  sleep, sleep_keydown
  Send, {F4}
  sleep, sleep_keydown
  Send, {LShift up}

  return
}

mouse_konUp() {
  global penIsDown
  global sleep_keydown

  sleep, sleep_keydown
  Send, {LShift down}
  sleep, sleep_keydown
  Send, {F1}
  sleep, sleep_keydown
  Send, {LShift up}

  penIsDown = 0

  return
}

mouse_clickDown() {
  global mode
  if (mode = "kon") {
    mouse_konDown()
    return
  }
  DllCall("mouse_event", uint, 2, int, 0, int, 0)
}

mouse_clickUp() {
  global mode
  if (mode = "kon") {
    mouse_konUp()
    return
  }
  DllCall("mouse_event", uint, 4, int, 0, int, 0)
}

; move the mouse
; by executing DllCall "mouse_event" uint 1
; with small increments of position
; x and y are relative to current position
; meaning current position is origin in this call
mouse_move(x, y, _sleep, mvsize) {
  global reverse
  global stretch_x_coeff

  if (x != 0) {
    k := y/x
  } else {
    k := 1
  }

  sk := signum(k)
  wk := sk * k ; k used with work y: absolute value = positive value

  sx := signum(x)
  sy := signum(y)
  wx := sx * x * stretch_x_coeff ; work x
  wy := sy * y ; work y
  dx := mvsize
  dy := wk * mvsize
  while ( (wx > 0) OR (wy > 0) )
  {
    xx := reverse * sx * dx
    yy := sy * dy
    DllCall("mouse_event", uint, 1, int, xx, int, yy)

    if ( wx > 0 ) {
      wx := wx - dx
    } else {
      dx := 0
    }

    if ( wy > 0 ) {
      wy := wy - dy
    } else {
      dy := 0
    }

    sleep _sleep
  }
}

mouse_move_dumb(x,y) {
  DllCall("mouse_event", uint, 1, int, x, int, y)
}
