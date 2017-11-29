; Helper Class to handle the configuration for Simple Template Engine for AutoHotkey
;
; Created by hoppfrosch <https://github.com/hoppfrosch>
;
; License: WTFPL (http://www.wtfpl.net/txt/copying/)

#include %A_LineFile%\..\..\..\DevHelper
#include DbgOut.ahk

class TPConfiguration {
  _version := "0.1.0"
  _debug := 0
  _data := Object()

  _leftDelimiter := "\<%="
  _rightDelimter := "%\>"
  
  __new(debug := 0) {
    this._debug := debug
	
    this.logger := new dbgOut()
	  this.logger.mode := 0

    this.logger.log("=[" A_ThisFunc "()]")

    Return this
  }
  
  ; ##################### Start of Properties ##############################################
  leftDelimiter[] {
  /* ---------------------------------------------------------------------------------------
  Property: leftDelimiter [get]
  */
    get {
      return  this._leftDelimiter
    }
  }
  rightDelimiter[] {
  /* ---------------------------------------------------------------------------------------
  Property: rightDelimiter [get]
  */
    get {
      return  this._rightDelimter
    }
  }
}