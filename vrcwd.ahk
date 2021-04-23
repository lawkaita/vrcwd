#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.

;#InstallMouseHook
;#InstallKeyBDHook

SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Include vrcwd-mouse.ahk
#Include vrcwd-fn.ahk
#Include vrcwd-glyph.ahk

+#r::
  MsgBox , , , script will interrupt and reload, 0.5
  Reload

+#a:: fn_main()

fn_main(){
  text := fn_textbox()
  fn_parse(text)
}

;#IfWinActive ahk_exe VRChat.exe
