#! /bin/bash
list_table.sh

echo "===============Select Table==============="
echo
echo "Enter Table You Want To Select"
read -r tablename
    
function validate(){        
        #the data entered
        new_col_name=$1
        #the type of data wanted to be validate
        value=$2
        #if the validation type is text then it need to avoide numbers
        if [ $value == "text" ]
        then
            additional_reg=*[0-9]*
        
        #if the validation type is number then it need to avoide text
        elif [ $value == "num" ]
        then
            additional_reg=*[a-zA-Z]*
        fi
        #validate the input is not corupted
        while  [[ $new_col_name == *['!''@#/$\\"*{^})(+|,;:~`._%&/=-]>[<?']* || $new_col_name == "" || $new_col_name == $additional_reg || $new_col_name == [\\] || $new_col_name == [\'] ]]
        do 
            echo  "
                      ^    
                    /_!_\ Invalid Input"
            echo

            read -p "PLease Enter The Value Again: " new_col_name         
        done
        
        return $new_col_name    
}
#this function is used to retrive all data in the table
function selectall
    {
        #this condition is used to make sure that the table have data on it
        if      [ $(cat "$tablename" | wc -l) -eq 0 ]
        then
                echo "
                      ^    
                    /_!_\ This Table is empty"
        else
                #printing the table head (columns names)
                head -4 $table_meta_data | tail -1
                #printing the table data (columns data)                
                awk -F: '{print $0}' $tablename
        fi
}

function select_col {       
            #reading table heads(columns names)
            names=$(head -4 $table_meta_data | tail -1)
            col_names=($(echo "$names" | sed 's/:/ /g'))
            
            counter=0
            echo ${col_names[@]} 
            read -p "Enter column name: " col_name
            
            #the type of data wanted to be validate
            text="text"
            
            #validate the input
            validate $col_name $text
            
            #the input after validation
            col_name=${?}

        for el in "${col_names[@]}";
        do
            #incrementing the column number starting with one in oreder to match the selected column 
            let counter=$counter+1 #index of input column
            
            #this condition is to make sure that the inserted column name is the one printed
            if [ $col_name = $el ]
            then
                 #printing the counter which will represent the number of column which is the column name inserted
                 awk -F: '{print $'$counter'}' $tablename
                 
                 break
            #this condition is to make sure that the counter isn't greater than the nymber of columns 
            elif [ $counter -eq ${#col_names[@]} ]
            then
                echo "
                          ^    
                        /_!_\ Column $col_name does not exist"
            fi
        done
}

function select_record {
            pkey_index=$(head -2 "$table_meta_data" | tail -1)
            read -p "Please enter the primary key of the record :" input_pkey
            text="num"
            validate $input_pkey $text
            input_pkey=${?}
            let y=$pkey_index+1
            r_num=0
            r_num=$(awk -F: '{if ($'$y'=="'$input_pkey'")print NR}' $tablename)
            # check if pkey doesnt exist
        if [ $((r_num)) -eq 0 ]
        then
            echo "${col_names[$pkey_index]} does not exist"
        else
            #search for the required value then print it
            data=$(awk  'BEGIN{FS=":"}{if (NR=="'$r_num'")print $0}' $tablename)
            echo "************************"
            echo "***  $data   ***" 
            echo "************************"
           echo '============================================================'
           
        fi
}

if [ -f $tablename ] 
then
        echo "==========$tablename selected=========="
        table_meta_data=".${tablename}.meta"
    while true
    do
            echo
            echo 1.select all
            echo 2.select column
            echo 3.select record
            echo 4.exit
            echo "Enter your choice: "
            read -r  choice

        case $choice in
                1) selectall ;;
                2) select_col ;;
                3) select_record ;;
                4) exit  ;;
                *) echo "$choice is not a valid option"
        esac
    done



else
            echo
            echo  "$tablename table does not exist"
            echo
fi

