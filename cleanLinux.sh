#!/bin/bash
#------------------------------------------------------------------
# Autor	:	Diniz
# Nome	:	cleanLinux.sh
# Data	:	01/06/2022
# Info  :       ShellScript para limpeza do sistema
#------------------------------------------------------------------

echo "Limpando Cache e Swap…"
sudo sysctl -w vm.drop_caches=3
sudo swapoff -a && swapon -a
clear
echo "Limpeza do Cache e Swap efetuada com sucesso!"

echo "Limpando APT"
sudo apt-get clean -y
sudo apt-get autoclean -y
sudo apt-get autoremove --purge -y
sudo apt clean -y
sudo apt autoclean -y
sudo apt autoremove --purge -y
clear
echo "Limpeza do APT efetuada com sucesso!"

echo "Limpando pasta TMP e LOGS"
sudo rm -rf /var/tmp/*

echo "Removendo os arquivos de bases e o debug.txt..."
sudo rm -Rf /home/cloud-db/*.sql
sudo rm -Rf /var/log/debug.txt

echo "Excluindo a pasta GPUCache..."
sudo rm -Rf /home/$(whoami)/GPUCache

function LINHAS(){
for i in `seq 1 50`
do
   echo -n "="
done
echo -e "\n"
}

function LIMPAR(){

echo -e "\nOs seguintes arquivos fora encontrados: \n"
echo -e  "=============================================\n"
sed -n 'p' $log

if [ -s $log ];then
   echo -e  "\n============================================="
   echo -ne "\nDeseja remover os arquivos listados? [ s ou n ]:  "
   read opcao
   case $opcao in
      's')
      clear   
      while [ $cont -lt  $num ] 
      do
         comando=$cont"p"
         arquivo=`sed -n $comando $log`
         echo -e "\n"
         rm -rf "$arquivo"
         echo -e "\n"
         cont=`expr $cont + 1`
      done
      
      LINHAS
      echo -e "\t     Operação concluída! \n"
      LINHAS
      rm -rf $log
      killall -9 $(basename $0) 2>/dev/null
      ;;

      'n')
      clear
      LINHAS
      echo -e "\t   Operação cancelada......\n"
      LINHAS
      rm -rf $log
      exit
      ;;

      *)
      clear
      echo -e "\n====> '$opcao' não é uma opção válida. <====\n\n"
      LIMPAR
      ;;
   esac
else
   clear
   LINHAS
   echo -e "\tNenhum arquivo temporário encontrado.\n"
   LINHAS
   sudo rm -rf $log
fi
}

if [ $(whoami) != "root" ]; then
echo -e   """\n
==================================================
Caso você execute o aplicativo como usuário comum, 
somente será possível excluir arquivos temporários 
onde seu usuário tem permissão.
==================================================\n
"""

echo -n "Deseja executar como root? [ s ou n ]: "
read opt

if [ $opt == "s" ]; then
   su root -c `which $(basename $0)`
else if [ $opt == "n" ];then
   continue
else
   echo "Opção Inválida...."
   exit
fi
fi
fi

clear
echo "Procurando arquivos temporários..."

log="/tmp/temps.log"
procurar=$(find / -iname "*.tmp" -o -iname "*.xz" > $log 2> /dev/null)
num=`wc -l $log | awk '{print $1}'`
num=`expr $num + 1`
cont=1

LIMPAR
