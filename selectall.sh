#! /bin/bash
if      [ `cat ~/databases/$connect_db/$tablename | wc -l` -eq 3 ]
        then
                echo "This Table is empty"
        else
                awk -F: '{if (NR>3) print $0}' $tablename
        fi