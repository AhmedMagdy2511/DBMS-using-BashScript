#! /bin/bash
cd ~


if [ -d "databases" ]
then
    echo "data base is running correctly"
else
    mkdir ./databases
fi
while true
do
    echo
    echo "===============main menu==============="
    echo
    echo "1. create Database"
    echo "2. list Databases"
    echo "3. Connect To Databases"
    echo "4. Drop Database"
    echo "5. Exit"
    echo
    echo "+++++++++++++++++++++++++++++++++++++++"
    echo
    echo "Please enter your choice : "
    read -r  choice
    
case $choice in
    1 ) create_db.sh ;;
    2 ) list_db.sh ;;
    3 ) connect_db.sh ;;
    4 ) drop_db.sh ;;
    5 ) break ;; 
    * ) echo -e "\n$choice is not a valid option try again \n" ;;
esac
done