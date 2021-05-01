fn_textbox() {
  InputBox text, WRITE
  If ErrorLevel
    Return ; Cancelled
  
  return text
}

fn_hint(var) {
  MsgBox, %var%
}

fn_charIsSpace(char) {
  charIsSpace = 0
  if (char = " ") {
    charIsSpace = 1
  }
  ;fn_hint(format("'{}',{}", char, charIsSpace))
  return charIsSpace
}

linelen := 8
fn_moveToStartPos(text) {
  global linelen
  global mvsize
  global sleep_draw
  global sleep_changeline
  global scale
  global yonechar
  global xonechar
  len := strlen(text)
  h := 0
  while (len > (2*linelen)) {
    len := len - linelen
    h := h + 1
  }
  startposx := -1 * scale * (len/2) * xonechar
  startposy := -1 * scale * h * yonechar
  _mvsize := mvsize
  _sleep := sleep_changeline
  ;fn_hint(format("{}, {}, {}, {}", startposx, startposy, _sleep, _mvsize))
  mouse_move(startposx,startposy, _sleep, _mvsize)
  sleep _sleep
}
fn_parse(text) {
  if (strlen(text) = 0) {
    return
  }
  fn_moveToStartPos(text)

  char := substr(text,1,1)
  glyph := fn_getGlyph(char)
  instructions := %glyph%
  ;fn_hint(instructions)
  xstart := substr(instructions,1,1)
  ystart := substr(instructions,2,1)
  xend := l
  yend := h
  fn_darwGlyph(xend, yend, xstart, ystart, instructions)

  text := substr(text,2)
  linepos := 1
  Loop, Parse, text
  {
    char := A_LoopField
    glyph := fn_getGlyph(char)
    instructions := %glyph%
    xstart := substr(instructions,1,1)
    ystart := substr(instructions,2,1)
    linepos := fn_moveToNewCharPos(xend, yend, xstart, ystart, linepos, char)
    fn_darwGlyph(xend, yend, xstart, ystart, instructions)
  }
} 

xspacing = 0.5
yspacing = 0.8
xonechar := 2
yonechar := 7
;(xend,yend) is the end of the previous glyph
;(xstart,ystart) is the beginning of the new glyph
;to move to new position, assume just movning from lh prev to lh next.
;this movement in glyph coordinates amounts to going to rh to lh in the same glyph space
;add scaled spacing to move glyphs apart
;substract (xend,yend) to go to lh prev, then move lh->rh, then add new (xstart,ystart)
;this assumes glyph origin is lh
fn_moveToNewCharPos(xendsym, yendsym, xstartsym, ystartsym, linepos, char) {
  global scale
  global xspacing
  global yspacing
  global glyph_symToInt
  global sleep_skip
  global sleep_changeline
  global mvsize
  global linelen
  global xonechar
  global yonechar
  
  _xspacing := xspacing
  xend := glyph_symToInt[xendsym]
  yend := glyph_symToInt[yendsym]
  xstart := glyph_symToInt[xstartsym]
  ystart := glyph_symToInt[ystartsym]
  charIsSpace := fn_charIsSpace(char)
  if ((linepos > linelen) AND (charIsSpace = 1)) {
    _yspacing = yspacing
    _mvsize := 4*mvsize
    ; why does a huge mvsize help with yspacing bug?
    ; too small mvsize and yspacing is broken 
    ; large enough or larger, and it seems to work perfectly
    _sleep := sleep_changeline
    dx := scale * ( -xend - linepos*xonechar - (linepos-1)*_xspacing + xstart)
    ;fn_hint(format("{},{},{},{},{},{}", xend, linepos, xonechar, linepos-1, _xspacing, xstart))
    dy := scale * ( -yend + yonechar + yspacing + ystart )
    ;fn_hint(format("{},{}", dx, dy))
    linepos = 0
    sleep _sleep
    mouse_move(dx,dy, _sleep, _mvsize)
  } else {
    linepos++
    _yspacing = 0
    dx := scale * ( -xend + xonechar + xspacing + xstart)
    dy := scale * ( -yend + _yspacing + ystart)
    _mvsize := mvsize
    _sleep := sleep_skip
    mouse_move(dx,dy, _sleep, _mvsize)
  }
  return linepos
}

fn_darwGlyph(byref xend, byref yend, xstart, ystart, instructions) {
  ; we assume pen is already at starting position
  ; so, remove the first 2 symbols, which denote starting position
  ; after this, instructiosn are of form .xy.xy ...
  instructions := substr(instructions, 3)

  modulation = 0
  x := ""
  y := ""
  xcur := xstart
  ycur := ystart
  connection := ""

  Loop, Parse, instructions
  {
    if (modulation = 0) {
      connection = %A_LoopField%
    }
    if (modulation = 1) {
      x = %A_LoopField%
    }
    if (modulation = 2) {
      y = %A_LoopField%
    }
    modulation++

    if (modulation = 3) {
      fn_execInstruction(connection, xcur, ycur, x, y)
      modulation := 0
      xcur := x
      ycur := y
    }
  }
  mouse_clickUp()
  xend := xcur
  yend := ycur
  ;fn_hint("done")
}

fn_execInstruction(connection, xcursym, ycursym, xsym, ysym) {
  global scale
  global glyph_symToInt
  global sleep_draw
  global sleep_skip
  global mvsize
  if (connection = ".") {
    mouse_clickDown()
    _sleep := sleep_draw
    _mvsize := mvsize
  }
  if (connection = ":") {
    mouse_clickUp()
    _sleep := sleep_skip
    _mvsize := mvsize*3
  }
  xcur := glyph_symToInt[xcursym]
  ycur := glyph_symToInt[ycursym]
  x := glyph_symToInt[xsym]
  y := glyph_symToInt[ysym]
  dx := scale * (x - xcur)
  dy := scale * (y - ycur)
  mouse_move(dx,dy, _sleep, _mvsize)
}
