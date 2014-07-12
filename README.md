# adorable-avatars

## What is it?

## How do I use it?

### Setup

1. Clone this repo
2. Install dependencies: `npm install`
3. Start the server: `npm start`

### Requesting an Avatar

The most basic request is of the following form:

  http://localhost:3002/avatar/<somestring>

Where "somestring" is the identifier for your user (name, email, md5, etc.).
This will serve the image in its default size.

To request an avatar with specific dimensions, use the following form:

  http://localhost:3002/avatar/<dimensions>/<somestring>

Where "dimensions" specifies the width and height, e.g. "300x300" or "400x200."

So, if you want your friend Bob's avatar, with a width of 640px and a height of
480px, the URL would be:

  http://localhost:3002/avatar/640x480/bob
