# Bridgetown Webfinger plugin

A [Bridgetown][1] plugin for handling [Webfinger][2] requests for the Fediverse and [IndieWeb][3].

Whether you run a single-author, statically rendered site or a multi-author site with a dynamic backend, this is your one-stop shop for Webfinger support.

This plugin allows for hosting Webfinger lookups on your website for [`acct:` URIs][4]. This is the first step to giving your site the ability to post to Fediverse apps like [Mastodon][5], [Pleroma][6], or [PeerTube][7]. While not all Fediverse apps use Webfinger, enough do that adding Webfinger support will be necessary to have your site participate in the Fediverse.

[1]: https://www.bridgetownrb.com
[2]: https://webfinger.net/
[3]: https://indieweb.org/
[4]: https://datatracker.ietf.org/doc/html/rfc2396
[5]: https://joinmastodon.org/
[6]: https://pleroma.social/
[7]: https://joinpeertube.org/

## Installation

Run this command to add this plugin to your site's Gemfile:

    bundle add bridgetown-webfinger

Or you can use [an automation script][8] instead for guided setup:

    bin/bt apply https://github.com/michaelherold/bridgetown-webfinger

[8]: https://www.bridgetownrb.com/docs/automations

## Usage

This plugin runs in one of two modes: static mode or dynamic mode.

Static mode is for when you run a single-author, fully static website without using any of Bridgetown's Server-Side Rendering (SSR) capabilities. It is mildly non-compliant with the Webfinger specification, but is an accepted practice for static sites.

Dynamic mode uses a Roda plugin to serve author data for all accounts defined in your `src/_data/authors.yml` file.

### Authors data file

Within your authors data file, each author requires a `webfinger` associative array with data about the account. For example, for the account `bilbo`, who has a Twitter account at `https://twitter.com/bilbobaggins` and hosts an avatar at `https://bagend.com/bilbo.png`, the authors data file entry might look like:

```yaml
# src/_data/authors.yml
---
bilbo:
  webfinger:
    aliases:
      - https://twitter.com/bilbobaggins
    links:
      - href: https://bagend.com/bilbo.png
        rel: http://webfinger.net/rel/avatar
        type: image/png
```

You may configure any number of authors in this way, however static mode works with only a single author.

### Static mode

To use static mode, configure your [authors data file](#authors-data-file) and add the following to your `config/initializers.rb` file:

```ruby
# config/initializers.rb
Bridgetown.configure do
  init "bridgetown-webfinger", static: true
end
```

Bridgetown will now generate a `.well-known/webfinger` file using your first author's information when building the site.

### Dynamic mode

To use dynamic mode, configure your [authors data file](#authors-data-file) and add the following to your `config/initializers.rb` file:

```ruby
# config/initializers.rb
Bridgetown.configure do
  init "bridgetown-webfinger", static: false, allowed_hosts: "*"
end
```

Then, add the `bridgetown_webfinger` plugin to your `RodaApp` and call the `bridgetown_webfinger` request method:

```ruby
# server/roda_app.rb
class RodaApp < Bridgetown::Rack::Roda
  plugin :bridgetown_ssr  # required
  plugin :bridgetown_webfinger
  
  route do |r|
    r.bridgetown_webfinger
  end
end
```

This generates a `.well-known/webfinger` route that serves `acct:` URI requests for authors on your site.

#### Allowed hosts

The [Webfinger specification][9] states that [servers must include the `Access-Control-Allow-Origin`][10] header to enable Cross-Origin Resource Sharing (CORS) requests and that they should use the least restrictive setting.

Unless you are hosting private Webfinger information — e.g. within a corporate network, to only authenticated followers, or for any other reason — you should set this to `"*"` using the configuration above.

If this is private information that you wish to restrict [set the header value appropriately][11].

[9]: https://datatracker.ietf.org/doc/html/rfc7033
[10]: https://datatracker.ietf.org/doc/html/rfc7033#section-5
[11]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Allow-Origin

## Contributing

So you're interested in contributing to Bridgetown Webfinger? Check out our [contributing guidelines](CONTRIBUTING.md) for more information on how to do that.
