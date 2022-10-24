#! /bin/bash
echo
echo "===============create database==============="
echo "Enter data base name want to create : "
read  -r  dbname
echo

while [[ -z $dbname ]] || [[ $dbname == *['!''@#/$\"*{^})(+|,;:~`._%&/=-]>[<?']* ]] || [[ $dbname =~ [0-9] ]]

do          
            echo  "Invalid Input"
            echo
            read -p "PLease Enter Database Name Again: " dbname           
done
        if [ -d ./databases/$dbname ]  
        then
            echo "Database $dbname already exists!!"
        else

            mkdir ./databases/$dbname

            echo
            echo " ==============$dbname created successfully==============="
            echo 
        fi
            echo
            echo "1. create another database"
            echo "2. main menu"
            echo
            echo "Please enter your choice : "
            read -r  choice
            echo
case $choice 
in 
    1 ) create_db.sh ;;
    2 ) exit ;;
    * ) echo -e "\n$choice is not a valid option try again \n" ;;
esac
