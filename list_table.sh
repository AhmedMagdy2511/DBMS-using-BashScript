#! /bin/bash
echo
echo  "===============Tables==============="
echo
if [ $(ls  | wc -l) == 0 ]
then     
    echo  "No Table Found"
    echo 
    echo "****************************************"
    
else
    ls 
    echo
    echo "***************************************"
fi