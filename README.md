# Instalação e Configuração do Servidor Nginx

Este projeto implementa a instalação e configuração de um servidor Nginx virtualizado no Ubuntu 22.04.1 Live Server ARM64 utilizando o VirtualBox em um processador Apple M1 (ARM).

## Objetivo

Subir um servidor Nginx, mantê-lo em execução e utilizar scripts para validar automaticamente se o serviço está online.

## Requisitos

- Maquinas com processador baseado em arm da família Apple M.

## Softwares Utilizados

- **VirtualBox**: Versão 7.1.0 r164728 (Qt6.5.3)
- **Ubuntu**: 22.04.1 live-server
- **Nginx**

## Instruções

### 1. Montagem da Máquina Virtual (VM)

- Abra o VirtualBox e selecione a opção "Novo".
- Preencha as informações solicitadas:
  - Nome: Ubuntu Server
  - ISO: Ubuntu 22.04.1 live-server
- Defina quantidade de memória ram e quantidade de núcleos dedicados.
- Crie um disco rígido virtual do tamanho, aqui usaremos 10GB (formato VHD, tamanho dinâmico).
- Configure a rede para "Placa em modo Bridge" utilizando sua interface de rede.

### 2. Instalação do Ubuntu Server

- Selecione a opção "Try or Install Ubuntu".
- Configure o idioma e teclado.
- Escolha "Ubuntu Server".
- Configure a rede e ajuste as opções de proxy conforme necessário.
- Siga as etapas de particionamento de disco e finalize a instalação.

### 3. Instalação do Nginx

Após a instalação do sistema operacional, siga os passos abaixo para instalar e configurar o Nginx:

1. Adicione seu usuário ao grupo `sudo`:

   ```bash
   sudo usermod -aG sudo seu_usuario
   sudo reboot
   ```
2. Atualize os repósitorios:

  ```bash
  sudo apt update
  sudo apt upgrade
  ```
3. Instale o nginx: 

  ```bash
  sudo apt install nginx
  ```

### 4. Criação de Script de Monitoramento
Um script deve ser criado para monitorar se o serviço Nginx está ativo e registrar seu status em arquivos de log.

1. Crie os diretórios e os arquivos de log:

  ```bash
  mkdir ~/nginx_project
  mkdir ~/nginx_project/logs
  touch ~/nginx_project/logs/nginx_online.log
  touch ~/nginx_project/logs/nginx_offline.log
  chmod 755 ~/nginx_project/logs/*
  ```
2. Crie o script `nginx_monitor.sh`

  ```bash
  nano ~/nginx_project/nginx_monitor.sh
  ```
3. Cole o seguinte conteúdo no script:

  ```sh
  #!/bin/bash

  LOG_DIR=~/nginx_project/logs

  if systemctl is-active --quiet nginx; then
    STATUS_MESSAGE="$(date '+%d-%m-%Y %H:%M:%S') O serviço nginx está em execução - Nginx - ONLINE"
    echo "$STATUS_MESSAGE" >> "$LOG_DIR/nginx_online.log"
    echo "$STATUS_MESSAGE" >> "$LOG_DIR/nginx_status.log"
  else
    STATUS_MESSAGE="$(date '+%d-%m-%Y %H:%M:%S') O serviço nginx não está em execução - Nginx - OFFLINE"
    echo "$STATUS_MESSAGE" >> "$LOG_DIR/nginx_offline.log"
    echo "$STATUS_MESSAGE" >> "$LOG_DIR/nginx_status.log"
  fi
  ```
4. Dê permissão ao script:

  ```bash
  chmod 775 ~/nginx_project/nginx_monitor.sh
  ```

### 5. Agendamento com Cron:
Agende o script para ser executado automaticamente a cada 5 minutos usando o cron:

1. Edite o `cron`:

  ```bash
    crontab -e
  ```
2. Adicione a linha abaixo:

  ```bash
  */5 * * * * /home/user/nginx_project/nginx_monitor.sh
  ```
3. Reinicie a VM para garantir a execução dos comandos.

## Documentação Básica

### Comandos Principais

`ip -4 a`: Verifica o numero IPv4 das interfaces de rede.

`sudo systemctl start nginx`: Inicia o nginx.

`sudo systemctl stop nginx:`: Para o nginx.

`sudo systemctl status nginx:`: Verifica o status.

`cat ~/nginx_project/logs/nginx_online.log`: Abre o arquivo de log de eventos online.

`cat ~/nginx_project/logs/nginx_offline.log`: Abre o arquivo de log de eventos offline.

`cat ~/nginx_project/logs/nginx_status.log`: Abre o arquivo de log do histórico completo de status do nginx.

### Estrutura de Arquivos

A estrutura de diretórios do projeto após a criação e configuração será semelhante à seguinte:


- **nginx_project/**: Diretório principal do projeto.
- **logs/**: Pasta onde os arquivos de log serão armazenados.
  - **nginx_online.log**: Registra quando o Nginx está online.
  - **nginx_offline.log**: Registra quando o Nginx está offline.
  - **nginx_status.log**: Histórico completo do status do Nginx (online/offline).
- **nginx_monitor.sh**: Script responsável por verificar o status do Nginx e salvar nos logs.

## Passos Adicionais Não Obrigatórios

Nesta seção, você encontrará informações sobre a troca do arquivo `index.html` padrão do Nginx. Essa alteração não é obrigatória, mas pode ser útil se você desejar personalizar a página inicial do seu servidor.

### Como Trocar o `index.html` Padrão do Nginx

1. **Localize o arquivo `index.html` padrão**:  

   O arquivo padrão do Nginx geralmente está localizado em:

    ```bash
   /var/www/html/index.html
    ```
2. **Faca backup do arquivo original (opcional)**:

  Antes de fazer alterações, é uma boa prática fazer um backup do arquivo original:

  ```bash
  sudo cp /var/www/html/index.html /var/www/html/index.html.bak
  ```
3. **Crie ou edite o novo `index.html`**:

  Você pode criar um novo arquivo index.html,copiar um arquivo html existente para o diretório com o nome index ou editar o existente usando um editor de texto. Por exemplo, para editar com o nano:

  ```bash
  sudo nano /var/www/html/index.html
  ```
4. **Reinicie o nginx**:

  ```bash
  sudo systemctl restart nginx
  ```
## Para Leigos

**Instruções Adicionais do Projeto**

Junto aos arquivos do meu projeto, estarei incluindo um PDF intitulado **"Manual de instalação Nginx.Linux.VM.pdf"**, que contém instruções detalhadas e prints sobre como criar a máquina virtual e instalar o Linux e o Nginx. Este PDF inclui os códigos utilizados no terminal do Linux para a instalação do Nginx, o código usado no script de validação da disponibilidade do servidor, além de capturas de tela que ilustram o processo de instalação do Linux e a criação da máquina virtual. Essas informações visam facilitar a compreensão e a execução das etapas necessárias para configurar o ambiente do projeto.
