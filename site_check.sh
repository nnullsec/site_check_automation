#! /bin/bash

# Author: nnullsec
# Version 1.0c


# MODIFY variable "input_prompt=0/1" TO TOGGLE THE SCRIPT PROMPT FOR INPUT, BEFORE STARTING THE BROWSER
# MODIFY varoable "sleep_time" TO CHANGE CHECK INTERVAL

# Feel free to run, modify, and share the code 

# TODO 1: make the program functional on debian based linux




##### CODE STARTS HERE #####

#add w/e browser u have intalled in your system

# service_arr=( $"safari" $"google chrome" $"firefox")


#just a humanly readable date formatting
timestamp(){    
    date +"%d-%m-%Y %T"
}


#producing newilines on call
newl(){
    echo -e "\n"
}


shitload_of_shit(){
    echo "=============================================================="
}


#kernel check
kernel(){
    if [ uname="Darwin" ];
    then
        return 10
    elif [ uname="Linux" ];
    then
        return 20
    fi
}


########unused function potentially usefull, grabing active processes and open a teab on an already open browser
########check for running processes
########
# proc_active(){
# init_size=${#service_arr[@]}
# run_bit=()

# for (( i=0; i<init_size;i++ )); do
#     run_bit[i]=0

#     serv=$(pgrep -xi "${service_arr[$i]}")

#     if [ $serv ]; then
#         run_bit[$i]=1
#     else
#         unset service_arr[i]
#     fi
# done
# }
########
########

#open the sites in a browser tab (called by input_prompt)
call_browser(){
    echo Browser is starting...
    newl
    if [ $1 -eq 20 ]; then
        for (( i=0; i<${#sites[@]}; i++ )); do
            /bin/bash -c "firefox --new-tab ${sites[$i]}" 2</dev/null & 
           sleep 2.0
        done
    elif [ $1 -eq 10 ]; then
        for (( i=0; i<${#sites[@]}; i++ )); do
            open "${sites[$i]}"
            sleep 0.5
        done
    else
        echo "Unexpected error"
        exit -1
    fi
}


#asking the user whether they want to open the urls in a browser
input_prompt(){
    if [ $1 -eq 1 ]; then
        echo -e "Open in browser by \033[31mpressing 'b'\033[0m or press any other button to exit"
        read -rsn1 input

        if [ "$input" == "b" ] || [ "$input" == "B" ];
        then
            kernel
            if [ "$?" -eq 20 ]; then
                call_browser 20 #linux
            else
                call_browser 10 #OSX
            fi
        else
            newl
            echo -e "********\n* Bye! *\n********"
            newl
            break
        fi
    elif [ $1 -eq 0 ]; then
        kernel
        if [ "$?" -eq 20 ]; then
            call_browser 20 #linux
        else
            call_browser 10 #OSX
        fi
    fi
}


sleepr(){
                # sec  min  h
    sleep_time=$((60 * 60 * 2))
    while [[ $sleep_time > 0 ]]; do

        hours=0
        mins=0
        secs=0

        if [[ $"sleep_time" > 3600 ]]; then
            hours=$((sleep_time/3600))
            x=$((sleep_time%3600))
            mins=$((x/60))
            secs=$((x%60))
        else
            x="$sleep_time"
            mins=$((x/60))
            secs=$((x%60))
        fi

        if [[ $hours > 0 ]]; then
            echo -ne "Next check in: \033[31m$hours \bh $mins \bm $secs \bs\033[0K\r\033[0m"
        elif [[ $hours=0 && $mins > 0 ]]; then
            echo -ne "Next check in: \033[31m$mins \bm $secs \bs\033[0K\r\033[0m"
        elif [[ $mins=0 && $hours=0 ]]; then
            echo -ne "Next check in: \033[31m$secs \bs\033[0K\r\033[0m"
        fi
        sleep 1
        ((sleep_time--))
    done
}

jobber(){
    #array of sites to check
    sites=( $"https://site1.com"
            $"https://site2.com"
            )

    situation=()

    shitload_of_shit
    echo -e " \t\t\033[31m$(date +"%A"), $(timestamp)\033[0m"
    shitload_of_shit
    newl

    for (( i=0; i<${#sites[@]}; i++ )); do
        echo "Hitting -> ${sites[$i]}"
        situation[$i]=$(curl -s --head --request GET "${sites[$i]}" | grep 200 | wc -l)
        
        if [ ${situation[$i]} == "1" ]; then
            echo -e "\033[35m[*] \033[0m-> ${sites[$i]} \033[35mIS UP and running\033[0m"
            newl
        else
            echo -e "\033[31m[!] \033[0m-> ${sites[$i]} \033[31mIS DOWN\033[0m"
            newl
        fi
    done
}


counter=1
while true; do

    printf "\033c"
    jobber
    input_prompt 0

    if [[ $counter -ge 1 ]]; then
        sleepr
    fi

    ((counter++))
done
