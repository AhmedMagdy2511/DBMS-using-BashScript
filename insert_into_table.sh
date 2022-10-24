#! /bin/bash
#this file is to insert the data into the table regarding the data type and the table name and making sure that the data will be entered correctlly
list_table.sh

echo "===============Select Table==============="
echo
echo "Enter Table You Want To Select"
read -r tablename


#this condition is used to cheack if the table exist
if [ -f $tablename ] 
then
            table_meta_data=".${tablename}.meta"
            echo "==========$tablename selected=========="

            #the input data array or the row data
            declare -a input

            #the element index that the code standing at
            input_index=0
            #the worning of the primary key repetance
            flag=0
            #reading number of columns
            num_col=$(head -1 $table_meta_data)

            #reading primary key
            pkey_index=$(head -2 $table_meta_data | tail -1)

            #reading columns names
            column_name=$(head -4 $table_meta_data | tail -1) #cloumn names

            #reading data types
            column_datatype=$(head -3 $table_meta_data | tail -1) #data types 

            #adding the colmunns name to array
            column_name_array=($(echo "$column_name" | sed 's/:/ /g'))

            #adding data types to array 
            column_datatype_array=($(echo "$column_datatype" | sed 's/:/ /g')) 
#--------------------------------------------------------------------------------------------------------------------------------------
    #looping in every element in the column name array to add records         
    for     element in "${column_name_array[@]}";
    do
        #reading the record data
        read -p "Enter $element of data type ${column_datatype_array[$input_index]} :" user_input
#--------------------------------------------------------------------------------------------------------------------------------------        
         #reading the datatype of the current column to modify the input correctly
        some_data=${column_datatype_array[$input_index]}
#--------------------------------------------------------------------------------------------------------------------------------------       
        #validate the input is not corupted
        while  [[ $user_input == *['!''@#/$\\"*{^})(+|,;:~`._%&/=-]>[<?']* && $some_data != "date" || $user_input == "" ]]
        do          
            echo  "^    
                 /_!_\ Invalid Input"
            echo
            read -p "PLease Enter $element Again: " user_input           
        done
#--------------------------------------------------------------------------------------------------------------------------------------

        #if the input is integer
        if [[ $some_data == *"int"* ]]
        then
        
               #this loop is to make sure that it wont get out with out the correct value
               while true
               do
               if [[ $user_input =~ [0-9] ]]
                then
                
                              #this condition is used to cheack the if the primary key is repeated or not (unique)
                        if [ $input_index -eq $pkey_index ] #check primary key uniqueness
                        then    
                                #this var is used because the array index start with 0 and the awk index start with 1
                                #adding because there is no pk =0 and the index in the array start by 0 
                                let y=$pkey_index+1
                                
                                #this loop is to make sure that the primary key will be entered correctly     
                                while true 
                                do
                                        if [ $user_input -eq "0" ] #cheaking the zero case
                                        then
                                                echo " 
                       ^    
                     /_!_\ zero is not a valid record for primary key"
                                                read -p " 
           ^    
         /_!_\ you entered unvalid primary key! please enter valid value :   " user_input
                                                echo ""
                                                continue
                                        fi
                                                #if there is any dublication this will return 1 then will be used in the if after it
                                                flag=$(awk -F: '{if ($'$y'=="'$user_input'")print "1"} ' $tablename)
                                                
                                                if [ $((flag)) -eq 0 ]  #pkey is unique
                                                then
                                                
                                                        break
                                                else  #pkey is  not unique
                                                        let flag=0
                                                        read -p " 
                       ^    
                     /_!_\ you entered a duplicate primary key! please enter a unique value :" user_input
                                                fi
                                done
                                #saving the data to the array to write it in the file
                                input[$input_index]="$user_input:"
                                let input_index=$input_index+1
                                break

                        else
                                #saving the data to the array to write it in the file
                                input[$input_index]="$user_input:"
                                let input_index=$input_index+1
                                break
                        fi
                else 
                echo " 
                       ^    
                     /_!_\ somthing wrong excpected number"
                
                        read -p "enter value again: " user_input        

                fi #end of the regax if
                done
      #--------------------------------------------------------------------------------------------------------------------------------------
      #if the input is string
        elif  [[ $some_data == *"str"* ]]
        then
                #this loop is to make sure that it wont get out with out the correct value
                while true
                do
                if [[ $user_input =~ [a-zA-Z] ]] 
                then
                        input[$input_index]="$user_input:"
                        let input_index=$input_index+1
                        break
                else
                echo " 
                       ^    
                     /_!_\ somthing wrong excpected string"
                     read -p "enter value again: " user_input
                
                fi #end of the regax if
                done
#--------------------------------------------------------------------------------------------------------------------------------------       
       
       elif  [[ $some_data == *"date"* ]]
        then
                #this loop is to make sure that it wont get out with out the correct value
                while true
                do
                if [[ $user_input =~ [0-9]{2}\-[0-1]{1}[0-9]{1}\-[0-9]{4} ]]
                then
                        input[$input_index]="$user_input:"
                        let input_index=$input_index+1
                        break
                else
                echo " 
                       ^    
                     /_!_\ somthing wrong excpected dd-mm-yyyy"
                     read -p "enter a valid date: " user_input
                
                fi #end of the regax if
                done
#--------------------------------------------------------------------------------------------------------------------------------------       
       
       
       
        else
                echo " 
                       ^    
                     /_!_\ somthing wrong datatype cheack the table meta data"
               
        fi #end of data type if
 #--------------------------------------------------------------------------------------------------------------------------------------
        

    done

        printf %s "${input[@]}" $'\n' >> $tablename
        echo "data saved sucsessfully"
#--------------------------------------------------------------------------------------------------------------------------------------
else
            echo
            echo  " 
                       ^    
                     /_!_\ $tablename table does not exist"
            echo
fi

