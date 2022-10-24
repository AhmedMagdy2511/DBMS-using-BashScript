#! /bin/bash
list_table.sh

echo "===============Select Table==============="
echo
echo "Enter Table You Want To Select"
read -r tablename

if [ -f $tablename ] 
then
        table_meta_data=".${tablename}.meta"
        echo "==========$tablename selected=========="
        
        #reading data types
        column_datatype=$(head -3 $table_meta_data | tail -1) #data types
        #adding data types to array 
        column_datatype_array=($(echo "$column_datatype" | sed 's/:/ /g'))

        #row number
        r_num=0
        
        #reading columns names
        names=$(head -4 $table_meta_data | tail -1)
        
        #adding the colmunns name to array
        col_names=($(echo "$names" | sed 's/:/ /g'))
        
        #reading the primary key index
        pkey_index=$(head -2 $table_meta_data | tail -1)

        #reading the datatype of the primary key to modify the input correctly
        data_type=${column_datatype_array[$pkey_index]}

        #this var is used because the array index start with 0 and the awk index start with 1
        #adding because there is no pk =0 and the index in the array start by 0 
        let y=$pkey_index+1 #pk index
        
        #reading the primary key for the record to delete
        read -p "Please enter the primary key that you want to delete :" input_pkey

        #validate the input is not corupted
        while  [[ $input_pkey == *['!''@#/$\\"*{^})(+|,;:~`._%&/=-]>[<?']* || $tbname == ""  ]]
        do 

                echo  "
                          ^    
                        /_!_\ Invalid Input"
                echo

                read -p "PLease Enter primary key Again: " input_pkey           
        done
#-----------------------------------------------------INT validation---------------------------------------------------------------------------------        
        #this condition is to make sure that the new data entered has the same data type of the column
        #if the input is integer
        if [[ $data_type == *"int"* ]]
        then
        
               #this loop is to make sure that it wont get out with out the correct value
               while true
               do
               if [[ $input_pkey =~ [0-9] ]]
                then
                        #cheacking if the record exist and getting its index and saving the row number
                        r_num=$(awk 'BEGIN{FS=":"}{if ($'$y'=="'$input_pkey'")print NR}' $tablename)
                        #this condition is to make sure that the entered primary key does exist in the table
                        if [ $((r_num)) -eq 0 ]
                        then
                                #the entered primary key doesnt exist
                                echo "${col_names[$pkey_index]} does not exist"
                                #moving back
                                exit
                        else
                                #deleting data
                                sed -i ''$r_num'd' $tablename

                                echo "data deleted succesfully "
                        fi
                        
                        break
                else 
                echo " 
                       ^    
                     /_!_\ somthing wrong excpected number"
                
                        read -p "enter value again: " new_value        

                fi #end of the int regax if
                done
#-----------------------------------------------------STR validation---------------------------------------------------------------------------------        

      #if the input is string
        elif  [[ $data_type == *"str"* ]]
        then
                #this loop is to make sure that it wont get out with out the correct value
                while true
                do
                if [[ $new_value =~ [a-zA-Z] ]]
                then
                        #cheacking if the record exist and getting its index and saving the row number
                        r_num=$(awk 'BEGIN{FS=":"}{if ($'$y'=="'$input_pkey'")print NR}' $tablename)
                        #this condition is to make sure that the entered primary key does exist in the table
                        if [ $((r_num)) -eq 0 ]
                        then
                                #the entered primary key doesnt exist
                                echo "${col_names[$pkey_index]} does not exist"
                                #moving back
                                exit
                        else
                                #deleting data
                                sed -i ''$r_num'd' $tablename

                                echo "data deleted succesfully "
                        fi
                        
                        break
                else
                echo " 
                       ^    
                     /_!_\ somthing wrong excpected string"
                     
                     read -p "enter value again: " new_value
                
                fi #end of the string regax if
                done
#-----------------------------------------------------DATE validation---------------------------------------------------------------------------------        
       
       
       elif  [[ $data_type == *"date"* ]]
        then
                #this loop is to make sure that it wont get out with out the correct value
                while true
                do
                if [[ $new_value =~ [0-9]{2}\-[0-1]{1}[0-9]{1}\-[0-9]{4} ]]
                then
                        #cheacking if the record exist and getting its index and saving the row number
                        r_num=$(awk 'BEGIN{FS=":"}{if ($'$y'=="'$input_pkey'")print NR}' $tablename)
                        
                        #this condition is to make sure that the entered primary key does exist in the table
                        if [ $((r_num)) -eq 0 ]
                        then
                                #the entered primary key doesnt exist
                                echo "${col_names[$pkey_index]} does not exist"
                                
                                #moving back
                                        exit
                        else
                                #deleting data
                                sed -i ''$r_num'd' $tablename

                                echo "data deleted succesfully "
                        fi
                        
                        break
                else
                echo " 
                       ^    
                     /_!_\ somthing wrong excpected dd-mm-yyyy"
                     
                     read -p "enter a valid date: " new_value
                
                fi #end of the date regax if
                done
#--------------------------------------------------------------------------------------------------------------------------------------       
        else
                echo " 
                       ^    
                     /_!_\ somthing wrong datatype cheack the table meta data"
               
        fi #end of data type if





































        



else
            echo
            echo  "$tablename table does not exist"
            echo
fi