# yolks

Docker image for Pterodactyl and Pelican eggs that runs a Node.js app and a MongoDB server in the same container. The other images from the original project are in [pelican-eggs/yolks](https://github.com/pelican-eggs/yolks).

## nodejs-mongodb

Image: `ghcr.io/fantinodavide/yolks:nodejs-mongodb`

| Component | Version |
|---|---|
| Node.js | 20 |
| MongoDB | 5.0 |

MongoDB starts before the egg's startup command and listens only on `127.0.0.1`. Its data is stored in `/home/container/mongodb_data`. When the app exits, MongoDB shuts down cleanly.

The MongoDB port depends on the container network:

| Network | MongoDB port |
|---|---|
| Host | The server's allocated port (`SERVER_PORT`) |
| Bridge | `27017` |

The startup script exports these variables to the app:

| Variable | Value |
|---|---|
| `MONGODB_PORT` | The port MongoDB listens on |
| `MONGODB_URI` | `mongodb://127.0.0.1:<MONGODB_PORT>` |

Set `MONGODB_QUIET` to `1` or `true` to hide MongoDB log output.

The image is rebuilt every Monday and on each change to `custom/nodejs-mongodb`.
