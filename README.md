# Grapcha

This app is an experiment of using gravatar images as captcha. The idea grew from
login page we've built for [VividCortex](http://vividcortex.com) after reading
[this very article by GoSquared](https://www.gosquared.com/blog/login-screen-behind-the-scenes).

It's really great idea to show [Gravatar](http://gravatar.com) from just typed email, but why not go one
step forward and use it as a CAPTCHA? That's what Grapcha tries to do, it generates
11 random gravatars and displays it alongside with user's one. Now what user should
do is to click on his Gravatar in order to get logged in.

![The future of CAPTCHA](http://i.imgur.com/6bBoEiH.jpg)

## Quirks

Idea is not perfect though. First of all, not everyone is using Gravatar, in this case
it depends on you what to do, you can either force users to use gravatars or fallback
them to recaptcha.

There's also case of disabled people, you'll obviously not recognize your avatar when
you're blind or have other problems with sight.

## Getting started

To get started with the app just clone the repo and install dependencies.

    $ git clone git://github.com/nu7hatch/grapcha.git
    $ cd grapcha
    $ bundle install

To run tests execute:

    $ rspec spec

If tests are passing, you can start the server:

    $ foreman start

## API

Application's API exposes two endpoints: '/new' and '/validate'. First is used to create
a captcha state in current session, second's job is to validate it. Here's how they work:

### `GET /new`

Creates captcha state.

**Query params:**

* `email` - The email address to be validated.

**Possible responses:**

* `200` - Captcha has been created.
* `400` - Given email is invalid or no gravatar found for it.

**Examples:**

Request with valid email address.

    $ curl -i http://localhost:5000/new?email=chris@nu7hat.ch
    HTTP/1.1 200 OK
    Content-Type: application/json;charset=utf-8
    Content-Length: 421

    ["8c5a0ef36b90782eba5f8f416dad1715",...,"1b0232c8d568435ad6d92476cf1b93e5"]

Request with fake email not having a gravatar.

    $ curl -i http://localhost:5000/new?email=fake@veryfakemail.com
    HTTP/1.1 400 Bad Request
    Content-Type: application/json;charset=utf-8
    Content-Length: 56

    {"error":"Gravatar not found for fake@veryfakemail.com"}

### `GET /validate`

Checks if user selection was valid.

**Query params:**

* `avatar` - The gravatar hash of selected avatar.

**Possible responses:**

* `200` - Chosen avatar was correct.
* `400` - Invalid avatar has been chosen.

**Example:**

Correct avatar choosen.

    $ curl -i http://localhost:5000/validate?avatar=16c772a254c53065066116ccd04ae146
    HTTP/1.1 200 OK
    Content-Type: application/json;charset=utf-8
    Content-Length: 16

    {"success":true}    

Invalid avatar specified.

    $ curl -i http://localhost:5000/validate?avatar=16c772a254c53065066116ccd04ae147
    HTTP/1.1 400 Bad Request
    Content-Type: application/json;charset=utf-8
    Content-Length: 52

    {"error":"Chosen avatar doesn't seem to be correct"}
    
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new *Pull Request*
