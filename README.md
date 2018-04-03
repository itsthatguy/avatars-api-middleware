# adorable-avatars
[![Build Status](https://travis-ci.org/adorableio/avatars-api.svg?branch=master)](https://travis-ci.org/adorableio/avatars-api?branch=master)

## What is it?
This repository contains the [express middleware](https://expressjs.com/en/guide/using-middleware.html#middleware.router) that can be used to host your own avatars service!

Check out [our website](http://avatars.adorable.io/) for more info on (and an interactive demo of) what this service does.

## How do I use it?
First, you'll need to install the package:

```bash
npm install adorable-avatars --save
```

Then, use the router middleware within your application:

```js
// your_server.js
var express = require('express');
var avatarsMiddleware = require('adorable-avatars');

var myApp = express();
myApp.use('/myAvatars', avatarsMiddleware);
```

That's it! Your server now includes the avatars endpoints!

### Endpoints
Assuming your server lives at `myserver.com`, and you've configured the middleware as above, you now have the following endpoints:

* `myserver.com/myAvatars/:id`
    * returns an avatar for the provided `id`.
    * `id` can be anything (email, username, md5 hash, as long as it's a valid URI)
    * defaults to 400px
* `myserver.com/myAvatars/:size/:id`
    * returns an avatar for the provided `id` at the specified `size`
    * size cannot exceed 400px
* `myserver.com/myAvatars/face/:eyes/:nose/:mouth/:color`
    * Allows you to generate a custom avatar from the specified parts and color
    * e.g. `myserver.com/myAvatars/face/eyes1/nose2/mouth4/DEADBF`
* `myserver.com/myAvatars/list`
    * returns JSON of all valid parts for the custom endpoint above

## Development
If you're developing locally, you'll first need to bootstrap (assumes [nvm](https://github.com/creationix/nvm)):

```bash
# use correct node version
nvm use

# install dependencies
npm install
```

Then, there are several npm scripts that will be useful:

```bash
# run the unit tests
npm run test

# run a dev server
npm run start

# run both a dev server and eslint
npm run dev

# compile the application
npm run build

# run the compiled server
npm run start:prod
```

## Contributing

Please read the [contributors' guide](CONTRIBUTING.md)

## Open-source Contributors

* [missingdink](https://twitter.com/missingdink): Illustrated the very first avatars! [Check them out!](http://api.adorable.io/avatar/hi_mom)
