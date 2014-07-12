# adorable-avatars

## What is it?

Adorable Avatars is an interface to a better universe. With a simple route,
your face will be filled with consistently-linked avatar glory!

_Consistently-linked avatar glory_ What?

Whenever you make a request to Adorable Avatars, using an identifier like
"abott@adorable.io," we give you an image for you to use on your page. Most
importantly, it's the same image! Every. Single. Time.

## Why would I use it?
Adorable Avatars is great for, well, avatars.
When you're developing a feature like member lists or profiles, just give us your user's identifier and we'll give you their avatar image.
That's it.

Already have avatars implemented? Use Adorable Avatars as a fallback and get rid of those boring gray silhouettes!

## How do I use it?

### Setup

1. Clone this repo
2. Install dependencies: `npm install`
3. Start the server: `npm start`

### Requesting an Avatar

The most basic request is of the following form:

    http://localhost:3002/avatar/<identifier>

Where `identifier` is the unique identifier for your user (name, email, md5, etc.).
This will serve the image in its default size.

To request an avatar with specific dimensions, use the following form:

    http://localhost:3002/avatar/<dimensions>/<identifier>

Where `dimensions` specifies the width and height, e.g. "300x300" or "400x200."

So, if you want your friend Bob's avatar, with a width of 640px and a height of
480px, the URL would be:

    http://localhost:3002/avatar/640x480/bob
