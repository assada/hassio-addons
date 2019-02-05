# Mopidy addon for hass.io

## Audio player for Home Assistant

This addon for hass.io add audio playing capability to the host.
Mopidy is built with those extensions :

- Mopidy-Moped
- Mopidy-GMusic
- Mopidy-Local-SQLite
- Mopidy-SomaFM
- Mopidy-Scrobbler

Also you can setup telegram bot for managing your local library! See instructions below...

The local media can be stored on external storage(hdd/sdd/flash). Storage will be automated mounted to `/share/storage/` Follow [instructions below](https://github.com/assada/hassio-addons/tree/master/mopidy/README.md#external-storage) for setup external storage support.

Mopidy listen on `6680` for http connection, and `6600` for mpd ones.

## Configuration
##### local_scan (bool)
If it is set to true, a local scan is performed on startup.

##### options (list of dict)

The base mopidy configuration contains only :
```cpp
[core]
cache_dir = /data/mopidy/cache
data_dir = /data/mopidy/data_dir

[local]
media_dir = /share/mopidy/media
library = sqlite

[m3u]
playlists_dir = /share/mopidy/playlists

[http]
hostname = 0.0.0.0

[mpd]
hostname = 0.0.0.0

[somafm]
encoding = mp3
quality = highest

[scrobbler]
username = alice
password = secret
```

To add other options, or overwrite existing ones, you need to add them as elements in this list. Each item must be a dict with a "name" and a "value" element.
They will be added on the mopidy call as -o name=value
For exemple, to overwrite the media configuration to use share,
```json
{"name": "local/media_dir", "value": "/share/media"}
```
will become
````
-o local/media_dir=/share/media
````

#### Google Music support
To get the GMusic addon working add this to your options section:
```json
{
   "name": "gmusic/username",
   "value": "YourUserName"
},
{
	"name": "gmusic/password",
	"value": "ApplicationPassword"
}
```

You can generate your application password as described [here](https://support.google.com/accounts/answer/185833?hl=en).

Other options are available, check [the official doc](https://github.com/mopidy/mopidy-gmusic#configuration) for the complete list


#### LastFM support
To get the LastFM addon working add this to your options section:
```json
{
   "name": "scrobbler/username",
   "value": "YourUserName"
},
{
  "name": "scrobbler/password",
  "value": "YourPassword"
}
```

#### Telegram Downloader
https://github.com/assada/tg-music-downloader  
This is telegram bot can download mp3 files which you send to him or download audio from youtube/soundcloud links to your local library.
_Note: Telegram bot api supports files with size < 50MB_


#### External storage
All devices from `/dev` path on host are available in addon filesystem from `/devices` path. Its mounted to `/share/storage` path.
To use this, specify the `mount.disk` parameter in the config. Also you can suggest the filesystem type by specifying `mount.filesystem` parameter. (By default its try to detect filesystem automatically)
**Important!** After (re)connect devices you must to restart the addon. **NTFS filesystem does not support! See [issue](https://github.com/assada/hassio-addons/issues/1)**

#### Complete example
This a working configuration example, with Google Music and local scan.

```json
{
  "local_scan": false,
      "mount": {
        "enabled": false,
        "disk": "/devices/sda1",
        "filesystem": "auto",
        "point": "/share/storage"
      },
      "telegram": {
        "enabled": false,
        "token": "",
        "admin": "userName",
        "destination": "/share/storage/telegram"
      },
  "options": [
    {
      "name": "local/media_dir",
      "value": "/share/storage/telegram/"
    },
    {
      "name": "local/library",
      "value": "sqlite"
    },
    {
      "name": "local-sqlite/enabled",
      "value": "true"
    },
    {
      "name": "m3u/playlists_dir",
      "value": "/share/mopidy/playlists/"
    },
    {
      "name": "gmusic/username",
      "value": "<email>"
    },
    {
      "name": "gmusic/password",
      "value": "<password>"
    },
    {
      "name": "gmusic/deviceid",
      "value": "<device_id>"
    },
    {
      "name": "scrobbler/username",
      "value": "<username>"
    },
    {
      "name": "scrobbler/password",
      "value": "<password>"
    },
    {
      "name": "scrobbler/enabled",
      "value": "true"
    },
    {
      "name": "somafm/dj_as_artist",
      "value": "false"
    }
  ]
}
```
### License

This is open-sourced software licensed under the [MIT license](https://opensource.org/licenses/MIT).

### Contributing

Before sending a Pull Request, be sure to review the [Contributing Guidelines](CONTRIBUTING.md) first.
