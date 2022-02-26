format PE console
entry start

include 'win32a.inc'

;=================== data ====================
section '.data' data readable writeable
;=============================================
 
WindowTitle             db 'Liberty Unleashed 0.1',0;
ProcID                  dd ?
ProcHandle              db ?


InitateLibraries        db "Loading Scripts",0dh,0ah,0


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
                mov dword[ProcHandle],eax                      ; Save the handle

                call LoadScripts                                      ; EAX != 0 : Continue with further steps

               ; Test
               ; push InitateLibraries
               ; call [printf]

               ; push LoadGame
               ; call [printf]


               ; call yield
        LoadScripts:
                invoke  _Load, ProcHandle
               ; Test
                push InitateLibraries
                call [printf]

                call yield

section '.idata' import data readable

        library msvcrt, 'MSVCRT.DLL', kernel32,'KERNEL32.DLL', user32,'USER32.DLL', GTA3,'GTA3.DLL'

        import GTA3, _Load,'LoadGame'

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

