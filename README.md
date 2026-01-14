## Сборник Docker контейнеров для установки через SSH на Xiaomi router be7000

### Предварительные действия:
1) Нужен жесткий диск/флешка. 
Объем - чем больше тем лучше 64GB+.
Если носитель энергоемкий, может потребоватся дополнительное питание.
2) Форматируем в формат ext4 (благо в интернете инструкций полно - ищите сами кто не знает как).
3) Подключаем флешку к роутеру.  Активируем Docker в web-интерфейсе.
4) Устанавливаем скрипт для старта Docker, на случай если роутер его не запустит:
>* Предварительно скопируйте скрипт в /data/auto
```bash
chmod +x /data/auto/auto_docker.sh
/data/auto/auto_docker.sh install
```
[Пример, как можно добавитьувеличить CPU/MEM для работы Docker на 4pda.](https://4pda.to/forum/index.php?showtopic=1070166&view=findpost&p=138176875)

5. Прописываем путь к исполняемому файлу, чтобы его можно было запускать из либой дирректории:
>* Предварительно скопируйте скрипт в /data/auto
```bash
chmod +x /data/auto/docker_path_fix.sh
/data/auto/docker_path_fix.sh
```


### Узнаем под каким именем диск примонтирован в системе пример usb-********.
```bash
cd /mnt
ls
```
Создадим папку для данных будующих контейнеров:
```bash
mkdir /mnt/usb-********/APPDATA
```

## 1.  Установка Portainer:
```bash
docker run -d -p 9000:9000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer-ce:latest
```

## 2. Установка AdguardHome:
Создать папки :
> usb-******** - заменить на свой
```bash
mkdir /mnt/usb-********/APPDATA/AdguardHome/work
mkdir /mnt/usb-********709d56/APPDATA/AdguardHome/conf
```

```bash
docker run --name adguardhome --restart unless-stopped -v /mnt/usb-********/APPDATA/AdguardHome/work:/opt/adguardhome/work -v /mnt/usb-********/APPDATA/AdguardHome/conf:/opt/adguardhome/conf -p 20053:53/tcp -p 20053:53/udp -p 20080:80/tcp -p 20443:443/tcp -p 20443:443/udp -p 3000:3000/tcp -p 853:853/tcp -p 784:784/udp -p 853:853/udp -p 8853:8853/udp -p 5443:5443/tcp -p 5443:5443/udp -d adguard/adguardhome
```
> usb-******** - заменить на свой

## 3. Установка Transmission:

```bash
docker run -d -e PUID=0 -e PGID=0 -e TZ=Etc/UTC -p 9091:9091 -p 51413:51413 -p 51413:51413/udp --name transmission --restart=unless-stopped -v /mnt/usb--********/share/transmission/config:/config -v /mnt/usb--********/share/downloads:/downloads -v /mnt/usb--********/share/watch:/watch linuxserver/transmission:latest
```
>* /mnt/usb--********/ -предварительно создайте папки на стороне роутера.

## 4. Установка FileBrowser:
```bash
docker run -d --name filebrowser --restart always -p АААА:80 -v /mnt/usb-********/:/srv filebrowser/filebrowser:latest
```

## 5. Установка Torrserver:
```bash
docker run -d -p 8090:8090 --name torrserver --restart=unless-stopped -v /mnt/usb-********/APPDATA/torrserver/db:/TS/db ksey/torrserver:latest
```
>* если сервер вылетает, используйте SSD и настройте `cache` на диск.