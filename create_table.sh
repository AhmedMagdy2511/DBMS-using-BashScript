#! /bin/bash
#this file is to create the table and the coulmns inside it with its data type (int,string,date)
echo
echo "===============create table==============="
echo "Enter table name want to create : "
read  -r  tbname
echo
#this loop is cheacking the validation of the name
while [[ -z $tbname ]] || [[ $tbname == *['!''@#/$\\"*{^})(+|,;:~`._%&/=-]>[<?']* ]] || [[ $tbname =~ [0-9] ]]

do          
            echo  "
              ^    
            /_!_\  Invalid Input"
            echo
            echo "PLease Enter table Name Again: "
            read -r tbname
                         
done
#--------------------------------------------------------------------------------------------------------------------------------------

#this condition is used to validate the table name
if [ -f $tbname ] #check_existance
then
        echo "
          ^    
        /_!_\ Table $tbname already exists!!"
        create_table.sh
else
        #array for columns names
        declare -a values
        #array for data types 
        declare -a types 
        
        counter=0 #index of the currrent column
        pkeycounter=-1 #

#--------------------------------------------------------------------------------------------------------------------------------------
        select add in addcolumn exit
        do 
            case $add in
                addcolumn )
                    echo "Please enter column name and data types below!"
                    
                    #read the column name
                    echo "column name: "
                    read -r columnname

                    #read the data type
                    read -p "Data type (int or str or date): " dattypea
                    
                
                    #this condition is used to make sure that the data type is intered correctly
                    if [[ $dattypea == int || $dattypea == str || $dattypea == date ]] #correct data type
                        then
                        #this condition is used to make sure that the primary key is assigned
                        if [ $pkeycounter -eq  -1 ] #no pk inserted
                            then
                            read -p "do you wanna make this attribute primary key!?( 'y' for yes 'n' for no ): " answer
                            case $answer in
                                [Yy]* ) 
                                        #saving the column name in the column array
                                        values[$counter]="$columnname:"
                                        #saving the data type of the column in the data type array
                                        types[$counter]="(p)$dattypea:"
                                        #saving the primary key column by saving the column number in the array primary key index
                                        let pkeycounter=$counter
                                        #incremanting the counter to countine reading
                                        let counter=$counter+1
                                            ;;
                                [Nn]* ) 
                                        #saving the column name in the column array
                                        values[$counter]="$columnname:"
                                        #saving the data type of the column in the data type array
                                        types[$counter]="$dattypea:"
                                        #incremanting the counter to countine reading
                                        let counter=$counter+1
                                            ;;
                                *) 
                                        echo " 
                                          ^    
                                        /_!_\ Please, press y or n"
                                    ;;
                                esac

                        else #there is pk 

                            #saving the column name in the column array
                            values[$counter]+="$columnname:"
                            #saving the data type of the column in the data type array
                            types[$counter]+="$dattypea:"
                            #incremanting the counter to countine reading
                            let counter=$counter+1
                        fi #end of data saving

                    else
                        echo " 
                                      ^    
                                    /_!_\ Wrong data type!"
                    fi #end of data type condition
                    ;;
                #exiting the column inseartion
                exit)
                    break
                ;;
                *)
                    echo " 
                              ^    
                            /_!_\ Wrong choice"
                ;;
            esac
        done    
#--------------------------------------------------------------------------------------------------------------------------------------
#this function is used to make sure that the table have primary key    
function pkey_fun {
    if [ $pkeycounter -eq -1 ]
    then
        echo "Ouch! You forgot to specify pkey! please select the index of your primary key: "
        echo ${values[@]} #printing all of the array (all columns names)
        read x
        re='^[0-9]+$'
        if [[ $x =~ $re && $x -le $counter-1 ]] #check if index is integer and within values array range
        then
        types[$x]="(p)${types[$x]}"
        let pkeycounter=$x
        else
            echo " 
                      ^    
                    /_!_\ Table wrong index please try again! "
            pkey_fun
        fi
    fi
}
        pkey_fun
#-------------------------------------------SAVING THE DATA -------------------------------------------------------------------------------------------
#creating table
touch $tbname
#creating meta data file
touch .$tbname.meta
#adding the number of columns
echo $counter >  .$tbname.meta #number of columns
#adding the primary key index
echo $pkeycounter >> .$tbname.meta #pk index
#adding the columns datatypes
printf %s "${types[@]}" $'\n' >> .$tbname.meta
#adding the colmns names
printf %s "${values[@]}" $'\n' >> .$tbname.meta

echo "Your Table created Successfully"
fi
