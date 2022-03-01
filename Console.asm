;==============================================================================================
; GTA 3 Console (C) 2021 Robert
;==============================================================================================
format PE console
entry start

include 'win32a.inc'

;=================== data ====================
section '.data' data readable writeable
;=============================================
 
WindowTitle             db 'Liberty Unleashed 0.1',0;
ProcID                  dd ?
ProcHandle              db ?


LibrariesLoaded         db "[Memory Patches] Loaded Successfully!",10,0

WaitForProcess          db  "Waiting for Grand Theft Auto III...",0dh,0ah,0
    
section '.text' code readable executable

start:
        push WaitForProcess
        call [printf]
processfeaturepresent:
        invoke FindWindow, NULL, WindowTitle ; Find the window title
        test eax,eax                         ; Test whether a window with that title was found or not
        jnz LoadScripts                      ; Don't jump = The window was not found
        jmp processfeaturepresent
yield:
        jmp yield
LoadScripts:

        invoke  MemTest, [LoadGame], ProcHandle
        invoke printf, LibrariesLoaded
        call yield

section '.idata' import data readable

        library msvcrt, 'MSVCRT.DLL', kernel32,'KERNEL32.DLL', user32,'USER32.DLL', GTA3,'GTA3.DLL'

        import GTA3, LoadGame,'LoadGame', MemTest,'MemTest'

        import       msvcrt, printf, 'printf'
        import       kernel32, OpenProcess,'OpenProcess'
        import       user32, FindWindow,'FindWindowA'
