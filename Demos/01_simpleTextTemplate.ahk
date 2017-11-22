#include %A_ScriptDir%\..\lib\TemplateProcessor\TemplateProcessor.ahk
#include %A_ScriptDir%\..\lib\DevHelper\DbgOut.ahk
#include %A_ScriptDir%\..\lib\DevHelper\RunOrActivate.ahk


RunOrActivate("d:\usr\bin\DebugView++.exe")

OutputDebug "DBGVIEWCLEAR"

name := "hoppfrosch"
nickname := "froggie"

baseStr := "Hello, Mister {1}! As your name is {2} you could be called {3}."

stash := []
stash["myself"] := []
stash["myself"]["name"] := name
stash["myself"]["nickname"] := nickname


logger := new dbgOut()
logger.mode := 0

logger.log(">[" A_ThisFunc "]")

tt := new TemplateProcessor(1)

strReference := format(baseStr, name, name, nickname)
logger.log("Reference-String:   " strReference)
template := format(baseStr,"<%= myself.name %>","<%= myself.name %>","<%= myself.nickname %>") 
logger.log("Template:           " template)
		
strOut := tt.process(template, stash)
logger.log("Processed Template: " strOut)
