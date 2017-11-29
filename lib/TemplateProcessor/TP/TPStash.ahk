; Helper Class to handle the stash for Simple Template Engine for AutoHotkey
; 
; Accessing the data stash
;
; Created by hoppfrosch <https://github.com/hoppfrosch>
;
; License: WTFPL (http://www.wtfpl.net/txt/copying/)

#include %A_LineFile%\..\..\..\DevHelper
#include DbgOut.ahk

class TPStash {
  _version := "0.2.0"
  _debug := 0
  _data := Object()
  
  __new(data, debug := 0) {
    this._debug := debug
	
  this.logger := new dbgOut()
	this.logger.mode := 0

    this.logger.log(">[" A_ThisFunc "()]")
    this._data := data
    ; this.logger.log("|[" A_ThisFunc "()] data:" objPrint(data))
    this.logger.log("<[" A_ThisFunc "()]")
    Return this
  }
  
  ; Gets the data for the given key
  ; If there's no data, the key (including delimiters) is returned
  value(key) {
	if this.isScalar(key) {
		keys:=StrSplit(key, ".")
		val:=this._data[keys*]
		lastKey:=keys[len:=keys.length()]
		keys.delete(len)
		if this._data[keys*].hasKey(lastKey) {
			retval := {val:val, haskey:1, valIsObject:IsObject(val)}
			retval := val
		}
		else {
			retVal := {val:"", haskey:0, valIsObject:""}
			retval := key
		}
	}
	this.logger.log("=[" A_ThisFunc "(key=`"" key "`")] --> " retVal) 
	return retVal
  }

  ; Checks whether data for the given key exists on the stash
  isScalar(key) {
    ret := this.hasKey(key)
  	return ret
  }

  ; Checks whether the given key exists on the stash 
  hasKey(key) {
	keys:=StrSplit(key, ".")
	lastKey:=keys[len:=keys.length()]
	keys.delete(len)
	if this._data[keys*].hasKey(lastKey) {
		return 1
	}
  	return
  }

  ; ##################### Start of Properties ##############################################
  data[] {
  /* ---------------------------------------------------------------------------------------
  Property: data [get]
  */
    get {
      ret := this._data
      return  ret
    }
  }
}