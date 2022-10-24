#! /bin/bash  
    echo
    echo "===============drop database==============="
    echo

        list_db.sh
         echo "please enter database name to remove : "
         read -r  remove_db

    if [ -d ./databases/$remove_db ] 
    then
          echo "are you sure delete $remove_db (y/n): "
          read -r  ans
        if [[ $ans == y || $ans == Y ]]
        then
            rm -r ./databases/$remove_db
            echo
            echo "==========$remove_db removed=========="
            echo
        else 
            echo
            echo "$remove_db didn't removed"
        fi
    else
            echo
            echo  "$remove_db data base does not exist"
            echo
    fi
            echo
            echo "1. remove another database"
            echo "2. main menu"
            echo
            echo "Please enter your choice : "
            read -r  choice

case $choice in 
    1 ) drop_db.sh ;;
    2 ) exit ;;
    * ) echo -e "\n$choice is not a valid option try again \n" ;;
esac

