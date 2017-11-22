; ===========================================================================
; Run a program or switch to it if already running.
;    Target - Program to run. E.g. Calc.exe or C:\Progs\Bobo.exe
;    WinTitle - Optional title of the window to activate.  Programs like
;    MS Outlook might have multiple windows open (main window and email
;    windows).  This parm allows activating a specific window.
; ===========================================================================
;
; * http://www.autohotkey.com/forum/viewtopic.php?p=250565#250565
; * 20171122 - Modified by hoppfrosch to be V2.0 compatible
RunOrActivate(Target, WinTitle := "", Parameters := "")
{
   ; Get the filename without a path
   SplitPath Target, TargetNameOnly

   pid := ProcessExist(TargetNameOnly)
   If !pid 
      Run  Target Parameters, , , PID

   ; At least one app (Seapine TestTrack wouldn't always become the active
   ; window after using Run), so we always force a window activate.
   ; Activate by title if given, otherwise use PID.
   If (WinTitle <> "")
   {
      SetTitleMatchMode 2
      WinWait WinTitle, , 3
      WinActivate WinTitle
   }
   Else
   {
      WinWait ahk_pid PID, , 3
      WinActivate ahk_pid PID
   }
}