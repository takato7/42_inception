#!/bin/bash

mariadb -uroot -hlocalhost --protocol=socket --database=mysql -e "SELECT 1" > /dev/null 2>&1
