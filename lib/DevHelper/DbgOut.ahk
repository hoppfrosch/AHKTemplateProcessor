/*
Name: dbgOut - Prints given String via OutputDebug and indents string according to a given prefix
Version 0.1 (20161130)
Created: 20161130
Author: hoppfrosch
Description:
  Prints the given Debug-String via command OutputDebug. 
  The string is indented according to a given prefix in the Debug-String.
  This allows a better tracing of stack depth with deep function calls.

  Supported prefixes are currently:
  * ">" - This should be used when a funtion is entered. On each usage of this Prefix the indentation level is increased
    Example:  dbgOut(">[" A_ThisFunc "()]")
  * "<" - This should be used when a funtion is exited. On each usage of this Prefix the indentation level is decreased
*/
class dbgOut
{
	_version := "1.0.0"
	mode := 1 ; 0 = OutputDebug, 1 = StdOut, anythingElse = MsgBox
	static _indentLvl := 0
	shouldIndent := 1
	shouldLog := 1

	log(str) {
		if (!this.shouldLog)
			return
			
		out := this._indent(str)
		if (this.mode = 0) {
			OutputDebug(out)
		}
		else if (this.mode = 1) {
			FileAppend out "`n", "*"
		}
		else {
			MsgBox(out)
		}
		return
	}
  
	_indent(str) {
		out := str
		if (this.shouldIndent) {
			x1 := SubStr(str, 1, 1)
			if (x1 = "<") {
				this._indentLvl := this._indentLvl - 1
			} 
			else if (x1 = "=") {
				this._indentLvl := this._indentLvl + 1
			}
		
			i := 0
			indentStr := ""
			while (i < this._indentLvl) {
				indentStr := indentStr "__"
				i := i + 1
			}
			out := indentStr str

			if (x1 = ">") {
				this._indentLvl := this._indentLvl + 1
			}
			else if (x1 = "=") {
				this._indentLvl := this._indentLvl - 1
			}
		}
		return out
	}
	
	__New() {
		; Singleton class (see https://autohotkey.com/boards/viewtopic.php?p=175344#p175344)
		static init ;This is where the instance will be stored
		
		if init ;This will return true if the class has already been created
			return init ;And it will return this instance rather than creating a new one
		
		init := This ; this will overwrite the init var with this instance
	}
}

