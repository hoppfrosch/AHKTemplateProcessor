; Simple Template Engine for AutoHotkey
; 
; Replaces patterns within a string with values from associative array
;
; Created by hoppfrosch <https://github.com/hoppfrosch>
;
; License: WTFPL (http://www.wtfpl.net/txt/copying/)
;
; Example:
; #include <TemplateProcessor>
; stash := Object()
; stash["name"] := "hoppfrosch"
; stash["nickname"] := "froggie"
; tt := new Template()
; str := tt.process("Hi Mister <%= name %>, your nickname is <%= surname %>", stash)
;
; Credits: 
; * Class RegEx by Frankie Bagnardi/ R3gX (see http://www.autohotkey.com/board/topic/69236-regex-class/page-2#entry582249)
#include %A_LineFile%\..\..\DevHelper
#include DbgOut.ahk
#include %A_LineFile%\..\TP
#include TPStash.ahk

global gTempl := ""

class TemplateProcessor {
  _version := "0.4.0"
  _debug := 0
  
  __new(debug := 0) {
    this._debug := debug
    if (debug)
      this.logger := new dbgOut()

    this.logger.debug := this._debug
    this.logger.log("=[" A_ThisFunc "()]")
    Return this
    }

  process(templ, stash := "") {
    retStr := templ

    s := new TPStash(stash)
    ; this.logger.log(objPrint(s))
    
    this.logger.log(">[" A_ThisFunc "(templ=`"" templ "`", ...)]")
    pattern := "(" this.leftDelimiter "\s*((?:\w+)(?:\.(?:\w+))*)\s*" this.rightDelimiter ")" 
    this.logger.log("|[" A_ThisFunc "()] Pattern: " pattern)

    FoundPos := 1
    len := 0
    While (FoundPos := RegExMatch(templ, pattern, Match, FoundPos + len)) 
    {
      len := Match.len(0)
      if (s.HasKey(Match[2])) {
        this.logger.log("|[" A_ThisFunc "()] Replace Pattern: " Match[1] " with: " s.value(Match[2]) " (" s.value(Match[2]) ")")
        retStr := RegExReplace(retStr, Match[1], s.value(Match[2]))
      }
    }

    this.logger.log("<[" A_ThisFunc "(...)] -> " retStr)
    return retStr
  }

  ; ##################### Start of Properties ##############################################
  leftDelimiter[] {
  /* ---------------------------------------------------------------------------------------
  Property: leftDelimiter [get]
  */
    get {
      ret := "\<%="
      return  ret
    }
  }
  rightDelimiter[] {
  /* ---------------------------------------------------------------------------------------
  Property: rightDelimiter [get]
  */
    get {
      ret := "%\>"
      return  ret
    }
  }
}