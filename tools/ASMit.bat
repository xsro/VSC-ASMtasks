@echo off
:: GB 2312
if "%~f1" == "" goto info
:SetValues
set "cdo=%CD%"
set "file=%~f1"
set "mode=C"
set "tool=%~dp0"
set Print=0
set "boxconf=-conf %tool%\dosbox\dosbox-0.74.conf"
    set "test=%tool%work\"
    if not exist %test% mkdir %test%
    set "dosbox=%tool%dosbox\DOSBox.exe"
    set mcd=-noautoexec ^
    -c "mount c \"%tool%\"" -c "mount d \"%test%\"" ^
    -c "d:"
        ::change value according to input
        if "%2" neq "" set "mode=%2"
        if %3 neq "" set "tool=%~f3"
        if %4 neq "" set "test=%~f4"
    if "%mode%" == "A" set Print=1
    if "%mode%" == "B" set Print=1
    if "%mode%" == "C" set Print=2
    if "%mode%" == "D" set Print=2
    ::improve the display resolution of dosbox
    if "%Print%" == "0" set "boxconf=-conf %tool%\dosbox\bigbox.conf" 
::if "%Print%" == "2" goto preDo
:OutputInfo
    echo Time:%time%
    echo Mode:%mode% ASMtoolsfrom:%tool%
    echo ASMfilefrom:%file%
:preDo
cd "%test%"
    :ModeSelect
        if %mode%==4 goto core
        if %mode%==8 goto core
    if "%~x1"==".ASM" goto NEXT
    if "%~x1"==".asm" goto NEXT
    echo %~x1 is not a supported assembly file
    goto end
    :NEXT
        if not exist "%file%" echo no such file && goto end
        if exist T.ASM del T.ASM
        copy "%file%" T.ASM>nul
        :core
        start/min/wait "" "%dosbox%" %mcd% %boxconf% -c "asm/m %mode%"
            if "%Print%" == "1" goto print1
            if "%Print%" == "2" goto print2
            goto end
            :print1
            echo [ASM information] OUTPUT:
            type T.txt
            if not exist T.OUT goto end
            echo [YOUR program] OUTPUT:
            type T.out
            goto end
            :print2
            FOR /F "eol=; skip=3 tokens=* delims=, " %%i in (T.txt) do echo %%i
            if not exist T.OUT goto end
            echo [YOUR program] OUTPUT:
            FOR /F "eol=; tokens=* delims=, " %%i in (T.out) do echo   %%i
            goto end
:info
    echo "asmit.bat <file> [<mode>]<toolsdir> <workdir>]"
    echo "<file> file to be used "
    echo "<display> s"
    echo "<mode> choose mode the way display default is 1"
    echo " 0 copy the files open dosbox add path"
    echo " 1 tasm run output in dosbox"
    echo " 2 tasm run pause exit"
    echo " 3 tasm run and td"
    echo " 4 open turbo debugger at test folder"
    echo " 5 masm run output in dosbox"
    echo " 6 masm run pause exit"
    echo " 7 masm and debug"
    echo " 8 open masm debug at test folder"
    echo " A tasm run output in shell"
    echo " B masm run ouput in shell"
    echo " C simplipfy output open turbo debugger at test folder"
    echo " D simplipfy output open masm debug at test folder"
    echo "<toolsdir> the tools folder with subdir masm,tasm,test"
:end
cd %cdo%