#!/bin/bash

BRed='\033[1;31m'         # Red text
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
Reset='\033[0m'

message="${BGreen}Bulls${Reset} and ${BYellow}Cows${Reset}"

#Function to clear screen and display at the right row and column
display(){ 
  tput clear #clear terminal
  tput cup 4 10 #put "cursor" at given location
  echo -e "$message" #Title
}

display

#Using the Select 
menu="Play Instructions Scores Quit"
game_menu="Login Play"
PS3='Select option: '
 
select choice in $menu; do
  case $choice in
    "Quit")
      break
      ;;
    "Scores")
      display
      sort -k3 -n score | awk -f lib/awk_display.awk  
      echo -e "\n"
      read -p "Press Enter to continue"
      display
      ;;
    "Instructions")
      display
      cat rules
      echo -e "\n"
      read -p "Press Enter to continue"
      display
      ;;
    "Play")
      select option in ${game_menu}; do
        display
        case $option in
          "Login")
            echo -e "\n"
            read -p "Enter your name: " name
            bash game.sh $name
            echo -e "\n"
            read -p "Press Enter to continue"
            display
            break
            ;;
          "Play")
            bash game.sh $name
            echo -e "\n"
            read -p "Press Enter to continue"
            display
            break
            ;;
        esac
      done
  esac
done

tput sgr0 #Turns bold and other changes off
tput cup $( tput lines ) 0 #Place the prompt at the bottom of the screen


