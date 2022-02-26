format PE console
entry start

include 'win32a.inc'

;=================== data ====================
section '.data' data readable writeable
;=============================================
 
WindowTitle             db 'GTA3',0;
ProcID                  dd ?
ProcHandle              db ?

LoadGame                db 'Restored a crash at load game', 0
InitateLibraries        db 'Loading Scripts', 0dh,0ah,0

WaitForProcess          db  "Waiting for Grand Theft Auto III...",0dh,0ah,0

section '.text' code readable executable

        start:
                push WaitForProcess
                call [printf]
        inputCall:
                invoke FindWindow, NULL, WindowTitle ; Find the window title
                test eax,eax                         ; Test whether a window with that title was found or not
                jnz StartHack                        ; Don't jump = The window was not found
                jmp inputCall
        yield:
           jmp yield

        StartHack:
               ; Test
                push InitateLibraries
                call [printf]

                push LoadGame
                call [printf]


                call yield

section '.idata' import data readable

        library msvcrt, 'MSVCRT.DLL', kernel32,'KERNEL32.DLL', user32,'USER32.DLL'

        import msvcrt, \
                       printf, 'printf', \
                       scanf, 'scanf', \
                       getchar, 'getchar',\
                       atoi, 'atoi'
          import       kernel32,\
                       OpenProcess,'OpenProcess'
          import       user32,\
                       FindWindow,'FindWindowA'
