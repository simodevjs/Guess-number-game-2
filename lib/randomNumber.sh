#!/bin/bash

#Generates unique random number of specified length

#Include inArray function to check if number is in array
source ./lib/inArray.sh

randomNumber(){
  local number=() 
  local length=$1 #Length of the unique number 
  
  while (( ${#number[@]} < $length )); do
    local num=$(( $RANDOM % 10 ))
  
    inArray $num ${number[@]} #Check if new Random num is already in array
    contains=$? #Assign return value of inArray(): 1 or False, not in array
    
    if (( $contains == 1 )); then
      number+=($num) #If not in array, add to number
    fi
  done
  
  echo ${number[*]}
}

