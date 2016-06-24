# adorable-avatars
[![Build Status](https://travis-ci.org/adorableio/avatars-api.svg?branch=master)](https://travis-ci.org/adorableio/avatars-api?branch=master)

## What is it?

#### What are avatars?
Avatars are earthly creatures that serve as proxies for gods.
In the web world, they just represent people, and they're usually small images. 

Some use photographs of themselves as their avatar. Some people use caricatures of themselves. Others pick their favorite superhero. The sky's the limit.

#### What's an avatar _service_?
It answers the question "What is this user's avatar?"
In this way, it provides a consistent representation of that user.
Across _all_ websites that use that service. Pretty cool, right?

But what if you haven't uploaded your image to that service?
Then you get a really boring, gray silhouette.

#### So what's the Adorable Avatars service?
It's an interface to a better universe. With a simple route, your face will be filled with consistently-linked avatar glory!

Huh? _Consistently-linked avatar glory?_

Whenever you make a request to Adorable Avatars, using an identifier like "abott@adorable.io," we give you an image for you to use on your page.
Most importantly, it's the same image! Every. Single. Time.

## Why would I use it?
What if you're developing a feature like member lists or profiles, but you don't have any images to use?
Just give us your user's identifier and we'll give you their avatar image!
That's it.

Already have avatars implemented in your application?
Use Adorable Avatars as a fallback and get rid of those gray silhouettes!

## How do I use it?
Here's a quick example in Haml:
```haml
.user
  %img.avatar(src="http://api.adorable.io/avatar/#{user.name}")
```

### Requesting an Avatar
The most basic request is of the following form:

    http://api.adorable.io/avatar/<identifier>

Where `identifier` is the unique identifier for your user (name, email, md5, etc.).
This will serve the image in its default size.

To request an avatar with specific size, use the following form:

    http://api.adorable.io/avatar/<size>/<identifier>

So, if you want your friend Bob's avatar, with a height and width of 200px, the URL would be:

    http://api.adorable.io/avatar/200/bob

## Contributing

Please read the [contributors' guide](CONTRIBUTING.md)

## Open-source Contributors

* [missingdink](https://twitter.com/missingdink): Illustrated the very first avatars! [/avatar/](http://api.adorable.io/avatar/hi_mom)
