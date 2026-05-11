# Parcel Wing Ruby Example App

A tiny Sinatra app that demonstrates sending a test email with the official `parcelwing` Ruby SDK.

## What it includes

- Sinatra web server
- Official `parcelwing` Ruby SDK
- Lightweight custom CSS
- Browser form for entering your API key, sender, recipient, subject, and body
- Optional `.env` values for repeat local testing

## Requirements

- Ruby 3.1 or newer
- Bundler
- A Parcel Wing API key. Get a free key [here](https://parcelwing.com/signup)
- A verified sending domain in Parcel Wing

## Quick start

```bash
bundle install
bundle exec rackup -p 4567
```

Then open:

```text
http://localhost:4567
```

Paste your Parcel Wing API key, fill in the sender and recipient fields, and send a test email.

## Environment variables

Copy the example file:

```bash
cp .env.example .env
```

Then edit values as needed:

```bash
PARCELWING_API_KEY=pw_live_your_api_key_here
PARCELWING_BASE_URL=https://parcelwing.com
PARCELWING_FROM="Parcel Wing <hello@yourdomain.com>"
PARCELWING_TO=you@example.com
PORT=4567
```

The app still lets you override these values in the browser. API keys are only used by the local server for the current request and are not stored by the app.

## Testing before the Ruby SDK gem is published

If you have the SDK repo next to this example repo:

```text
parcelwing-repos/
├── parcelwing-ruby/
└── parcelwing-ruby-example/
```

Install dependencies using the local SDK path:

```bash
PARCELWING_RUBY_PATH=../parcelwing-ruby bundle install
bundle exec rackup -p 4567
```

Once the SDK is published to RubyGems, you can use the default `Gemfile` behavior with:

```bash
bundle install
```

## Project structure

```text
.
├── public
│   └── styles.css
├── views
│   └── index.erb
├── app.rb
├── config.ru
├── .env.example
├── .gitignore
├── Gemfile
├── LICENSE
└── README.md
```

## How it works

The browser posts the form to this local Sinatra server. The server creates a `ParcelWing::Client` and calls:

```ruby
client.emails.send(
  from: "Parcel Wing <hello@yourdomain.com>",
  to: "you@example.com",
  subject: "Hello from Parcel Wing + Ruby",
  html: "<strong>It works!</strong>"
)
```

The response panel shows the queued email response or any validation/API errors returned by Parcel Wing.
