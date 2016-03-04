# Index

1. Introducction
2. Hardware needed
3. Software needed
4. First steps
  4.1 Preamble
  4.2 Create trakt.tv account and configure
  4.3 (Optional) Create SHOWRSS account and configure
5. Create directory structure
6. Install and configure Transmission
7. Install and configure Kodi
8. Install and configure Flexget
9. Mobile applications

# Introducction

This guide is intended for people who like to watch TV shows and movies via Kodi mediacentre on the TV. You will no pay anything using services described here. After you finish this guide, you will be able to select the TV shows or movies that you want to watch and the system will search and download for you, in the quality that you want, and ping you when is ready to see.

The tipical workflow would be:

1. I want to see "The Flash" TV show in my mediacentre connected to my TV.
2. Let's add the "The Flash" TV show in my HD watchlist in trakt.tv web application
3. After this, when my cronjob check my trakt.tv HD watchlist, it will see that I have a new TV show, so it will take the last released episode of "The Flash" and request to Transmission to download it.
4. Transmission daemon will start to download the new episode to a temporary directory and, when it finish, transmission will move the episode to Kodi series folder and ping Kodi to refresh its multimedia catalog.
5. Kodi now have a new episode to you in its catalog.
6. Open your Kore mobile application and play the new episode in your TV.

This is an open source guide, which means everyone is very welcome to contribute via merge requests in this repository.

This guide is based on https://www.raspberrypi.org/forums/viewtopic.php?t=47084 post, but I change some things and add some improvements.

# Hardware needed
You will need a Rapsberry Pi model B, connected to internet and HDMI cable connected to your TV.

# Software needed

1. Raspbian installed in your Rapsberry Pi. (https://www.raspbian.org/)
2. Transmission
3. Flexget
4. Kodi mediacentre

# First steps
## Preamble
This guide assumes that you already have Raspberry Pi and Raspbian OS installed and connected to Internet. Also, the username in Rapsberry PI in this guide will be "pi".

## Create trakt.tv account and configure
Track every TV show and movie you watch, automatically from your media center.

1. Go to https://trakt.tv/ and create a new account
2. Go to create new lists in https://trakt.tv/users/YOUR_TRAKT_USERNAME/lists. For TV shows we will manage 2 lists, HD and NOT-HD quality. So, create a list named "Following HD" and other list named "Following". For movies we will manage the default list named "Watchlist".
3. Now, explore trakt.tv website for your favourite TV shows and movies and add them to your lists. For example, you would add "Breaking Bad" TV show to "Following" list, "Game of Thrones" to "Following HD" list and "Deadpool" to "Watchlist" list.

## (Optional) Create SHOWRSS account and configure
This is a tool that makes it easier for you to track ongoing TV shows. Create a free account, pick your preferred shows and generate a feed link that you can then subscribe to.

1. Go to http://new.showrss.info and create a new account http://new.showrss.info/auth/register
2. Spend some time adding your favourite TV shows to your list.
3. After that, go to your feeds http://new.showrss.info/feeds and copy your custom feed address, because you will needed in next steps (configure Flex). It should looks like this: `http://showrss.info/user/YOUR_SHOWRSS_USER_ID.rss?magnets=true&namespaces=true&name=clean&quality=null&re=null`

# Create directory structure
Let's create the directory structure for your multimedia system. The goal is have a temporary directory to download the .torrent files, a temporary directory to download TV shows and movies, and the final destination for the videos. Also, we need a directory to save Flex configuration.

We assume that our home directory in our Rapsberry Pi is: /home/pi

1. `mkdir /home/pi/Downloads/torrents`
2. `mkdir /home/pi/Downloads/incomplete`
3. `mkdir /home/pi/Videos/series`
4. `mkdir /home/pi/Videos/peliculas`
5. `mkdir /home/pi/Downloads/flexget`

# Install and configure Transmission
Transmission (https://www.transmissionbt.com/) is a cross-platform open source BitTorrent client.

We will install transmission daemon in order to download the multimedia via bittorrent protocol. Also, we will configure (as extra feature) Transmission Web Server in order to be able to add torrents by ourselves via Web browser. All the commands above, should be executed in your Raspberry PI.

1. `sudo apt-get install transmission-daemon`
2. `sudo apt-get install transmission-cli`
3. `sudo apt-get install transmission-remote-cli`

## Transmission configuration
1. Backup of transmission config: `cp ~/.config/transmission/settings.json ~/.config/transmission/settings.json.backup`
2. sudo apt-get transmission-daemon stop
3. Download file transmission/settings.json (look in this repo) in your `~/.config/transmission/` directory (overwrite it in your raspberry pi).
4. Replace the values in your new `~/.config/transmission/settings.json`
5. sudo apt-get transmission-daemon start

You put your rpc-password in settings.json, but transmission has to encode it. For this, you have to access to transmission web server and type your rpc-password.

1. Open your PC browser and go to `http://YOUR_RASPBERRY_PI_IP_ADDRESS:9091`
2. Type your password

Now, your password has been successfully encoded in settings.json. More info here `http://superuser.com/a/113652`

# Install and configure Kodi
Kodi® (formerly known as XBMC™) (https://kodi.tv/) is an award-winning free and open source (GPL) software media center for playing videos, music, pictures, games, and more. Kodi runs on Linux, OS X, Windows, iOS, and Android, featuring a 10-foot user interface for use with televisions and remote controls. It allows users to play and view most videos, music, podcasts, and other digital media files from local and network storage media and the internet.

1. `sudo apt-get update`
2. `sudo apt-get install kodi`

# Kodi configuration

1. Install Trakt.tv plugin in order to sync your watch with trakt.tv web application. Doing this, trakt.tv will know which movies and episodes you already watch and keep your episodes and movies watchlist well scheduled.
2. Configure Kodi Webserver. See http://kodi.wiki/view/Webserver. The username and password that you set here, are needed in kodi/xbmc-upd.sh file which is explained in next section (Flexget configuration point 5).

# Install and configure Flexget
FlexGet (http://flexget.com/) is a multipurpose automation tool for content like torrents, nzbs, podcasts, comics, series, movies, etc. It can use different kinds of sources like RSS-feeds, html pages, csv files, search engines and there are even plugins for sites that do not provide any kind of useful feeds.

There are numerous plugins that allow utilizing FlexGet in interesting ways and more are being added continuously.

FlexGet is extremely useful in conjunction with applications which have watch directory support or provide interface for external utilities like FlexGet.

Flexget has its own database and keep sync which episodes you already downloaded.

## Flexget configuration
1. `sudo pip install flexget; flexget -V`
2. Download flexget/config.yml file to `~/Downloads/flexget/` directory.
3. Replace the values in some of the variables and save the file.
4. Download kodi/xbmc-upd.sh to your `/home/pi/` directory.
5. Set Kodi user and password and save.
6. Test your configuration (see below).

In the config.yml file you will see `"script-torrent-done-filename": "/home/pi/xbmc-upd.sh",` parameter. `xbmc-upd.sh` is executed when each torrent finish to download and what it does is refresh Kodi library. So, when each torrent finish, you will able to see the new episode/movie in your Kodi "recent items". More info here http://kodi.wiki/view/HOW-TO:Remotely_update_library

## Flex usefull commands
### Test your Flexget configuration file
`flexget -c /home/pi/Downloads/flexget/config.yml execute --test`
### Refresh Flexget cache
`flexget -c /home/pi/Downloads/flexget/config.yml execute --discover-now --no-cache`

## Setup cronjob
In order to check time to time if there is new episodes for our watching TV shows or movies, we have to configure a cronjob in our Raspberry PI to query trakt.tv web application.

In this guide, we schedule to query from 3 hours to 15 hours.

1. `crontab -e`
2. Paste this new line `0 3,6,9,12,15 * * * nice -n 4 /usr/local/bin/flexget -c /home/pi/Downloads/flexget/config.yml --cron execute`
3. Save

# Mobile applications
TODO
