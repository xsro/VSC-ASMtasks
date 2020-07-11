# !/bin/bash
# this is a script for use dosbox to run TASM/MASM tools
# set value
tool="$(dirname "$0")"
test="${tool}/work"
boxconf="$tool/dosbox/dosbox-0.74.conf"
mode='C'
print=0
# check whether installed dosbox
if type dosbox
    then 
        echo !Msg:  dosbox installed
    else
        echo !Msg:  You need install dosbox first
        echo !Msg:  *Maybe You can use:sudo apt install dosbox
        exit
    fi
# check the file path
if [ -z "$1" ]
then
    echo "./asmit.sh <file> [-d <toolsdir> -m <mode> -w <workdir>]"
    echo "./asmit.sh -h for help"
    exit
# display the help
elif [ "$1" = "-h" ]
then
    echo './asmit.sh <file> [-d <toolsdir> -m <mode> -w <workdir>]'
    echo '<file> file to be used '
    echo '<mode> choose mode the way display default is 1'
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
    echo '<tooldir> the tools folder with subdir masm,tasm'
    echo '<workdir> the folder of asm.bat'
# make sure the file readable and is a ASM file
elif [ -r "$1" ]
then
    file=$1
    # get the options
    echo 
    shift
    while getopts :m:d: opt
    do
        case "$opt" in
            m) mode=$OPTARG;;
            d) tool=$OPTARG
             if [ -d "${tool}" ]
             then
                echo Your directory concludes
                ls "${tool}"
             else
                echo invalid ${tool} not a readable directory
                exit 
                fi;;
            w) test=$OPTARG
             if [ -d "${test}" ];
             then
                echo Your directory concludes
                ls ${test}
             else
                echo invalid ${test} not a readable directory
                exit 
                fi;;  
            *) echo "unknown option: $opt";;
        esac
    done
        if [ "${mode}" = A ] || [ "${mode}" = B ];then
        print=1
        elif [ "${mode}" = C ] || [ "${mode}" = D ];then
        print=2
        fi
        if [ "$print" = 0 ];then
            boxconf="$tool/dosbox/bigbox.conf"
        fi
    # output infomation
    echo !Msg:  ASMtoolsfrom:$(pwd)
    echo !Msg:  ASMfilefrom:$file
    echo !Msg:  Mode:$mode Time:$(date)
    # check the file
    if [ $mode != 4 ] && [ $mode != 8 ] 
    then
        if [ ${file##*.} != ASM ] && [ ${file##*.} != asm ];then
        echo "the ${file##*.} file may not a assembly source code file"
        echo ---
            if ! read -t 10 -p "press Y to use it as an asmfile: " selection || [ ${selection} != Y ]
            then
            echo "No \"Y\" catched back to shell"
            exit
            fi
        fi
        # copy file to test
        ls "${test}" || mkdir "${test}" && rm "${test}/T.*"
        echo removed
        cp "$file" "${test}/T.ASM"
        # echo deleted temp files 
    fi
    # do the operation
        cd "${test}"
        dosbox -conf "${boxconf}" -noautoexec\
        -c "mount c \"$tool\"" -c "mount d \"$test\""\
        -c "d:"\
        -c "asm/m ${mode}"
            echo ASMfilefrom:${file}
        if [ "$print" = 1 ];then
            echo "!Msg：[ASM and link] info:"
            cat T.TXT
            if [ -r T.OUT ];then
                echo "!Msg:   [YOUR program] OUTPUT:"
                cat T.OUT
                echo 
            fi
        elif [ "$print" = 2 ];then
            tail -n +4 T.TXT
            if [ -r T.OUT ];then
                echo "!Msg:   [YOUR program] OUTPUT:"
                cat T.OUT
                echo 
            fi
        fi
else
    echo invalid path $1
fi
exit