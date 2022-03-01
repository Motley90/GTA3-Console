format PE console
entry start

include 'win32a.inc'

;=================== data ====================
section '.data' data readable writeable
;=============================================
 
WindowTitle             db 'Liberty Unleashed 0.1',0;
ProcID                  dd ?
ProcHandle              db ?


InitateLibraries        db "Loading Scripts",10,0
TestMe        db "Loading Scripts",10,0

WaitForProcess          db  "Waiting for Grand Theft Auto III...",0dh,0ah,0
    
section '.text' code readable executable

        start:
                push WaitForProcess
                call [printf]
        processfeaturepresent:
                invoke FindWindow, NULL, WindowTitle ; Find the window title
                test eax,eax                         ; Test whether a window with that title was found or not
                jnz StartHack                        ; Don't jump = The window was not found
                jmp processfeaturepresent
        yield:
           jmp yield

        StartHack:



               cinvoke printf, InitateLibraries
               cinvoke printf, TestMe
        LoadScripts:
                invoke  MemTest, [LoadGame], ProcHandle
                ;invoke  LoadGame, ProcHandle

                call yield

section '.idata' import data readable

        library msvcrt, 'MSVCRT.DLL', kernel32,'KERNEL32.DLL', user32,'USER32.DLL', GTA3,'GTA3.DLL'

        import GTA3, LoadGame,'LoadGame', MemTest,'MemTest'

        import msvcrt, \
                       printf, 'printf', \
                       scanf, 'scanf', \
                       getchar, 'getchar',\
                       atoi, 'atoi'
          import       kernel32,\
                       OpenProcess,'OpenProcess',\
                       VirtualAllocEx, "VirtualAllocEx",\
                       WriteProcessMemory,'WriteProcessMemory'

          import       user32,\
                       FindWindow,'FindWindowA',\
                       GetWindowThreadProcessId,'GetWindowThreadProcessId'

section '.edata' export data readable

export 'MessUp.EXE', OutPut,'OutPut'
