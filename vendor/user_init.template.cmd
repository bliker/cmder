@echo off

:: This file was autogenerated by Cmder init.bat
::
:: It is yours to edit and will not be touched again by Cmder.
::
:: If you wish to recreate this file simply rename it and Cmder will re-create it the next time it is run
:: or run the followin command from a Cmder shell:
::
:: powershell -f %cmder_root%\vendor\bin\create-cmdercfg.ps1 -shell cmd [-outfile "[filename]"]
::

if "%CMDER_CLINK%" == "1" (
  goto :INJECT_CLINK
) else if "%CMDER_CLINK%" == "2" (
  goto :CLINK_FINISH
)

goto :SKIP_CLINK

:INJECT_CLINK
  %print_verbose% "Injecting Clink!"

  :: Check if Clink is not present
  if not exist "%CMDER_ROOT%\vendor\clink\clink_%clink_architecture%.exe" (
      goto :SKIP_CLINK
  )

  :: Run Clink
  if not exist "%CMDER_CONFIG_DIR%\settings" if not exist "%CMDER_CONFIG_DIR%\clink_settings" (
      echo Generating Clink initial settings in "%CMDER_CONFIG_DIR%\clink_settings"
      copy "%CMDER_ROOT%\vendor\clink_settings.default" "%CMDER_CONFIG_DIR%\clink_settings"
      echo Additional *.lua files in "%CMDER_CONFIG_DIR%" are loaded on startup.
  )

  if not exist "%CMDER_CONFIG_DIR%\cmder_prompt_config.lua" (
      echo Creating Cmder prompt config file: "%CMDER_CONFIG_DIR%\cmder_prompt_config.lua"
      copy "%CMDER_ROOT%\vendor\cmder_prompt_config.lua.default" "%CMDER_CONFIG_DIR%\cmder_prompt_config.lua"
  )

  "%CMDER_ROOT%\vendor\clink\clink_%clink_architecture%.exe" inject --quiet --profile "%CMDER_CONFIG_DIR%" --scripts "%CMDER_ROOT%\vendor"

  if errorlevel 1 (
      %print_error% "Clink initialization has failed with error code: %errorlevel%"
      goto :CLINK_FINISH
  )

  set CMDER_CLINK=2
  goto :CLINK_FINISH

:SKIP_CLINK
  %print_warning% "Skipping Clink Injection!"

  for /f "tokens=2 delims=:." %%x in ('chcp') do set cp=%%x
  chcp 65001>nul

  :: Revert back to plain cmd.exe prompt without clink
  prompt `$E[1;32;49m`$P`$S`$_`$E[1;30;49mλ`$S`$E[0m

  chcp %cp%>nul

:CLINK_FINISH
  if not defined GIT_INSTALL_ROOT set "GIT_INSTALL_ROOT=$env:GIT_INSTALL_ROOT"
  if not defined SVN_SSH          set "SVN_SSH=$env:SVN_SSH"
  if not defined git_locale       set git_locale=$env:git_locale
  if not defined LANG             set LANG=$env:lang
  if not defined user_aliases     set "user_aliases=$env:user_aliases"
  if not defined aliases          set "aliases=%user_aliases%"
  if not defined HOME             set "HOME=%USERPROFILE%"
  
  set PLINK_PROTOCOL=$env:PLINK_PROTOCOL
  
  set "path=%GIT_INSTALL_ROOT%\cmd;%path%"
  
  set path_position=append
  if %nix_tools% equ 1 (
      set "path_position=append"
  ) else (
      set "path_position="
  )
  
  if %nix_tools% geq 1 (
      if exist "%GIT_INSTALL_ROOT%\mingw32" (
          if "%path_position%" == "append" (
            set "path=%path%;%GIT_INSTALL_ROOT%\mingw32\bin"
          ) else (
            set "path=%GIT_INSTALL_ROOT%\mingw32\bin;%path%"
          )
      ) else if exist "%GIT_INSTALL_ROOT%\mingw64" (
          if "%path_position%" == "append" (
            set "path=%path%;%GIT_INSTALL_ROOT%\mingw64\bin"
          ) else (
            set "path=%GIT_INSTALL_ROOT%\mingw64\bin;%path%"
          )
      )
      if exist "%GIT_INSTALL_ROOT%\usr\bin" (
          if "%path_position%" == "append" (
            set "path=%path%;%GIT_INSTALL_ROOT%\usr\bin"
          ) else (
            set "path=%GIT_INSTALL_ROOT%\usr\bin;%path%"
          )
      )
  )
  
  set "path=%CMDER_ROOT%\vendor\bin;%path%"

:USER_CONFIG_START
  if %max_depth% gtr 1 (
    %lib_path% enhance_path_recursive "%CMDER_ROOT%\bin" 0 %max_depth%
  ) else (
    set "path=%CMDER_ROOT%\bin;%path%"
  )
  
  setlocal enabledelayedexpansion
  if defined CMDER_USER_BIN (
    if %max_depth% gtr 1 (
      %lib_path% enhance_path_recursive "%CMDER_USER_BIN%" 0 %max_depth%
    ) else (
      set "path=%CMDER_USER_ROOT%\bin;%path%"
    )
  )
  endlocal && set "path=%path%"
   
  set "path=%path%;%CMDER_ROOT%"
  
  call "%user_aliases%"
  
  %lib_profile% run_profile_d "%CMDER_ROOT%\config\profile.d"
  if defined CMDER_USER_CONFIG (
    %lib_profile% run_profile_d "%CMDER_USER_CONFIG%\profile.d"
  )
  
  call "%CMDER_ROOT%\config\user_profile.cmd"
  if defined CMDER_USER_CONFIG (
    if exist "%CMDER_USER_CONFIG%\user_profile.cmd" (
      call "%CMDER_USER_CONFIG%\user_profile.cmd"
    )
  )
  
  set "path=%path:;;=;%

:CMDER_CONFIGURED
  if not defined CMDER_CONFIGURED set CMDER_CONFIGURED=1
  
  set CMDER_INIT_END=%time%
  
  if "%time_init%" == "1" if "%CMDER_INIT_END%" neq "" if "%CMDER_INIT_START%" neq "" (
    call "%cmder_root%\vendor\bin\timer.cmd" "%CMDER_INIT_START%" "%CMDER_INIT_END%"
  )

:CLEANUP
  set architecture_bits=
  set CMDER_ALIASES=
  set CMDER_INIT_END=
  set CMDER_INIT_START=
  set CMDER_USER_FLAGS=
  set debug_output=
  set fast_init=
  set max_depth=
  set nix_tools=
  set path_position=
  set print_debug=
  set print_error=
  set print_verbose=
  set print_warning=
  set time_init=
  set verbose_output=
  set user_aliases=

exit /b


