!include "x64.nsh"

Var tmpDS4WinInstallDir

Function CheckNetVersion
  #MessageBox MB_OK "$tmpDS4WinInstallDir"
  nsExec::Exec "$tmpDS4WinInstallDir\apps\ConsoleApplication2.exe"
  Pop $0
  #MessageBox MB_OK "$0"
  #Pop $ExitCode
  #IfErrors 0 +3
  ${If} $0 != 0
    ${If} $0 < 0
      Push -1 ; Set error code on stack
      Return
    ${Else}
      Push 1 ; Set error code on stack
      Return
    ${EndIf}
  ${EndIf}

  Push 0 ; Set 0 code and exit
FunctionEnd

Function CheckFakerInput
  nsExec::Exec "$tmpDS4WinInstallDir\apps\ConsoleApplication1.exe find FakerInput"
  Pop $0
  ${If} $0 != 0
    ${If} $0 < 0
      Push -1 ; Set error code on stack
      Return
    ${Else}
      Push 1 ; Set error code on stack
      Return
    ${EndIf}
  ${EndIf}

  Push 0 ; Set 0 code and exit
FunctionEnd

Function CheckViGEmBus
  nsExec::Exec "$tmpDS4WinInstallDir\apps\ConsoleApplication1.exe find ViGEmBus"
  Pop $0
  #MessageBox MB_OK "$0"
  ${If} $0 != 0
    ${If} $0 < 0
      Push -1 ; Set error code on stack
      Return
    ${Else}
      Push 1 ; Set error code on stack
      Return
    ${EndIf}
  ${EndIf}

  Push 0 ; Set 0 code and exit
FunctionEnd

Function CheckHidHide
  nsExec::Exec "$tmpDS4WinInstallDir\apps\ConsoleApplication1.exe find HidHide"
  Pop $0
  ${If} $0 != 0
    ${If} $0 < 0
      Push -1 ; Set error code on stack
      Return
    ${Else}
      Push 1 ; Set error code on stack
      Return
    ${EndIf}
  ${EndIf}

  Push 0 ; Set 0 code and exit
FunctionEnd


Function un.CallViGEmBusUninstall
  ${If} ${RunningX64}
    SetRegView 64
  ${EndIf}

  ReadRegStr $0 HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{9C581C76-2D68-40F8-AA6F-94D3C5215C05}" "UninstallString"
  DetailPrint "NSIS is installed at: $0"
  ;MessageBox MB_OK $0
  ${If} ${RunningX64}
    SetRegView lastused
  ${Endif}
  
  ExecWait $0
  IfErrors 0 +3
    Push 1 ; Set error code on stack
    Return

  Push 0 ; Set 0 code and exit
FunctionEnd

Function un.CallHidHideUninstall
  Return

  ${If} ${RunningX64}
    SetRegView 64
  ${EndIf}

  ReadRegStr $0 HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{9C581C76-2D68-40F8-AA6F-94D3C5215C05}" "UninstallString"
  ;MessageBox MB_OK $0
  
  ${If} ${RunningX64}
    SetRegView lastused
  ${Endif}
  
  ExecWait $0
  IfErrors 0 +3
    Push 1 ; Set error code on stack
    Return

  Push 0 ; Set 0 code and exit
FunctionEnd

Function un.CallFakerInputUninstall
  ${If} ${RunningX64}
    SetRegView 64
  ${EndIf}

  ReadRegStr $0 HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{BF63C434-BF91-4666-B817-AD7B5C34AE91}" "UninstallString"
  
  ${If} ${RunningX64}
    SetRegView lastused
  ${Endif}

  ;MessageBox MB_OK $0
  ExecWait $0
  IfErrors 0 +3
    Push 1 ; Set error code on stack
    Return

  Push 0 ; Set 0 code and exit
FunctionEnd