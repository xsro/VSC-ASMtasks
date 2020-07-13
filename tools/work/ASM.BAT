@echo off
if "%1" == "" goto info
if "%1" == "/h" goto info1
if "%1" == "/hm" goto info2
if "%1" == "/m" goto Mode
:mainpart
:delpastfile
    if "%2" == "d" goto selectmode
    if not exist T.ASM pause
    rename T.ASM tempor.ary
    if exist T.* del T.*
    rename tempor.ary T.ASM
:selectmode
    if "%1" == "t" goto tasm
    if "%1" == "m" goto masm
    if "%1" == "0"  set path=%path%;c:\tasm;c:\masm
    if "%1" == "0"  copy c:\tasm\tdc2.td tdconfig.td
    goto end

echo invalid tool %2
:tasm
    set path=%path%;c:\tasm
    if "%2" == "rr" goto trr
    if "%2" == "ra" goto trr
    if "%2" == "d" goto td
    tasm/zi T.ASM
    if exist T.obj tlink/v/3 T
    if "%2" == "rd" goto td
    if exist T.exe T
    if "%2" == "r" goto end
    if "%2" == "rp" pause
    goto end
    :td
        copy c:\tasm\tdc2.td tdconfig.td
        td t
        goto end
    :trr
        tasm T.ASM>T.txt
        if exist T.obj tlink T>>T.txt
        if not exist T.exe goto end    
        if "%2" == "rr" goto tnext   
        T.exe
        echo [end]
        pause
        goto end
        :tnext
        T.exe T>T.out
        goto end
        
:masm
set path=%path%;c:\masm
    if "%2" == "rr" goto mrr
     if "%2" == "ra" goto mrr
    if "%2" == "d" goto debug
    masm T.ASM;
    if exist T.obj link T;
    if "%2" == "rd" goto debug
    if exist T.exe T
    if "%2" == "rp" pause
    goto end
    :debug
    if not exist T.EXE pause
        debug t.exe
        goto end
    :mrr
        masm T.ASM;>T.txt
        if exist T.obj link T;>>T.txt
        if not exist T.exe goto end 
        if "%2" == "rr" goto mnext
        T.exe
        echo [end]
        pause
        goto end
        :mnext
        T>T.out
        goto end
echo abnormal
goto end
:Mode
    if "%2" == "0" asm 0
    if "%2" == "1" asm t r 
    if "%2" == "2" asm t rp q
    if "%2" == "3" asm t rd q
    if "%2" == "4" asm t d 
    if "%2" == "5" asm m r 
    if "%2" == "6" asm m rp q
    if "%2" == "7" asm m rd 
    if "%2" == "8" asm m d 
    if "%2" == "A" asm t rr q
    if "%2" == "B" asm m rr q
    if "%2" == "C" asm t rr q
    if "%2" == "D" asm m rr q
    goto end

:info
    echo "asm -m <mode> [q];           asm/hm for help"
    echo "asm t/m r/rr/rp/rd/d, asm 0; asm/h for help"
    goto end
:info1
    echo "T:use TASM M:use MASM"
    echo "  r:run in dosbox"
    echo " rr:run redirected to file"
    echo " rp:run pause exit"
    echo " rd:tasm run and td"
    echo "asm T d:TASM turbo debugger"
    echo "asm M d:MASM debug"
    echo "asm 0  :do nothing"
    goto end
:info2
    echo "0 asm 0"
    echo "1 asm t r q"
    echo "2 asm t rp"
    echo "3 asm t rd"
    echo "4 asm t d q"
    echo "5 asm m r q"
    echo "6 asm m rp "
    echo "7 asm m rd"
    echo "8 asm m d q"
    echo "C asm t rr q"
    echo "D asm m rr q"
    goto end
:end
if "%1" == "0" dir
if "%3" == "q" exit


