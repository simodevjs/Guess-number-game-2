#!/bin/bash
#hello this game is for guessing numbers
#Include randomNumber function to generate unique random number of specified length
source ./lib/randomNumber.sh

#Kepp track of time
start_time=$(date +%s)

#Clear playlog
$(: > playlog)

BRed='\033[1;31m'         # Red text
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
Reset='\033[0m'

message="${BGreen}Bulls${Reset} and ${BYellow}Cows"

#Generating Random number

level=4
number=($(randomNumber $level)) #set to array 

#-----------------------------------------------------------------------

#Checking and comparing
bulls=0
count=0
until (($bulls >= $level)); do 

  tput clear
  tput cup 4 10 #put "cursor" at given location
  echo -e "$message${Reset}" #Echo the combined arguments 
  echo -e "\n"
#Uncomment to display the number
  #echo ${number[*]}
  cat -n playlog #Can also use: nl  playlog

  read -p "Enter your guess " input
  
  guess=($(echo "$input" | grep -o .)) #Outer () to make array
  check=($(echo "${guess[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' ')) #Remove duplicates and sets new array

  bulls=0
  cows=0

  if [[ $input == "quit" || $input == "Quit" || $input == "q" ]]; then
    exit
  elif [[ $input == "answer" || $input == "Answer" || $input == "a" ]]; then
    break
  fi
  
  if (( ${#guess[@]} != $level )); then
    echo -e "$input:\t${BRed}Make sure to use $level numbers${Reset}" >> playlog
  elif (( ${#guess[@]} != ${#check[@]} )); then
    echo -e "$input:\t${BRed}Make sure to not duplicate numbers${Reset}" >> playlog
  else
    
    all_matches=0 #Find all matches first
    for i in ${guess[@]}; do 
      inArray $i ${number[@]}
      match=$?
        
      if (( $match == 0)); then #If number is in both arrays
        let all_matches+=1
      fi
    done 
      
    #Find number of bulls by looking at numbers in the same index 
    for x in ${!guess[@]}; do
      if (( ${guess[$x]} == ${number[$x]} )); then
        let bulls+=1
      fi
    done 
      
    cows=$(( all_matches - bulls )) #Find cows by subtracting
    
    if (($bulls == 0 && $cows == 0)); then
      echo -e "$input:\t${BRed}No matches${Reset}" >> playlog
    elif (($bulls == 4));then
      echo -e "$input:\t${BGreen}$bulls Bulls${Reset}" >> playlog
    else
      echo -e "$input:\t${BGreen}$bulls Bulls${Reset} and ${BYellow}$cows Cows${Reset}" >> playlog
    fi

    ((count++)) 

  fi
  
done #Ends untill loop - Game Won

#Keep track of end time
end_time=$(date +%s)
total_time=$(( end_time - start_time))

#Final display
tput clear
tput cup 4 10 #put "cursor" at given location
echo -e "$message${Reset}" #Echo the combined arguments 
echo -e "\n"
cat -n playlog
echo -e "\n"

if (($bulls == 4)); then
  if (($count == 1)); then 
    echo -e "${BGreen}YOU WON!!!  It took you 1 try and $total_time seconds${Reset}"
  else
    echo -e "${BGreen}YOU WON!!!  It took you $count tries and $total_time seconds${Reset}"
  fi
else
  echo -e "${BRed}The Answer is: ${number[@]}${Reset}"
fi

#-----------------------------------------------------------------------

#Saving High score:
if [[ $# > 0 && $bulls == 4 ]]; then
  name=$(echo $1 | awk '{print toupper($0)}')
  if grep -i -q $name score; then #if Name with High score exists
    best_time=$(grep -i $name score | awk '{print $2}')
    best_turn=$(grep -i $name score | awk '{print $3}')

    #check if solved in fewer turns and if current time is less than previous best time
    if (($count < $best_turn));then
      sed -i "/$name/d" score
      echo "$name $total_time $count" >> score #delete old score and append new high scorei
    elif (($count == $best_turn && $total_time < $best_time)); then
      sed -i "/$name/d" score
      echo "$name $total_time $count" >> score #delete old score and append new high scorei
    fi
      else
    echo "$name $total_time $count" >> score
  fi
fi

#Clear playlog
$(: > playlog)
