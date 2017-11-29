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
; stash["surname"] := "froggie"
; tt := new Template()
; str := tt.process("Hi Mister <%= name %>, your surname is <%= surname %>", stash)
;
#include %A_LineFile%\..\..\DevHelper
#include DbgOut.ahk
#include %A_LineFile%\..\TP
#include TPStash.ahk
#include TPConfiguration.ahk

global gTempl := ""

class TemplateProcessor {
  _version := "1.0.0"
  _debug := 0
  
  __new(debug := 0) {
    this._debug := debug
    if (debug)
      this.logger := new dbgOut()

    this.logger.debug := this._debug
    this.config := new TPConfiguration()

    this.logger.log("=[" A_ThisFunc "()]")
    Return this
    }

  process(templ, stash := "") {
    retStr := templ

    s := new TPStash(stash)
    ; this.logger.log(objPrint(s))
    
    this.logger.log(">[" A_ThisFunc "(templ=`"" templ "`", ...)]")
    pattern := "(" this.config.leftDelimiter "\s*((?:\w+)(?:\.(?:\w+))*)\s*" this.config.rightDelimiter ")" 
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
}