#!/bin/bash

#Set Global Variables
Level=1
Max=100
RED='\033[0;31m'
WHITE='\033[1;37m'


gID=123456789
gAttempts=0
gRegCount=0
gName=Joe
gRegion=NULL
gSeason=NULL
gNational=0

gQual=0

gTries=0
gTime=0
gScore=0

#Variables for Databases
dFolder=./data
dRegion="${dFolder}/regionresults.txt"
dNation="${dFolder}/nationresults.txt"

function getDatabase() {
	echo "---------------------------------------------"
	printf "Loading data and initializing data structures\n"

	if [[ ! -d "$dFolder" ]]; then
		printf "$dFolder folder does not exist, creating it...\n"
		mkdir "$dFolder"
		printf "$dFolder folder created\n"
	fi
	
	if [[ ! -f "$dRegion" ]]; then
		printf "$dRegion does not exist, creating it...\n"
                touch "$dRegion"
                printf "$dFolder created\n"
	fi

        if [[ ! -f "$dNation" ]]; then
                printf "$dNation does not exist, creating it...\n"
                touch "$dNation"
                printf "$dNation created\n"
        fi
	echo "---------------------------------------------"

}

function getID() {
while : ; do

	read -p "Please enter your UNIQUE 9 digit Player ID: " gID
        if [[ "$gID" =~ ^[0-9]+$ && "${#gID}" -eq 9 ]]; then
			break
		else
			echo "Invalid ID"
	fi
done
}

function getName() {
while : ; do

	read -p "Please enter your name: " gName
	if [[ ! "$gName" =~ ^[a-zA-Z]+$ ]]; then
		echo "Your name can only contain letters"
	else
		break
	fi
done
}

function getAttempts() {

	gAttempts=$( cut -d "," -f1 "$dRegion" | grep $gID | wc -l )

	if [[ $gAttempts -gt 0 ]]; then
		gName="$( egrep $gID "$dRegion" | head -n 1 | cut -d "," -f 2)"
	fi
}

function getRegions {
	gRegCount=$(egrep ^$gID "$dRegion" | cut -d ',' -f 3  | sort | uniq | wc -l)
	
	if [[ $gRegCount -eq 1 ]]; then
		gRegion="$( egrep $gID "$dRegion" | head -n 1 | cut -d "," -f 3 )"
	fi
}

function qualification {
		gRegion="$( egrep $gID "$dRegion" | head -n 1 | cut -d "," -f 3 )"
                sorted=$( egrep "\<$gRegion\>" "$dRegion" | awk -F, '!a[$1]++' | awk 'BEGIN {FS=",";} {printf("%d %s %s %s %d %d %d %f\n",$1,$2,$3,$4,$5,$6,$7,$8)}' | sort -r -n -k 8 | head -n 3 )
		gQual="$( egrep $gID <<< $sorted | wc -l )"
}

function getNational {
	gNational=$( cut -d "," -f1 "$dNation" | grep $gID | wc -l )
}

function help() {
cat <<Splashart
╔═╦═╦══╦╦═╦═╦╦══╗
║║║╔╩╗╔╣║║║║║╠╗╚╣
╚═╩╝.╚╝╚╩═╩╩═╩══╝
Splashart
	
echo "Usage: use a single letter command to play the game"
echo "h - help, show this command list"
echo "e - do excercise by oneself"
echo "c - change game difficulty level"
echo "q - quit the game"
echo "p - participate competition"
echo "s - show my score in descending order"
echo "l - show my place in all gamers"
echo "r - show regional top three in descending order"
echo "a - check my qualification of attending national arena"
echo "n - show national competitors"
echo "P - participate national competition"
echo "w - print national winners"

}

function exercise() {
cat <<Splashart
╔╦══╦════╦╦═╦═╦╦══╦══╦╦╗
║║░░╠═╦═╦╝╠╦╬═║║╔═╣╔╗║║║
║║╔╗╣╩╬╝║║║║╠╦╝║╚╝║╚╝╠╣║
║╚╝╚╩═╩═╩═╬╗╠╝.╚══╩══╩╝║
╚═════════╩═╩══════════╝
Splashart

	echo "=== Current Difficulty Level : $Level  ==="
	echo "guess a number between 1 to $Max"
	targetnum=$(($RANDOM % $Max + 1))
	num=1
	count=0
	starting="$SECONDS"
	elpased=0
	echo
	until [ $num -eq $targetnum ]; do
	read -p "Your guess: " num
	    if [ $num -gt $targetnum ]; then
	        echo "too large"
	    else
	        echo "too small"
	    fi
		((count++))
	done
	echo "Congratulation! You get it!"
	elpased=$(( $SECONDS - $starting  ))
	myscore=$( echo "10000*1/$elpased/$count" | bc -l  )
	echo "You used $elpased seconds, tried $count times, and scored $myscore"
	gTime=$elpased
	gTries=$count
	gScore=$myscore
}

function difficulty() {
	echo ""
	echo "--- About Difficulty Level---"
	echo "Level 1: guess a number between 1 to 100"
	echo "Level 2: guess a number between 1 to 1000"
	echo "Level 3: guess a number between 1 to 10000"
	echo "=== Current Difficulty Level : $Level ==="
	echo "1) EASY"
	echo "2) INTERMEDIATE"
	echo "3) HARD"
	
	read -p 'Select a new difficulty level: ' newLevel
	case $newLevel in
		1)
		Level=1
		Max=100
		echo "=== New Difficulty Level : 1 ==="
		;;
		2)
		Level=2
		Max=1000
		echo "=== New Difficulty Level : 2 ==="
		;;
		3)
		Level=3
		Max=10000
		echo "=== New Difficulty Level : 3 ==="
		;;
		*)
		echo "Invalid Value"
		;;
	esac
}

function competition() {
	echo " "
	echo "Welcome to the National Game of Guessing Numbers!"
	getID
	getAttempts

	if [[ gAttempts -eq 0 ]]; then
		getName
	elif [[ gAttempts -lt 3 ]]; then
		echo "Hello $gName, welcome back!"
		echo "You have competed $gAttempts time(s) in the regional arenas. You can still compete $((3-gAttempts)) time(s) in the regional arenas"
	else
		echo "Hello $gName, welcome back!"
		echo "You have competed 3 times in the regional arenas, please participate in the national arena if you are qualified"
		continue
	fi

	while $true; do
		echo "Available regions for competition:"
		echo "1) South"
		echo "2) Northeast"
		echo "3) Midwest"
		echo "4) West"

		read -p "Please select a region: " region
		case $region in
			1)
			gRegion=SOUTH
			break
			;;
			2)
			gRegion=NORTHEAST
			break
			;;
			3)
			gRegion=MIDWEST
			break
			;;
			4)
			gRegion=WEST
			break
			;;
			*)
			echo "Invalid Input"
		esac
	done

	while $true; do
		echo "Seasons for regional competition:"
		echo "1) Spring"
		echo "2) Summer"
	        echo "3) Fall"

	        read -p "Please select a season: " season
	        case $season in
        	        1)
        	        gSeason=SPRING
        	        break
			;;
			2)
	                gSeason=SUMMER
        	        break
			;;
	                3)
        	        gSeason=FALL
                	break
			;;
	                *)
	                echo "Invalid Input"
	        esac
	done

	echo " "
	exercise

	echo "$gID,$gName,$gRegion,$gSeason,$Level,$gTries,$gTime,$gScore" >> "$dRegion"
}

function score() {
	getID
	getAttempts

	if [[ $gAttempts -eq 0 ]]; then
		echo " "
		echo "You have not participated in any regional arenas yet!"
		echo " Please participate in regional arenas first"
		echo " Good Luck!"
		echo " "
	else
		echo " "
		echo "Hello $gName, here are your competitions:"
		echo "-----------------------------------------------"
		echo "Region	Season	Level	Tries	Time	Score"
		echo "-----------------------------------------------"
		egrep $gID $dRegion | awk 'BEGIN {FS=",";} {printf("%-7s %-8s %-8d %-6d %-4d %8.2f\n", $3, $4, $5, $6, $7, $8 )} ' | sort -r -n -k 6
		echo "-----------------------------------------------"
	fi

}

function placement() {
        local RED='\033[0;31m'
	local WHITE='\033[1;37m'

	getID
        getAttempts

        if [[ $gAttempts -eq 0 ]]; then
                echo " "
                echo "You have not participated in any regional arenas yet!"
                echo " Please participate in regional arenas first"
                echo " Good Luck!"
                echo " "
        else
                echo "===== regional competition results ====="
		echo " "
		echo "---------------------------------------------------------------------------------"
		printf "%-12s %-8s %-14s %-8s %-8s %-8s %-10s %-8s\n" "ID" "Name" "Region" "Season" "Level" "Times" "Seconds" "Score"
		echo "---------------------------------------------------------------------------------"

		cat $dRegion | awk -v id=$gID -v red="$RED" -v white="$WHITE" 'BEGIN {FS=",";} {
			if($1 == id)
		   	{
				printf("%s%-12d %-8s %-14s %-8s %-8d %-8d %-8d %8.2f%s\n", red, $1, $2, $3, $4, $5, $6, $7, $8, white)
			} 
		 	else 
			{
				printf("%-12d %-8s %-14s %-8s %-8d %-8d %-8d %8.2f\n", $1, $2, $3, $4, $5, $6, $7, $8)
			}
		}' | sort -r  -n -k 8

		echo "---------------------------------------------------------------------------------"
        fi

}

function rScore {

	printf "\n          =====${RED} The Top 3 of region %s ${WHITE}=====\n" "$gRegion"
	echo "-----------------------------------------------------------------"
	printf "%-12s %-8s %-8s %-8s %-8s %-8s %-8s\n" "ID" "Name" "Season" "Level" "Times" "Seconds" "Score"
	echo "-----------------------------------------------------------------"
	egrep "\<$gRegion\>" $dRegion | sort -t ',' -rn -k 8,8 | awk -F, '!a[$1]++' | awk -v red="$RED" -v white="$WHITE" 'BEGIN {FS=",";} {printf("%-12d %-8s %-8s %-8d %-8d %-8d %s%6.2f%s\n",$1,$2,$4,$5,$6,$7,red,$8,white)}' | head -n 3
	echo "-----------------------------------------------------------------"
}

function qual {
	getID
	getAttempts
	getRegions

	if [[ $gAttempts -eq 0 ]]; then
		echo " "
                echo "You have not participated in any regional arenas yet!"
                echo " Please participate in regional arenas first"
                echo " Good Luck!"
                echo " "
	elif [[ $gRegCount -gt 1 ]]; then
		echo " "
		echo "Dear $gName, you competed in $gRegCount regions so you are disqualified!"
		echo "Below are your records:"
		echo "-----------------------------------------------------------------"
		printf "%-12s %-8s %-8s %-8s %-8s %-8s\n" "Region" "Season" "Level" "Times" "Seconds" "Score"
		echo "-----------------------------------------------------------------"

		egrep "$gID" $dRegion | awk -v id=$gID 'BEGIN {FS=",";} {
			if($1 == id)
			{
				printf("%-12s %-8s %-8d %-8d %-8d %6.2f\n",$3,$4,$5,$6,$7,$8)
			}
		}' | sort -n -r -k 6
		echo "-----------------------------------------------------------------"

	else
		qualification

		if [[ $gQual -gt 0 ]]; then

			echo " "
	                echo "Congratulations! $gName, you are qualified to attend the national arena!"
	                printf "=====${RED} Your place in region %s ${WHITE}=====" "$gRegion"
			echo " "
			echo "---------------------------------------------------------------------------------"
	                printf "%-12s %-8s %-14s %-8s %-8s %-8s %-10s %-8s\n" "ID" "Name" "Region" "Season" "Level" "Times" "Seconds" "Score"
	                echo "---------------------------------------------------------------------------------"

	                egrep "\<$gRegion\>" $dRegion | sort -t ',' -rn -k 8,8 | awk -F, '!a[$1]++' | head -n 3| awk -v id=$gID -v red="$RED" -v white="$WHITE" 'BEGIN {FS=",";} {
                       		if($1 == id)
                        	{
                        	        printf("%s%-12d %-8s %-14s %-8s %-8d %-8d %-8d %8.2f%s\n", red, $1, $2, $3, $4, $5, $6, $7, $8, white)
                        	}
                        	else
                        	{
                        	        printf("%-12d %-8s %-14s %-8s %-8d %-8d %-8d %8.2f\n", $1, $2, $3, $4, $5, $6, $7, $8)
                        	}
                	}'
			echo "---------------------------------------------------------------------------------"
		else
			echo " "
			echo "Unfortunately you are not in the top three for your region, and have not qualified for the national arena"
			echo " "
		fi
	fi
}

function competitors {
	gRegion=SOUTH
	rScore
        gRegion=NORTHEAST
        rScore
        gRegion=MIDWEST
        rScore
        gRegion=WEST
        rScore
}

function nCompetition {
	getID
	getAttempts
	getNational
	getRegions

	if [[ $gAttempts -eq 0 ]]; then
		echo " "
        	echo "You have not participated in any regional arenas yet!"
        	echo " Please participate in regional arenas first"
        	echo " Good Luck!"
        	echo " "
	elif [[ $gNational -gt 0 ]]; then
		echo " "
		echo "Hello $gName, you may only participate once in the national arena"
		echo " "
	elif [[ $gRegCount -gt 1 ]]; then
                echo " "
                echo "Dear $gName, you competed in $gRegCount regions so you are disqualified!"
                echo "Below are your records:"
                echo "-----------------------------------------------------------------"
                printf "%-12s %-8s %-8s %-8s %-8s %-8s\n" "Region" "Season" "Level" "Times" "Seconds" "Score"
                echo "-----------------------------------------------------------------"

                egrep "\<$gRegion\>" $dRegion | awk -v id=$gID 'BEGIN {FS=",";} {
                        if($1 == id)
                        {
                                printf("%-12s %-8s %-8d %-8d %-8d %6.2f\n",$3,$4,$5,$6,$7,$8)
                        }
                }'
                echo "-----------------------------------------------------------------"

        else
                qualification

                if [[ $gQual -gt 0 ]]; then
			gLevel=3
			Max=10000
			exercise
			echo "$gID,$gName,$gRegion,$gTries,$gTime,$gScore" >> "$dNation"
		else
                        echo " "
                        echo "Unfortunately you are not in the top three for your region, and have not qualified for the national arena"
                        echo " "
		fi
	fi
}

function winners {
	printf "**************${RED}National Winners${WHITE}**************\n"
	printf "%-10s %-10s %8s %-8s\n" "Name" "Region" "Score" "Medal"
	cat $dNation | sort  -t ',' -rn -k 6,6 | awk -F, -v red="$RED" -v white="$WHITE"  '
		BEGIN{
        		medals="Gold,Silver,Silver,Bronze,Bronze,Bronze"; split(medals,medal,",");
    		} 
    		{
        	if(NR % 2)
        	    printf("%s%-10s %-10s %8.2f %-8s%s\n", red, $2, $3, $6, medal[NR],white );
        	else
        	    printf("%-10s %-10s %8.2f %-8s\n", $2, $3, $6, medal[NR] );
    		}
    		' | head -n 6
	echo "**********************************************"
}

cat <<SPLASHART
╔╦══╦═══════════╦═╦╦═════╦╦═════╗
║║╔═╬╗╔╦═╦══╦══╗║║║╠╗╔╦══╣╚╦═╦═╗║
║║╚╝║╚╝║╩╬╗╚╬╗╚╣║║║║╚╝║║║║║║╩╣╠╝║
║╚══╩══╩═╩══╩══╝╚╩═╩══╩╩╩╩═╩═╩╝.║
╚═══════════════════════════════╝
SPLASHART

getDatabase

help

while $true; do

	read -p 'single letter command: ' cmd
	case "$cmd" in 
		h) 
		help
		;;
		e)
		exercise

		while $true; do
	        	read -p "Continue practicing? [y/n] " YorN
	    		case $YorN in
	        	        y)
	        	        exercise
	        	        ;;
	        	        n)
	        	        break;
	      		        ;;
	        	esac
		done
		;;
		c)
		difficulty
		;;
		q)
		read -p "Do you really want to quit? [y/n] " quityn
		case "$quityn" in
			y) echo "Exiting Game"
			exit 0
			;;
			n)
			continue;
			;;
		esac
			
		break;
		;;
		p)
		competition
		;;
		s)
		score
		;;
		l)
		placement
		;;
		r)
	        while $true; do
                	echo "Available regions for competition:"
                	echo "1) South"
                	echo "2) Northeast"
                	echo "3) Midwest"
                	echo "4) West"

                	read -p "Please select a region: " region
                	case $region in
                	        1)
                	        gRegion=SOUTH
                	        break
                	        ;;
                	        2)
                	        gRegion=NORTHEAST
                	        break
                	        ;;
                	        3)
                	        gRegion=MIDWEST
                	       	 break
                	        ;;
                	        4)
                	        gRegion=WEST
                	        break
                	        ;;
                	        *)
                	        echo "Invalid Input"
                	esac
        	done

		rScore
		;;
		a)
		qual
		;;
		n)
		competitors
		;;
		P)
		nCompetition
		;;
		w)
		winners
		;;
		*)
		echo "Invalid Command"

	esac

done
