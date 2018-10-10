# mlrMBO-Webservice Server

## What is this?
We provide mlrMBO as a Webservice.
This server wraps the R package `mlrMBO` along with some software management software written in Python in order to handle multiple users simultanously.
We expose a REST-API, which is documented in the file API_DOCS.md.
You can use any REST client to access the API, but we also implemented an easy to use R package to go along with it.

## Do I have to run my own server?
Since we want you to have the best user experience, we are currently running an open, free-for-all server at `https://rombie.de:5001`.
You may use that as much as you wish.
If you're having performance problems, consider running your own server.
How to do that is documented in the next section.

## How do I run my own server?
It's simple!
The `image` folder contains a Docker image with everything you need.
You can just run the `rebuild-server.sh` script and it will create a docker image, which you can upload to a server somewhere.
It exposes port 5000, which will serve our `mlrMBO` API.

## May I use this software?
We provide both the server application as well as the reference client library as Open Source under the MIT license. This basically means you can use both the server and the client in open source and commercial projects.
