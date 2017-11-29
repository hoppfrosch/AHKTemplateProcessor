#SingleInstance force

#include %A_ScriptDir%\..\lib
#include TemplateProcessor\TemplateProcessor.ahk
#include DevHelper\DbgOut.ahk
#include DevHelper\RunOrActivate.ahk

#Include %A_ScriptDir%\Yunit
#Include Yunit.ahk
#Include Window.ahk
#Include OutputDebug.ahk

;#Warn All
;#Warn LocalSameAsGlobal, Off
#SingleInstance force

RunOrActivate("d:\usr\bin\DebugView++.exe")
OutputDebug "DBGVIEWCLEAR"

ReferenceVersion := "1.0.0"
debug := 1

;Yunit.Use(YunitOutputDebug, YunitWindow).Test(VersionTestSuite, NestedKeyTestSuite, SimpleKeyTestSuite)
;Yunit.Use(YunitOutputDebug, YunitWindow).Test(VersionTestSuite)
Yunit.Use(YunitOutputDebug).Test(VersionTestSuite, SimpleKeyTestSuite, NestedKeyTestSuite)

class NestedKeyTestSuite {
	Begin() {
		Global debug
		this.name := "hoppfrosch"
		this.nickname := "froggie"

		this.baseStr := "Hello, Mister {1}! As your name is {2} you could be called {3}."

		this.stash := []
		this.stash["myself"] := []
		this.stash["myself"]["name"] := this.name
		this.stash["myself"]["nickname"] := this.nickname

		this.logger := new dbgOut()
		this.logger.mode := 0
	}

	NestedKey_Available() {
		Global Debug
		this.logger.log(">[" A_ThisFunc "]")

		tt := new TemplateProcessor(1)
		
		strReference := format(this.baseStr, this.name, this.name, this.nickname)
		this.logger.log("|[" A_ThisFunc "] Reference-String:   " strReference)
		template := format(this.baseStr,"<%= myself.name %>","<%= myself.name %>","<%= myself.nickname %>") 
		this.logger.log("|[" A_ThisFunc "] Template:           " template)
		
		strOut := tt.process(template, this.stash)
		this.logger.log("|[" A_ThisFunc "] Processed Template: " strOut)
		Yunit.assert( strOut == strReference)
		this.logger.log("<[" A_ThisFunc "]")
	}

	NestedKey_Missing() {
		; One requested key (myself.nicknameXXX) is missing - the result should be only partly replaced ....
		Global Debug
		this.logger.log(">[" A_ThisFunc "]")

		tt := new TemplateProcessor(1)
		
		strReference := format(this.baseStr, this.name, this.name, "<%= myself.nicknameXXX %>")
		this.logger.log("|[" A_ThisFunc "] Reference-String:   " strReference)
		
		template := format(this.baseStr,"<%= myself.name %>","<%= myself.name %>","<%= myself.nicknameXXX %>") 
		this.logger.log("|[" A_ThisFunc "] Template:           " template)
		
		strOut := tt.process(template, this.stash)
		this.logger.log("|[" A_ThisFunc "] Processed Template: " strOut)
		Yunit.assert( strOut == strReference)
		this.logger.log("<[" A_ThisFunc "]")
	}
	
	End() {
	}
}

class SimpleKeyTestSuite {
	Begin() {
		Global debug
		this.name := "hoppfrosch"
		this.nickname := "froggie"

		this.baseStr := "Hello, Mister {1}! As your name is {2} you could be called {3}."

		this.stash := []
		this.stash["name"] := this.name
		this.stash["nickname"] := this.nickname

		this.logger := new dbgOut()
	this.logger.mode := 0
		this.logger.debug := debug
	}

	SimpleKey_Available() {
		Global Debug
		this.logger.log(">[" A_ThisFunc "]")

		tt := new TemplateProcessor(1)
		
		strReference := format(this.baseStr, this.name, this.name, this.nickname)
		this.logger.log("|[" A_ThisFunc "] Reference-String:	" strReference)
		template := format(this.baseStr,"<%= name %>","<%= name %>","<%= nickname %>") 
		this.logger.log("|[" A_ThisFunc "] Template:	" template)
		
		strOut := tt.process(template, this.stash)
		this.logger.log("|[" A_ThisFunc "] Processed Template:	" strOut)
		Yunit.assert( strOut == strReference)
		this.logger.log("<[" A_ThisFunc "]")
	}

	SimpleKey_Missing() {
		; One requested key (nicknameXXX) is missing - the result should be only partly replaced ....
		Global Debug
		this.logger.log(">[" A_ThisFunc "]")

		tt := new TemplateProcessor(1)
		
		strReference := format(this.baseStr, this.name, this.name, "<%= nicknameXXX %>")
		this.logger.log("|[" A_ThisFunc "] Reference-String:	" strReference)
		
		template := format(this.baseStr,"<%= name %>","<%= name %>","<%= nicknameXXX %>") 
		this.logger.log("|[" A_ThisFunc "] Template:	" template)
		
		strOut := tt.process(template, this.stash)
		this.logger.log("|[" A_ThisFunc "] Processed Template:	" strOut)
		Yunit.assert( strOut == strReference)
		this.logger.log("<[" A_ThisFunc "]")
	}
	
	End() {
	}
}

class VersionTestSuite {
	Begin() {
		Global debug
		this.logger := new dbgOut()
		this.logger.mode := 0
		this.logger.debug := debug
	}
	
	Version() {
		this.logger.log(">[" A_ThisFunc "]")
		Global debug
		Global ReferenceVersion
		tt := new TemplateProcessor(debug)
		Yunit.assert(tt._version == ReferenceVersion)
		this.logger.log("|[" A_ThisFunc "] <" tt._version "> <-> Required <" ReferenceVersion ">")
		this.logger.log("<[" A_ThisFunc "]")
	}

	End() {
	}
}