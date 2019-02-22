#!/bin/bash
#requiere 2 argumentos -1 la ruta a la carpeta devops del repo del squad -2 ambiente en el que se va a crear los configmaps
# ej: ./env2cm.sh /home/usr/repo/sq-cross/devops int

ENV="$2"
cd $1

MS=$(ls -d cap-* | grep -v "\-qa" | grep -v "\-commons\-")
echo $MS
#crea archivo secrets vacio
for i in $MS; do touch $i/"$ENV"/secrets ; done

# transforma los envs en configmaps
for i in $MS; do cut -d " " -f5- $i/"$ENV"/environment | tr " " "\n" | grep -v "from=secret" | sed 's/"//g' > $i/"$ENV"/configmap && rm $i/"$ENV"/environment ; done

# si encuentra amquser o datagriduser en el cm agrega el secret en el file y elimina la linea
for i in $MS; do if [ ! -z $(grep amquser  $i/"$ENV"/configmap) ]; then sed -i '/amquser/d' $i/"$ENV"/configmap && sed -i '/4mqu53r/d'  $i/"$ENV"/configmap && echo "amq" >> $i/"$ENV"/secrets; fi  ; done
for i in $MS; do if [ ! -z $(grep datagriduser  $i/"$ENV"/configmap) ]; then sed -i '/datagriduser/d' $i/"$ENV"/configmap && sed -i '/d4t4gr1du53r/d'  $i/"$ENV"/configmap && echo "datagrid" >> $i/"$ENV"/secrets; fi  ; done

# agrega el secret de mongo, pero no elimina el row del cm porque posiblemente la contraseña es un dato que se repite TODO
for i in $MS; do if [ ! -z $(grep usr_pom_cap_desa  $i/"$ENV"/configmap) ]; then echo "mongo" >> $i/"$ENV"/secrets; fi  ; done
