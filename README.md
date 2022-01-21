# stavdnb_infra
stavdnb Infra repository
##HW-10 ansible-1
____

## В ДЗ сделано:
____

    1. При повторном использовании ansible-playbook , мы увидели были ли проведены изменения.
    ```
    PLAY RECAP ****************************************************************************************************************
appserver                  : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```
    2. Для задания со * установлена s3cmd для работы с Yandex Object Storage, jq для того чтобы распарсить полученные с файла terraform.tfstate значения
    2.1.Для настройки используем 
https://cloud.yandex.ru/docs/storage/tools/s3cmd

    3. Упаковываем в скрипт ,делаем исполняемым  и запускаем. 
    3.1. меняем в ansible.cfg строку inventory на наш inventory.json .

    
##HW-09 terraform-2
____

## В ДЗ сделано:
____


    1. Выполнены основные условия по ДЗ;
    
    
    2. С помощью Packer созданы образы reddit-app-base,reddit-db-base; 
    ```
    packer build -var-file=/Users/stavdnb/git/stavdnb_infra/packer/variables.json app.json
    
    packer build -var-file=/Users/stavdnb/git/stavdnb_infra/packer/variables.json db.json
    ```
    Чтобы использовать их , в модулях необходимо указать их получившийся image_name. 

    3. В модуле app публикуем переменную  { DB_IPADDR = var.db_ipaddr } и передаем в нее IP адрес сервера mongodb. 


    4. Проверяем и причесываем все конфиги **terraform fmt**, далее получаем модули terraform get 

    5. Описываем бэкэнд в ранее созданный бакет, и активируем provisioner в  **main.tf**
    ```
    resource "null_resource" "app" {
      count = var.enable_provision ? 1 : 0
      triggers = {
        cluster_instance_ids = yandex_compute_instance.app.id
      }
  ```
По умолчанию устанавливаем значение TRUE, при желании можно менять.
```
variable enable_provision {
  description = "Enable provision"
  default     = true

```


##HW-08 terraform-1
____

## В ДЗ сделано:
____


    1. Установлен terraform 0.12;
    ```
    brew install terraform@0.12
    ```
    2. Дополнен файл с исключениями .gitignore;
    ```
    *.tfstate
    *.tfstate.*.backup
    *.tfstate.backup
    *.tfvars
    .terraform/
    ```
    3. Для практики создан файл main.tf с описанием версии провайдера 0.35 и описанием требуемых instance ;
    4. Созданы файлы для входных и выходных переменных,добавлены файлы для автоподнятия сервиса reddit;
    5.Описаны переменные в файлах main.tf , lb.tf (для поднятия балансировщика YandexLoader)
    6.Для удобства балансировки используем переменную count
   ```
    yc load-balancer network-load-balancer list
+----------------------+---------------+-------------+----------+----------------+------------------------+--------+
|          ID          |     NAME      |  REGION ID  |   TYPE   | LISTENER COUNT | ATTACHED TARGET GROUPS | STATUS |
+----------------------+---------------+-------------+----------+----------------+------------------------+--------+
| enpt76sd3osuqeernnlc | reddit-app-lb | ru-central1 | EXTERNAL |              1 | enpd25pvel9mgnrtoti6   | ACTIVE |
+----------------------+---------------+-------------+----------+----------------+------------------------+--------+

 ~/ yc load-balancer target-group list
+----------------------+---------------------+---------------------+-------------+--------------+
|          ID          |        NAME         |       CREATED       |  REGION ID  | TARGET COUNT |
+----------------------+---------------------+---------------------+-------------+--------------+
| enpd25pvel9mgnrtoti6 | reddit-app-lb-group | 2022-01-11 19:18:12 | ru-central1 |            1 |
+----------------------+---------------------+---------------------+-------------+--------------+
```

##HW-06 cloud-testapp
____

## В ДЗ сделано:
____


    1. Установлен и настроен yc CLI для работы с аккаунтом Yandex Cloud;
    2. Создан инстанс с помощью CLI;
    3. Установлен на хост ruby, mongodb для работы приложения, деплой тестового приложения;
    4. Созданы bash-скрипты для установки на хост необходимых пакетов и деплоя приложения;
    5. Создан startup-сценарий init-cloud для автоматического деплоя приложения после создания хоста. Данные для проверки деплоя приложения:

```shell

testapp_IP=178.154.220.152
testapp_port=9292

```

## Основное задание

____

Созданы bash-скрипты для деплоя приложения:

    1. Скрипт install_ruby.sh содержит команды по установке Ruby;
    2. Скрипт install_mongodb.sh содержит команды по установке MongoDB;
    3. Скрипт deploy.sh содержит команды скачивания кода, установки зависимостей через bundler и запуск приложения.

Для создания инстанса используется команда:

```shell

yc compute instance create \
  --name reddit-app \
  --hostname reddit-app \
  --memory=4 \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
  --metadata serial-port-enable=1 \
  --ssh-key ~/.ssh/id_rsa.pub

```

## Дополнительное задание

____

Создан файл metadata.yaml (startup-сценарий init-cloud), используемый для provision хоста после его создания. Для создания инстанса и деплоя приложения используется команда (запускаем из директории где лежит metadata.yaml):

```shell

yc compute instance create \
  --name reddit-app \
  --hostname reddit-app \
  --memory=4 \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB \
  --network-interface subnet-name=otus-ru-central1-a,nat-ip-version=ipv4 \
  --metadata serial-port-enable=1 \
  --metadata-from-file user-data=./metadata.yaml

```

Подключение к хосту выполняем командой:

```shell

ssh yc-user@217.28.230.170

```
======
## HW-05 cloud-bastion
Для доступа по SSH к ВМ, необходимо сгенирировать ключ для пользователя appuser

ssh-keygen -t rsa -f ~/.ssh/appuser -C appuser -P ""  (-C login -Р passphrase)

### По условию ДЗ были созданы 2 ВМ  :

bastion_IP = 178.154.202.80
someinternalhost_IP = 10.128.0.10

Проверяем подключение

ssh -i ~/.ssh/appuser appuser@178.154.202.80

Для подключения по ssh к someinternalhost через одну команду необходимо:

     - создать файл  ~/.ssh/config

```
    Host bastion
    Hostname 178.154.202.80
    User appuser
    IdentityFile ~/.ssh/appuser

Host someinternalhost
    User appuser
    IdentityFile ~/.ssh/appuser
    ProxyCommand ssh -q bastion nc -q0 10.128.0.10 22
```
После чего подключаться можно по имени ssh someinternalhost

Если процедура не частая подключаться можно также и через IP адрес предварительно указав forwarding (-А) и подкидывая на хост свой приватный ключ (.ррк)
```
ssh-add ~/.ssh/appuser
```
```
ssh -A -t appuser@178.154.202.80 ssh 10.128.0.10
```


### Устанавливаем и настраиваем vpn server Pritunl

Логинимся

ssh bastion

Выполняем следующие команды

```
sudo tee /etc/apt/sources.list.d/pritunl.list << EOF
deb http://repo.pritunl.com/stable/apt focal main
EOF

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
sudo apt-get update
...

sudo apt install dirmngr gnupg apt-transport-https ca-certificates software-properties-common


wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -

sudo add-apt-repository 'deb [arch=amd64] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse'

apt install mongodb-org

apt install pritunl

systemctl enable mongod pritunl

sudo systemctl start mongod pritunl

```
### С помощью сервиса https://sslip.io/ регистрируем сертификат Let's Encrypt

```
sudo service pritunl stop
sudo wget https://bootstrap.pypa.io/get-pip.py
sudo python3 -m pip install certbot
sudo certbot certonly --standalone -d 178.154.202.80.sslip.io
sudo service pritunl start
sudo pritunl set app.server_cert "$(sudo cat /etc/letsencrypt/live/178.154.202.80.sslip.io/fullchain.pem)"
sudo pritunl set app.server_key "$(sudo cat /etc/letsencrypt/live/178.154.202.80.sslip.io/privkey.pem)"
```
transfer
