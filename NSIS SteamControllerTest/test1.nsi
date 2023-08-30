; Script generated by the HM NIS Edit Script Wizard.

; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "SteamControllerTest"
!define PRODUCT_VERSION "0.0.18"
!define PRODUCT_PUBLISHER "Ryochan7"
!define PRODUCT_WEB_SITE "https://github.com/Ryochan7/DS4Windows/"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\SteamControllerTest.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

; MUI 1.67 compatible ------
!include "MUI.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"

; Welcome page
!insertmacro MUI_PAGE_WELCOME

!insertmacro MUI_PAGE_COMPONENTS

; Directory page
!insertmacro MUI_PAGE_DIRECTORY
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!define MUI_FINISHPAGE_RUN myrun
!define MUI_FINISHPAGE_RUN_FUNCTION PostAppRun
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_COMPONENTS
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "English"

!include "WinVer.nsh"

;!include "Sections.nsh"
!include "functions.nsh"

Var result
Var tempUninstallLoc

Var netDesktopInstalled
Var vigemBusInstalled
Var hidHideInstalled
Var fakerInputInstalled
Var requireRestart

Function PostAppRun
  Exec 'explorer.exe "$INSTDIR\SteamControllerTest.exe"'
FunctionEnd

InstType "Full"
InstType "Core"

; MUI end ------

Name "${PRODUCT_NAME}"
OutFile "SteamControllerTest_${PRODUCT_VERSION}_x64_installer.exe"
InstallDir "$PROGRAMFILES64\SteamControllerTest"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails show
ShowUnInstDetails show
;RequestExecutionLevel admin

Section "SteamControllerTest" SEC01
  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer
  SectionIn RO
  
  File SteamControllerTest\FakerInputDll.dll
  File SteamControllerTest\FakerInputWrapper.dll
  File SteamControllerTest\HandyControl.dll
  File SteamControllerTest\NLog.config
  File SteamControllerTest\NLog.dll
  File SteamControllerTest\Nefarius.ViGEm.Client.dll
  File SteamControllerTest\Newtonsoft.Json.dll
  File SteamControllerTest\SteamControllerTest.deps.json
  File SteamControllerTest\SteamControllerTest.dll
  File SteamControllerTest\SteamControllerTest.exe
  File SteamControllerTest\SteamControllerTest.runtimeconfig.json
  File SteamControllerTest\WpfScreenHelper.dll

  File /r SteamControllerTest\template_profiles
  
  CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk" "$INSTDIR\${PRODUCT_NAME}.exe"
  ;CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\Uninstall.lnk" "$INSTDIR\uninst.exe"
SectionEnd


Section "ViGEmBus" SEC03
  SectionIn 1
  
  ${If} $vigemBusInstalled == 1
    Return
  ${EndIf}
  
  SetOutPath "$tmpDS4WinInstallDir\installers"
  File installers\ViGEmBus_1.21.442_x64_x86_arm64.exe

  ExecWait "$tmpDS4WinInstallDir\installers\ViGEmBus_1.21.442_x64_x86_arm64.exe /norestart"
  IfErrors 0 +4
    MessageBox MB_OK "ViGEmBus install failed. Cannot continue"
    RMDir /r "$tmpDS4WinInstallDir"
    Abort "ViGEmBus install failed. Cannot continue"

  StrCpy $requireRestart 1
SectionEnd

Section /o "HidHide" SEC04
  SectionIn 1
  
  ${If} $hidHideInstalled == 1
    Return
  ${EndIf}
  
  SetOutPath "$tmpDS4WinInstallDir\installers"
  File installers\HidHide_1.2.98_x64.exe

  ExecWait "$tmpDS4WinInstallDir\installers\HidHide_1.2.98_x64.exe /norestart"
  IfErrors 0 +2
    DetailPrint "HidHide install failed. Continuing with install"

  StrCpy $requireRestart 1
SectionEnd

Section "FakerInput" SEC05
  SectionIn 1
  
  ${If} $fakerInputInstalled == 1
    Return
  ${EndIf}
  
  SetOutPath "$tmpDS4WinInstallDir\installers"
  File installers\FakerInput_0.1.0_x64.msi
  ExecWait "msiexec /i $tmpDS4WinInstallDir\installers\FakerInput_0.1.0_x64.msi /norestart"
  IfErrors 0 +2
    DetailPrint "FakerInput install failed. Continuing with install"

  StrCpy $requireRestart 1
SectionEnd

/*Section -AdditionalIcons
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\Uninstall.lnk" "$INSTDIR\uninst.exe"
SectionEnd
*/

Section -Post
  ${If} ${RunningX64}
    SetRegView 64
  ${Endif}

  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\${PRODUCT_NAME}.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\${PRODUCT_NAME}.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
  
  ${If} ${RunningX64}
    SetRegView lastused
  ${Endif}

  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\Uninstall.lnk" "$INSTDIR\uninst.exe"
  
  RMDir /r "$tmpDS4WinInstallDir"
  
  ${If} $requireRestart == 1
    # Prompt user if they want to reboot now
    MessageBox MB_YESNO|MB_ICONQUESTION "Reboot is required for drivers to work as intended. Do you wish to reboot the system now?" IDNO +2
    Reboot
  ${EndIf}

SectionEnd

Function .onInit
  ${IfNot} ${AtleastWin10}
    MessageBox MB_OK "Windows 10 or later required. Cannot continue"
    Quit
  ${EndIf}
  
  StrCpy $tmpDS4WinInstallDir "$TEMP\SCTestWinInstall"
  ;SectionSetFlags ${SEC02} 16
  SetOutPath "$tmpDS4WinInstallDir\apps"
  File apps\ConsoleApplication1.exe
  File apps\ConsoleApplication2.exe
  
  Call CheckNETVersion
  Pop $0
  StrCpy $result $0
  ${If} $result == -1
    MessageBox MB_OK "Could not execute helper executable. Please install Visual C++ Redistributable 2015-2022 or later. Aborting"
    Abort "Could not execute helper executable. Please install Visual C++ Redistributable 2015-2022 or later. Aborting"
  ${ElseIf} $result == 1
    MessageBox MB_OK ".NET install was not found. Please install .NET Desktop Runtime and try again. Redirecting to download page."
    Exec 'explorer.exe "https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-desktop-6.0.16-windows-x64-installer"'
    Abort ".NET install was not found. Cannot install"
  ${Endif}
  StrCpy $netDesktopInstalled 1
  StrCpy $result 0
  
  # Check for a current install
  ${If} ${RunningX64}
    SetRegView 64
  ${Endif}
  ReadRegStr $tempUninstallLoc HKLM "${PRODUCT_UNINST_KEY}" "UninstallString"
  IfErrors +2 0
    StrCpy $result 1

  ${If} $result == 1
    #MessageBox MB_OK "$tempUninstallLoc $INSTDIR"
    MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Existing installation found. Do you want to completely remove the old install of $(^Name)?" IDYES 0 IDNO +3
      ExecWait "$tempUninstallLoc /S"
      IfErrors 0 +3
       MessageBox MB_OK "Cannot resume. Quitting"
       Quit
      #MessageBox MB_OK "PAST END"
  ${EndIf}
  
  ${If} ${RunningX64}
    SetRegView lastused
  ${Endif}
  
  Call CheckViGEmBus
  Pop $0
  StrCpy $result $0
  ${If} $result == 0
    StrCpy $vigemBusInstalled 1
    SectionSetFlags ${SEC03} ${SF_RO}
  ${Else}
    StrCpy $vigemBusInstalled 0
    SectionSetFlags ${SEC03} ${SF_SELECTED}|${SF_RO}
  ${Endif}
  
  Call CheckHidHide
  Pop $0
  StrCpy $result $0
  ${If} $result == 0
    StrCpy $hidHideInstalled 1
    SectionSetFlags ${SEC04} ${SF_RO}
  ${Else}
    StrCpy $hidHideInstalled 0
    SectionSetFlags ${SEC04} 0
  ${Endif}
  
  Call CheckFakerInput
  Pop $0
  #DetailPrint $0
  StrCpy $result $0
  ${If} $result == 0
    StrCpy $fakerInputInstalled 1
    SectionSetFlags ${SEC05} ${SF_RO}
  ${Else}
    StrCpy $fakerInputInstalled 0
    SectionSetFlags ${SEC05} ${SF_SELECTED}|${SF_RO}
  ${Endif}

FunctionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) was successfully removed from your computer." /SD IDOK
FunctionEnd

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to completely remove $(^Name) and all of its components?" /SD IDYES IDYES +2
  Abort
FunctionEnd

Section Uninstall UninstSectionCore
  Delete "$INSTDIR\FakerInputDll.dll"
  Delete "$INSTDIR\FakerInputWrapper.dll"
  Delete "$INSTDIR\HandyControl.dll"
  Delete "$INSTDIR\NLog.config"
  Delete "$INSTDIR\NLog.dll"
  Delete "$INSTDIR\Nefarius.ViGEm.Client.dll"
  Delete "$INSTDIR\Newtonsoft.Json.dll"
  Delete "$INSTDIR\SteamControllerTest.deps.json"
  Delete "$INSTDIR\SteamControllerTest.dll"
  Delete "$INSTDIR\SteamControllerTest.exe"
  Delete "$INSTDIR\SteamControllerTest.runtimeconfig.json"
  Delete "$INSTDIR\WpfScreenHelper.dll"
  Delete "$INSTDIR\uninst.exe"
  
  RMDir /r "$INSTDIR\template_profiles"
  
  ;Delete "$SMPROGRAMS\${PRODUCT_NAME}\Uninstall.lnk"
  Delete "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk"

  RMDir "$SMPROGRAMS\${PRODUCT_NAME}"
  RMDir "$INSTDIR"

  ${If} ${RunningX64}
    SetRegView 64
  ${Endif}

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  
  ${If} ${RunningX64}
    SetRegView lastused
  ${Endif}
  ;SetAutoClose true
SectionEnd



Section /o "un.ViGEmBus" UninstSectionViGEmBus
  Call un.CallViGEmBusUninstall
  Pop $0
  StrCpy $result $0
  ${If} $result != 0
    MessageBox MB_OK "Could not finish ViGEmBus uninstaller. Continuing anyway."
  ${Endif}
SectionEnd

Section /o "un.HidHide" UninstSectionHidHide
  Call un.CallHidHideUninstall
  Pop $0
  StrCpy $result $0
  ${If} $result != 0
    MessageBox MB_OK "Could not finish HidHide uninstaller. Continuing anyway."
  ${Endif}
SectionEnd

Section /o "un.FakerInput" UninstSectionFakerInput
  Call un.CallFakerInputUninstall
  Pop $0
  StrCpy $result $0
  ${If} $result != 0
    MessageBox MB_OK "Could not finish FakerInput uninstaller. Continuing anyway."
  ${Endif}
SectionEnd

/*Section /o un.optional
SectionEnd
*/


!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC01} "Main SteamControllerTest files"
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC03} "Xbox 360 and DS4 controller emulation driver. Created by Nefarius"
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC04} "Filter driver for hiding HID devices system wide. Created by Nefarius"
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC05} "Virtual KB+M driver"
!insertmacro MUI_FUNCTION_DESCRIPTION_END

!insertmacro MUI_UNFUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${UninstSectionCore} "Uninstall core SteamControllerTest files"
  !insertmacro MUI_DESCRIPTION_TEXT ${UninstSectionViGEmBus} "Call ViGEmBus uninstaller"
  !insertmacro MUI_DESCRIPTION_TEXT ${UninstSectionHidHide} "Call HidHide uninstaller"
  !insertmacro MUI_DESCRIPTION_TEXT ${UninstSectionFakerInput} "Call FakerInput uninstaller"
!insertmacro MUI_UNFUNCTION_DESCRIPTION_END
