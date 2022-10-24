#! /bin/bash
            echo
            echo "===============connect db==============="

        list_db.sh
            echo "please enter database name : " 
            read -r connect_db

    if [ -d ./databases/$connect_db ] 
    then
                cd ./databases/$connect_db
                echo
                
        while true
        do
                echo "==========$connect_db database=========="
                echo
                echo 1.Create Table 
                echo 2.List Tables
                echo 3.Drop Table
                echo 4.Insert into Table
                echo 5.Select From Table
                echo 6.Delete From Table
                echo 7.Update Table
                echo 8.main menu
                echo
                echo "++++++++++++++++++++++++++++++"
                echo
                echo "Please enter your choice : "
                read -r  choice
                
            case $choice in
                1 ) create_table.sh ;;
                2 ) list_table.sh ;;
                3 ) drop_table.sh ;;
                4 ) insert_into_table.sh ;;
                5 ) select_from_table.sh ;;
                6 ) delete_from_table.sh ;;
                7 ) update_table.sh ;;
                8 ) break;;
                * ) echo -e "\n$choice is not a valid option try again " ;;
            esac
        done
    else
        echo
        echo -e "$connect_db data base does not exist \n\nplease enter database name"
        source connect_db.sh
    fi
