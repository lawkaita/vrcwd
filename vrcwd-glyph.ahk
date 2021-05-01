;[glyph model grid]
;    l c r
; h  - - -
; i  | . |
; t  - m -   <---- m: middle top of center unit square = ct
; x  | . |
; z  - - -
; j  | . |
; y  - - -
;    l c r
;
;[glyph representation]
; glyphs are represented as fn_drawGlyph instruction strings, which appear as
;
;    x y op x y op ...
;
; without spaces,
; where x and y are next location coordinates,
; and op is one of . or :,
; with . denoting pushing pen down against surface to draw
; and : rising it off the surface.
; first coordinate implicitly starts with pen down

glyph_symToInt := {l: 0, c: 1, r: 2,   h: 0, i: 1, t: 2, x: 3, z: 4, j: 5, y: 6}

fn_getGlyph(char) {
  global glyph_charToName
  ;fn_hint(format("'{}'", char))
  name := glyph_charToName[char]
  ;fn_hint(format("'{}'", name))
  if (name = "") {
    name := char
  }
  glyph = glyph_%name%

  try {
    if (%glyph% = "" ) {
      glyph = glyph_underscore
    }
  } catch {
    glyph = glyph_underscore
  }
  return %glyph%
}

glyph_a = ct.rx.cz.lx.rx
glyph_b = lh.lz.rx.lt
glyph_c = rt.lx.rz
glyph_d = rh.rz.lx.rt
glyph_e = lx:lx.rx.ct.lx.cz.rz
glyph_f = cj.ci.rt:lx.rx
glyph_g = lj.ry.rt.lx.rz
glyph_h = lh.lz.ct.rz
glyph_i = cz.ct:ci.ch
glyph_j = lz:lz.cj.ct:ci.ch
glyph_k = lh.lz.rt.cx.rz
glyph_l = ch.cz
glyph_m = lt.lz.ct.cz.rt.rz
glyph_n = lt.lz.ct.rt.rz
glyph_o = ct.rx.cz.lx.ct
glyph_p = ly.lt.rx.lz
glyph_q = ry.rt.lx.rz
glyph_r = lz.lt.lx.rt
glyph_s = rt.lx.rx.lz
glyph_t = ci.cz:lt.rt
glyph_u = lt.lz.cz.rt.rz
glyph_v = lt.cz.rt
glyph_w = lt.lz.ct.cz.rt
glyph_x = lt.rz:lz.rt
glyph_y = lt.cz.rt.ly
glyph_z = lt.rt.lz.rz

glyph_charToName := {" ": "space",  ",": "comma", "=": "eq", "<": "lt", ">": "gt", ".": "dot", "!": "exclamation", "?": "question", "(": "roundBracketOpen", ")": "roundBracketClose", "'": "quote" }

glyph_underscore = lz.rz
;glyph_space = lz:rz
glyph_space = rt
glyph_eq = lt.rt:lx.rx
glyph_lt = rt.lx.rx
glyph_comma = lz.cz.cj
glyph_dot = cz.cj
glyph_exclamation = cj.cz:cx.ch
glyph_question = lh.rh.ri.ct.cx:cz.cj
glyph_roundBracketOpen = rh.ci.cx.rz
glyph_roundBracketClose = lh.ci.cx.lz
glyph_quote = ci.ch
