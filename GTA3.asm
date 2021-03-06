
format PE GUI 4.0 DLL
entry DllEntryPoint

include 'win32a.inc'

;=================== data ====================
section '.data' data readable writeable
;=============================================

LoadGameAddress    dd 0x4A701F
LoadGameBytes      db 0x00, 0x53, 0x8B, 0x5C, 0x24, 0x08, 0xE8, 0xB6, 0xCF, 0xFF, 0xFF, 0x31, 0xC0, 0x83, 0xC3, 0x08, 0x31, 0xC9, 0x8B, 0x13, 0x40, 0x89, 0x91, 0xE0, 0xD5, 0x6E, 0x00, 0x8D, 0x53, 0x04, 0x8B, 0x12, 0x89, 0x91, 0xE4, 0xD5, 0x6E, 0x00, 0x8D, 0x53, 0x08, 0x8B, 0x12, 0x89, 0x91, 0xE8, 0xD5, 0x6E, 0x00, 0x8D, 0x53, 0x0C, 0xD9, 0x02, 0xD9, 0x99, 0xEC, 0xD5, 0x6E, 0x00, 0x8D, 0x53, 0x0C, 0xD9, 0x42, 0x04, 0xD9, 0x99, 0xF0, 0xD5, 0x6E, 0x00, 0x8D, 0x53, 0x14, 0xD9, 0x02, 0xD9, 0x99, 0xF4, 0xD5, 0x6E, 0x00, 0x8D, 0x53, 0x14, 0xD9, 0x42, 0x04, 0xD9, 0x99, 0xF8, 0xD5, 0x6E, 0x00, 0x8D, 0x53, 0x14, 0xD9, 0x42, 0x08, 0xD9, 0x99, 0xFC, 0xD5, 0x6E, 0x00, 0x8D, 0x53, 0x20, 0x66, 0x8B, 0x12, 0x66, 0x89, 0x91, 0x00, 0xD6, 0x6E, 0x00, 0x8A, 0x53, 0x22, 0x88, 0x91, 0x02, 0xD6, 0x6E, 0x00, 0x8A, 0x53, 0x23, 0x88, 0x91, 0x03, 0xD6, 0x6E, 0x00, 0x8D, 0x53, 0x24, 0xD9, 0x02, 0xD9, 0x99, 0x04, 0xD6, 0x6E, 0x00, 0x8D, 0x53, 0x28, 0x66, 0x8B, 0x12, 0x66, 0x89, 0x91, 0x08, 0xD6, 0x6E, 0x00, 0x8D, 0x53, 0x2A, 0x66, 0x8B, 0x12, 0x66, 0x89, 0x91, 0x0A, 0xD6, 0x6E, 0x00, 0x8D, 0x53, 0x2C, 0x66, 0x8B, 0x12, 0x83, 0xC3, 0x30, 0x66, 0x89, 0x91, 0x0C, 0xD6, 0x6E, 0x00, 0x83, 0xC1, 0x30, 0x66, 0x83, 0xF8, 0x20, 0x0F, 0x82, 0x46, 0xFF, 0xFF, 0xFF, 0x5B, 0xC3

LoadGameSize       =  $ - LoadGameBytes
LoadGameResult     dd ?
;=============================================
UnlimitedSprintAddress    dd 0x4F138C
UnlimitedSprintBytes      db 0x90, 0x90, 0x90, 0x90, 0x90, 0x90

UnlimitedSprintSize       =  $ - UnlimitedSprintBytes
UnlimitedSprintResult     dd ?
;=============================================
WantedActionsAddressOne    dd 0x4ADAA3
WantedActionsBytesOne      db 0xEB, 0x11
WantedActionsSizeOne       =  $ - WantedActionsBytesOne
WantedActionsResultOne     dd ?
;=============================================
WantedActionsAddressTwo    dd 0x4ADA86
WantedActionsBytesTwo      db 0xEB, 0x18
WantedActionsSizeTwo       =  $ - WantedActionsBytesTwo
WantedActionsResultTwo     dd ?
;=============================================
WantedActionsAddressThree    dd 0x4ADA68
WantedActionsBytesThree      db 0xEB, 0x17
WantedActionsSizeThree       =  $ - WantedActionsBytesThree
WantedActionsResultThree     dd ?

;=============================================
WantedActionsAddressFour    dd 0x4ADA4A
WantedActionsBytesFour      db 0xEB, 0x17
WantedActionsSizeFour       =  $ - WantedActionsBytesFour
WantedActionsResultFour     dd ?
;=============================================
WantedActionsAddressFive    dd 0x4ADA29
WantedActionsBytesFive      db 0xEB, 0x1A
WantedActionsSizeFive       =  $ - WantedActionsBytesFive
WantedActionsResultFive     dd ?
;=============================================
WantedActionsAddressSix    dd 0x4ADA0A
WantedActionsBytesSix      db 0xEB, 0x1A
WantedActionsSizeSix       =  $ - WantedActionsBytesSix
WantedActionsResultSix     dd ?
;=============================================
ProcID                  dd ?
;=============================================

section '.text' code readable executable

proc DllEntryPoint hinstDLL,fdwReason,lpvReserved
        mov     eax,TRUE
        ret
endp
; MemTest, the function the patch we wish to use, And the handle
proc MemoryPatch func, ProcHandle
     main:
       invoke GetWindowThreadProcessId, eax, ProcID   ; Get the ProcessID via the window handle
       invoke OpenProcess, 0x1F0FFF, FALSE, [ProcID]  ; Open the process using PROCESS_ALL_ACCESS (0x1F0FFF) and get a handle
       mov dword[ProcHandle],eax                      ; move the handle to eax
       stdcall [func]                                 ; Call the function that was specified
       jmp main                                       ; Something fucked up so its trying again. Should probably remove.

      LoadGame:
       invoke WriteProcessMemory, dword[ProcHandle], dword[LoadGameAddress], LoadGameBytes, LoadGameSize, LoadGameResult
       cmp [LoadGameResult],LoadGameSize              ; Compare the number of patched bytes with the length of our new bytes
       ret

      UnlimitedSprint:
       invoke WriteProcessMemory, dword[ProcHandle], dword[UnlimitedSprintAddress], UnlimitedSprintBytes, UnlimitedSprintSize, UnlimitedSprintResult
       cmp [UnlimitedSprintResult],UnlimitedSprintSize              ; Compare the number of patched bytes with the length of our new bytes
       ret

      DisablePoliceActions:
       invoke WriteProcessMemory, dword[ProcHandle], dword[WantedActionsAddressOne], WantedActionsBytesOne, WantedActionsSizeOne, WantedActionsResultOne
       cmp [WantedActionsResultOne],WantedActionsSizeOne              ; Compare the number of patched bytes with the length of our new bytes

       invoke WriteProcessMemory, dword[ProcHandle], dword[WantedActionsAddressTwo], WantedActionsBytesTwo, WantedActionsSizeTwo, WantedActionsResultTwo
       cmp [WantedActionsResultTwo],WantedActionsSizeTwo              ; Compare the number of patched bytes with the length of our new bytes

       invoke WriteProcessMemory, dword[ProcHandle], dword[WantedActionsAddressThree], WantedActionsBytesThree, WantedActionsSizeThree, WantedActionsResultThree
       cmp [WantedActionsResultThree],WantedActionsSizeThree              ; Compare the number of patched bytes with the length of our new bytes

       invoke WriteProcessMemory, dword[ProcHandle], dword[WantedActionsAddressFour], WantedActionsBytesFour, WantedActionsSizeFour, WantedActionsResultFour
       cmp [WantedActionsResultFour],WantedActionsSizeFour              ; Compare the number of patched bytes with the length of our new bytes

       invoke WriteProcessMemory, dword[ProcHandle], dword[WantedActionsAddressFive], WantedActionsBytesFive, WantedActionsSizeFive, WantedActionsResultFive
       cmp [WantedActionsResultFive],WantedActionsSizeFive              ; Compare the number of patched bytes with the length of our new bytes

       invoke WriteProcessMemory, dword[ProcHandle], dword[WantedActionsAddressSix], WantedActionsBytesSix, WantedActionsSizeSix, WantedActionsResultSix
       cmp [WantedActionsResultSix],WantedActionsSizeSix              ; Compare the number of patched bytes with the length of our new bytes
       ret
endp

section '.idata' import data readable writeable

        library kernel32,'KERNEL32.DLL', user32,'USER32.DLL'

          import       kernel32,\
                       OpenProcess,'OpenProcess',\
                       VirtualAllocEx, "VirtualAllocEx",\
                       WriteProcessMemory,'WriteProcessMemory'
          import       user32,\
                       FindWindow,'FindWindowA',\
                       GetWindowThreadProcessId,'GetWindowThreadProcessId',\
                       MessageBox,'MessageBoxA'

section '.edata' export data readable

export 'GTA3.DLL', LoadGame,'LoadGame', MemoryPatch,'MemoryPatch', UnlimitedSprint, 'UnlimitedSprint', DisablePoliceActions, 'DisablePoliceActions'

section '.reloc' fixups data readable discardable

  if $=$$
    dd 0,8              ; if there are no fixups, generate dummy entry
  end if
