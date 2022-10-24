#! /bin/bash
list_table.sh

echo "===============Select Table==============="
echo
echo "Enter Table You Want To Select"
read -r tablename

############################################ INPUT DATA CHEACKING ######################################################################################################################        

#this function is used to validate if the entereddata is corupted or not it takes 2 arguments (1)the data (2)the type of the data str or int
function validate(){        
      #the data entered
      local new_col_name=$1
      
      #the type of data wanted to be validate
      #this variable is used to help identify the datatype of the input
      local value_inside_func=$2
        
        #if the validation type is text then it need to avoide numbers
        if [ "$value_inside_func" == "str" ]
        then
            additional_reg=*[0-9]*
        
        #if the validation type is number then it need to avoide text
        elif [ "$value_inside_func" == "int" ]
        then
            additional_reg=*[a-zA-Z]*

        fi #end of the reqx if
        
        #validate the input is not corupted
        while  [[ $new_col_name == *['!''@#/$\"*{^})(+""|,;:~`._%&/=-]>[<?']* || -z $new_col_name || $new_col_name == $additional_reg ]]
        do 
            echo  "
                      ^    
                    /_!_\ Invalid Input"
            echo
            echo "PLease Enter The Value Again: "
            read -r  new_col_name         
        done
        
        #this conditon is a work around to return string 
        #it will print the modified value in order to return it as a string 
        if [ "$value_inside_func" == "str" ]
        then
          echo $new_col_name
        else
          return "$new_col_name"
        fi #end of the return if
}
############################################ DATA TYPE CHEACKING ######################################################################################################################        

function data_type_function(){
    new_value=$1
    data_type=$2
  #this condition is to make sure that the new data entered has the same data type of the column
  #if the input is integer
  if [[ $data_type == *"int"* ]]
  then
  
          #this loop is to make sure that it wont get out with out the correct value
          while true
          do
          if [[ $new_value =~ [0-9] ]]
          then
                    #updating the data
                  #sed -i ''$r_num's/'$old_value'/'$new_value'/g' $tablename
                  #echo "data updated succesfully "
                  #break
                  return $new_value
          else 
          echo " 
                  ^    
                /_!_\ somthing wrong excpected number"
          
                  read -p "enter value again: " new_value        

          fi #end of the regax if
          done
 #--------------------------------------------------------------------------------------------------------------------------------------
 #if the input is string
  elif  [[ $data_type == *"str"* ]]
  then
          #this loop is to make sure that it wont get out with out the correct value
          while true
          do
          if [[ $new_value =~ [a-zA-Z] ]]
          then
                  #updating the date
                  sed -i ''$r_num's/'$old_value'/'$new_value'/g' $tablename
                  echo "data updated succesfully "
                  break
          else
          echo " 
                  ^    
                /_!_\ somthing wrong excpected string"
                read -p "enter value again: " new_value
          
          fi #end of the regax if
          done
 #--------------------------------------------------------------------------------------------------------------------------------------       
  
  elif  [[ $data_type == *"date"* ]]
  then
          #this loop is to make sure that it wont get out with out the correct value
          while true
          do
          if [[ $new_value =~ [0-9]{2}\-[0-1]{1}[0-9]{1}\-[0-9]{4} ]]
          then
                  #updating the date
                  sed -i ''$r_num's/'$old_value'/'$new_value'/g' $tablename
                  echo "data updated succesfully "
                  break
          else
          echo " 
                  ^    
                /_!_\ somthing wrong excpected dd-mm-yyyy"
                read -p "enter a valid date: " new_value
          
          fi #end of the regax if
          done
 #--------------------------------------------------------------------------------------------------------------------------------------       
  else
          echo " 
                  ^    
                /_!_\ somthing wrong datatype cheack the table meta data"
          
  fi #end of data type if
}

############################################ UPDATE DATA ######################################################################################################################        

#this function is used to update the data in the corect place making sure that the input data is like the old data of type and the existance of the columns
function update_field
{
        #getting the columns names
        names=$(head -4 "$table_meta_data" | tail -1)

        #spliting the names of the columns
        col_names=($(echo "$names" | sed 's/:/ /g'))
        
        #this loop is used to make sure that the column name entered is one of the columns
        while true
        do
            #identify the state of input date if it is false the loop will contiue until its true
            state='false'
            

            echo "=============== Select Column ==============="
            echo
            echo "***********************************"
            echo ${col_names[@]} 
            echo "***********************************"

            #getting the column name wanted to be updated
            read -p "enter the column you want to update :" column
            
            #this variable is used to help identify the datatype of the input
            col_type="str" #used for the validation function
            
            #validating the input data
            #this is a work around to return string
            validate_column=$(validate $column $col_type)

            #this loop is to make sure that the input column exist
            for element in "${col_names[@]}";
            do 
                #this condition is used to make sure that the current input is correct and change the state to true 
                if [ $validate_column == $element ]
                then
                    state='true'
                    break
                fi #end of the state condition

            done #end of the cheacking loop

            #this condition is used to continue the rest of the code 
            if [ $state == 'true' ]
            then
                break
            fi #end of the break condition

            echo "
                      ^    
                    /_!_\  wrong column name!
                    
                    "
        done #end of the column name loop
 #--------------------------------------------------------------------------------------------------------------------------------------       
        #gettting the right index of the column
        column_index=$(awk -F: '{for(i=1;i<=NF;i++){if($i=="'$validate_column'") print i}}' $table_meta_data)

        #reading the datatype of the current column to modify the input correctly
        data_type_index=$column_index-1 #this var is used because the array index start with 0 and the awk index start with 1
        data_type=${column_datatype_array[$data_type_index]}
      
        #retriving the old value by cheacking if the row number (r_num) is eq to the current NR then loop in it to get the value of the cloumn entered e.g row number 3 column number 2 
        old_value=$(awk -F: '{if(NR=='$r_num'){for(i=1;i<=NF;i++){if(i=='$column_index') print $i}}}' $tablename)
        echo "-----------------------------------------"
        echo "current $validate_column is $old_value"
        echo "-----------------------------------------"

        #reading the new value
        read -p "enter the new value :" new_value

 ############################################ SAVING THE DATA ######################################################################################################################        
        data_type_function $new_value $data_type
        #updating the date
        new_value_mod=${?}
        sed -i ''$r_num's/'$old_value'/'$new_value_mod'/g' $tablename
        echo "############ data updated succesfully ###############"


}

############################################ THE MAIN BODY ######################################################################################################################        

#cheacking if the table exist
if [ -f $tablename ] 
then
    echo "==========$tablename selected=========="
    table_meta_data=".${tablename}.meta"
        
        
    #reading data types
    column_datatype=$(head -3 $table_meta_data | tail -1) #data types
    #adding data types to array 
    column_datatype_array=($(echo "$column_datatype" | sed 's/:/ /g'))
        
    #row number
    r_num=0
    
    #reading the primary key index
    pkey_index=$(head -2 $table_meta_data | tail -1)

    #reading the primary key for the record to update
    read -p "Please enter the primary key of the record you want to update!" input_pkey
    #input data type
    value="int"
    
    #validate the input is not corupted
    validate $input_pkey $value 
    input_pkey=${?}
           

    ############################

    #adding because there is no pk =0 and the index in the array start by 0 
    let pkey_index=$pkey_index+1

    #cheacking if the record exist and getting its index and saving the row number
    r_num=$(awk -F: '{if ("'$input_pkey'"==$'$pkey_index')  print NR }' $tablename) #row number
        
    #this condition is used to make sure that the updated date is for the right record
    if [ $((r_num)) -eq 0 ]
    then
        echo "
                      ^    
                    /_!_\  primary key does not exist"
    else
      #starting the update
      update_field
    fi
else
            echo
            echo  "
                      ^    
                    /_!_\  $tablename table does not exist"
            echo
fi













