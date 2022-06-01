# cleanLinux

Ao baixar o arquivo de todas as permissões para ele
`sudo chmod -R 777 cleanLinux.sh`

Depois rode o arquivo como sudo
`sudo ./cleanLinux.sh`

Este arquivo apagar todos os arquivos de logs, temporários, apaga as bases que fica na pasta cloud-db e apaga também o debug.txt!
Este arquivo limpa os repositórios e o APT.

caso queira limpar o cache da memório RAM execute os comandos abaixo:
`sudo su`
`echo 3 > /proc/sys/vm/drop_caches`
