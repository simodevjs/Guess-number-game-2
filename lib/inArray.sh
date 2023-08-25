#!/bin/bash

#Function to check if element is in array
#Takes 2 arguments: the element and expanded array

inArray(){
  local e #local varibale e 
  local arr="${@:2}" #Combines 2nd arg (expanded array) into one varibale  
     
  for e in $arr; do 
    if [[ "$e" == "$1" ]]; then 
      return 0 #Return 0 (True) 
    fi 
  done
  return 1 #Return 1 (False) otherwise
}

