##Сборник Docker контейнеров для установки через SSH на Xiaomi router be7000

Предварительные действия:

Нужен жесткий диск/флешка.
   Объем - чем больше тем лучше 64GB+.
   Если носитель энергоемкий, может потребоватся дополнительное питание.
Форматируем в формат ext4 (благо в интернете инструкций полно - ищите сами кто не знает как).
Подключаем флешку к роутеру. Активируем Docker в web-интерфейсе.
Устанавливаем скрипт для старта Docker, на случай если роутер его не запустит:

· Предварительно скопируйте скрипты в /data/auto

```bash
chmod +x /data/auto/auto_docker.sh
/data/auto/auto_docker.sh install
```

[Пример, как можно добавитьувеличить CPU/MEM для работы Docker на 4pda.](https://4pda.to/forum/index.php?showtopic=1070166&view=findpost&p=138176875)

1. Прописываем путь к исполняемому файлу, чтобы его можно было запускать из либой дирректории:

· Предварительно скопируйте скрипты в /data/auto

```bash
chmod +x /data/auto/docker_path_fix.sh
/data/auto/docker_path_fix.sh
```
· Перезаходим по SSH для вступления изменений в силу.

Отключаем плагин авторизации Docker'a:
```bash
sed -i 's/default allow = false/default allow = true/g' /tmp/run/docker/opa/authz.rego
```

Скрипт для создания каталогов в /mnt/usb-***:

```bash
chmod +x /data/auto/mkd.sh
```

Создадим папку для данных будущих контейнеров:

```bash
/data/auto/mkd.sh APPDATA
```

1. Установка Portainer [описание контейнера](https://hub.docker.com/r/portainer/portainer-ce):

```bash
docker run -d -p 9000:9000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer-ce:latest
```

2. Установка AdguardHome [описание контейнера](https://hub.docker.com/r/adguard/adguardhome):

Создать папки:

```bash
/data/auto/mkd.sh APPDATA/AdguardHome/work
/data/auto/mkd.sh APPDATA/AdguardHome/conf
```

```bash
export USB_PATH=$(find /mnt -maxdepth 1 -type d -name 'usb-*' | head -n 1) 
 docker run --name adguardhome --restart unless-stopped\
  -v $USB_PATH/APPDATA/AdguardHome/work:/opt/adguardhome/work\
  -v $USB_PATH/APPDATA/AdguardHome/conf:/opt/ adguardhome/conf\
  -p 20053:53/tcp -p 20053:53/udp -p 5443:5443/tcp -p 5443:5443/udp\
  -p 20080:80/tcp -p 20443:443/tcp -p 20443:443/udp -p 3000:3000/tcp\
  -p 853:853/tcp -p 784:784/udp -p 853:853/udp -p 8853:8853/udp\
  -d adguard/adguardhome
```

3. Установка Transmission [описание контейнера](https://hub.docker.com/r/linuxserver/transmission):

· Предварительно создайте папки на стороне роутера:

```bash
/data/auto/mkd.sh share/transmission/config
/data/auto/mkd.sh share/downloads
/data/auto/mkd.sh share/watch
```

```bash
export USB_PATH=$(find /mnt -maxdepth 1 -type d -name 'usb-*' | head -n 1)
 docker run -d\
  -e PUID=0 -e PGID=0 -e TZ=Etc/UTC\
  -p 9091:9091 -p 51413:51413 -p 51413:51413/udp\
  --name transmission --restart=unless-stopped\
  -v $USB_PATH/share/transmission/config:/config\
  -v $USB_PATH/share/downloads:/downloads\
  -v $USB_PATH/share/watch:/watch\
  linuxserver/transmission:latest
```

4. Установка FileBrowser [описание контейнера](https://hub.docker.com/r/filebrowser/filebrowser):

```bash
export USB_PATH=$(find /mnt -maxdepth 1 -type d -name 'usb-*' | head -n 1)
 docker run -d\
  --name filebrowser --restart always\
  -p 8181:80\
  -v $USB_PATH:/srv\
  filebrowser/filebrowser:latest
```
>* Пароль для входы необходимо посмотреть в логе контейнера.

5. Установка Torrserver [описание контейнера](https://hub.docker.com/r/ksey/torrserver):

```bash
export USB_PATH=$(find /mnt -maxdepth 1 -type d -name 'usb-*' | head -n 1)
 docker run -d -p 8090:8090\
  --name torrserver --restart=unless-stopped\
  -v $USB_PATH/APPDATA/torrserver/db:/TS/db\
  ksey/torrserver:latest
```

· если сервер вылетает, используйте SSD и настройте cache на диск.