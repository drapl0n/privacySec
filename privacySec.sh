#!/bin/bash
allowAbort=true;
myInterruptHandler()
{
    if $allowAbort; then
        echo -e "\nYou terminated PrivacySec!!!!!!" && exit 1;
    fi;
}
trap myInterruptHandler SIGINT;
result=$(figlet "[~~Privacy - Sec~~]" -w 100 | boxes -d stone) && echo "$result"
echo -e "Welcome to PrivacySec!!"
echo -e "1]  Encrypt\n2]  Decrypt\n3]  Import\n4]  Export\n5]  Search\n6]  Generate New Key"
read -p "Enter your choice: " ch
#FUNCTIONS

encrypt () {

		echo -e "1] Instant Encrypt.\t\t 2] Encrypt message inside file. \t\t 3]Encrypt Directory" 
		read -p "Enter your choice: " ch_t_enc
		if [ "$ch_t_enc" = 1 ]
			then 
			read -p "Enter your message: " my_msg
			touch /tmp/temp.txt
			echo $my_msg > /tmp/temp.txt
			echo -e "\nHere is list of the keys...."
			echo
			gpg --list-keys | boxes -d stone
			read -p "Enter recipients name: " recipient
			read -p "Do you want your message in ascii form?? (y,n): " armor
				if [ "$armor" = y ]
					then 
					gpg -o /tmp/op_file -e --armor -r $recipient /tmp/temp.txt
				elif [ "$armor" = n ]
					then
					gpg -o /tmp/op_file -e -r $recipient temp.txt
				else
					echo -e "Incorrect Input"
				fi
			rm -rf /tmp/temp.txt
			echo
			echo "-----------------------------------------------------------------------"
			cat /tmp/op_file
			echo "-----------------------------------------------------------------------"
			rm -rf /tmp/op_file
		elif [ "$ch_t_enc" = 2 ]	
			then
			read -p "Path of file which includes message: " ip_file
			read -p "Name and Path for encrypted message: " op_file
			echo -e "Here is list of the keys....\n"
			gpg --list-keys
			read -p "Enter recipients name: " recipient
			read -p "Do you want your message in ascii form?? (y,n): " armor
				if [ "$armor" = y ]
					then
					gpg -o $op_file -e --armor -r $recipient $ip_file
				elif [ "$armor" = n ]
					then
					gpg -o $op_file -e -r $recipient $ip_file
				else
					echo -e "Incorrect Input"
				fi
			
		elif [ "$ch_t_enc" = 3 ]	
			then
			read -p "Enter the path of directory to encrypt: " path
			gpgtar -c -o $path.gpg $path

		fi	

}
decrypt () {
			echo -e "1] Instant Decrypt.\t\t 2] Decrypt message inside file. \t\t 3]Decrypt Directory" 
			read -p "Enter your choice: " ch_t_dec
			read -p "Path of file which includes encrypted message: " ip_file
			read -p "Name and path for Output: " op_file
			gpg -o $op_file -d  $ip_file
	}
import () {
		echo -e "1] I want to import key localy. \t\t 2] I want to import key from keyserver."
		read -p "Enter your choice: " ch_t_imp
		if [ "$ch_t_imp" = 1 ]
			then
			read -p "Enter path of key: " key_path
			gpg --import $key_path
		elif [ "$ch_t_imp" = 2 ]
			then
			read -p "Enter kwy_code: " code
			read -p "From which keyserver you want to import keys? : " server
			gpg --keyserver $server --recv-keys $code
		fi
	}
export_key () {

			echo -e "1] Export public key. \t\t 2] Export private key." 
			read  -p "Enter your choice: " ch_t_exp
			if [ "$ch_t_exp" = 1 ]
				then
				read -p "Enter Name and path for output file: " op_file
				echo
				gpg --list-key | boxes -d stone
				read -p "Enter recipients name: " recipient
				read -p "Do you want your message in ascii form?? (y,n): " armor
				if [ "$armor" = y ]
					then
					gpg -o $op_file --armor --export $recipient
				elif [ "$armor" = n ]
					then
					gpg -o $op_file --export $recipient
				else
					echo -e "Incorrect Input"
				fi
			elif [ "$ch_t_exp" = 2 ]
				then
				read -p "Enter Name and path for output file: " op_file
				echo
				gpg --list-key | boxes -d stone
				read -p "Enter recipients name: " recipient
				read -p "Do you want your message in ascii form?? (y,n): " armor
				if [ "$armor" = y ]
					then
					gpg -o $op_file --armor --export-secret-key $recipient
				elif [ "$armor" = n ]
					then
					gpg -o $op_file --export-secret-key $recipient
				else
					echo -e "Incorrect Input"
				fi
			fi

}
search () {
		echo -e "1] Search Localy \t\t 2] Search in Keyserver"
		read -p "Enter your choice: " ch_t_key	
		if [ $ch_t_key = 1 ]
			then
			read -p "Enter keyword to search for: " keyword
			read -p "Do you want to search for 1] PublicKey / 2] PrivateKey: " pripub
			if [ "$pripub" = 1 ]
				then
				echo
			gpg --list-keys $keyword | boxes -d stone
			elif [ "$pripub" = 2 ]
				then
				echo
				gpg --list-secret-keys $keyword | boxes -d stone
			else
				echo "Invalid Input !!"
			fi
		elif [ "$ch_t_key" = 2 ]
				then
				read -p "Enter keyword to search for: " keyword
				echo
			    gpg --search-keys $keyword | boxes -d stone
		fi
}
keyGen () {
		clear
		gpg --full-gen-key --expert
		read -p "press key to continue" jj
		
}
if [ "$ch" = 1 ]
	then
		encrypt
elif [ "$ch" = 2 ]	
	then
		decrypt
elif [ "$ch" = 3 ]
	then
		import
elif [ "$ch" = 4 ]
	then
		export_key
elif [ "$ch" = 5 ]
	then
		search	
elif [ "$ch" = 6 ]
	then
		keyGen			
fi
