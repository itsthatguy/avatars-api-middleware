# adorable-avatars

## What is it?

Adorable Avatars is an interface to a better universe. With a simple route,
your face will be filled with consistently-linked avatar glory!

_Consistently-linked avatar glory_ What?

Whenever you make a request to Adorable Avatars, using a string like
"abott@adorable.io," we give you an image for you to use on your page. Most
importantly, it's the same image! Every. Single. Time.

## Why would I use it?

## How do I use it?

### Setup

1. Clone this repo
2. Install dependencies: `npm install`
3. Start the server: `npm start`

### Requesting an Avatar

The most basic request is of the following form:

    http://localhost:3002/avatar/<somestring>

Where `somestring` is the identifier for your user (name, email, md5, etc.).
This will serve the image in its default size.

To request an avatar with specific dimensions, use the following form:

    http://localhost:3002/avatar/<dimensions>/<somestring>

Where `dimensions` specifies the width and height, e.g. "300x300" or "400x200."

So, if you want your friend Bob's avatar, with a width of 640px and a height of
480px, the URL would be:

    http://localhost:3002/avatar/640x480/bob
