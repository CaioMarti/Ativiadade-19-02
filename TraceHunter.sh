#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo -e "\033[1;31m Este script precisa ser executado como root. \033[0m"
	exit 1
fi

COLLECTED_DIR="collected_files"
mkdir -p "$COLLECTED_DIR"


echo -e "\033[1;35m Coletando arquivos do sistema \033[0m"

echo -e "\033[1;95m Listando informações sobre discos e partições \033[0m"

lsblk >> $COLLECTED_DIR/disk_info.txt

echo -e "\033[1;95m Coletando informações de rede \033[0m"
 
ss >> $COLLECTED_DIR/active_connections.txt
netstat >> $COLLECTED_DIR/open_ports.txt

echo -e "\033[1;95m Coletando listas de processos \033[0m"

ps aux >> $COLLECTED_DIR/process_list.txt


# Coletar Registros do Sistema

echo -e "\033[1;95m Coletando logs do sistema \033[0m"
 
cp -r /var/log/syslog $COLLECTED_DIR/syslog.log
cp -r /var/log/auth.log $COLLECTED_DIR/auth.log
cp -r /var/log/dmesg $COLLLECTED_DIR/dmesg.log


echo -e "\033[1;95m Coletando arquivos de configuração \033[0m"

cp -r /etc $COLLECTED_DIR/backup/


echo -e "\033[1;95m Listando o diretório raiz \033[0m"

ls -l / >> $COLLECTED_DIR/root_dir_list.txt


HOSTNAME=$(hostname)

DATAHORA=$(date +"%Y_%m_%d_%H_%M_%S")

tar -czf "TraceHunter_${HOSTNAME}_${DATAHORA}.tar.gz" $COLLECTED_DIR
