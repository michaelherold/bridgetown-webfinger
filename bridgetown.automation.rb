# frozen_string_literal: true

URL_EXTRACTOR = /^\s*url[\s(]["'](?<url>[^'"]+)["']/

def has_content?(file, regexp)
  return false unless File.exist?(file)

  File
    .readlines(file)
    .find(nil) { |line| line.match?(regexp) }
end

template = <<~TEMPLATE
  webfinger:
    # Aliases are URIs that represent the same person
    aliases:
      # - https://twitter.com/myaccount

    # Links are resources related to this account
    links:
      # - href: https://example.com/myphoto.png
      #   rel: http://webfinger.net/rel/avatar
      #   type: image/png
TEMPLATE

add_bridgetown_plugin "bridgetown-webfinger"

say_status(:configuring, "url")

if !(url_line = has_content?("config/initializers.rb", URL_EXTRACTOR))
  url = nil

  loop do
    url = ask("\nWhat is the URL of your site (e.g. https://example.com)?")

    if url.empty?
      say "Please enter a URL", :red
    elsif !(url = URI.parse(url)).is_a?(URI::HTTP)
      say "Please use a http:// or https:// prefix", :red
    else
      break
    end
  end

  ruby_configure "URL in initializers", %(url "#{url}")
else
  url = url_line.match(URL_EXTRACTOR).then { |m| URI.parse(m[:url]) }

  say("Already configured as #{url}, skipping", :yellow)
end

say_status(:configuring, "initializer")

if !has_content?("config/initializers.rb", /^\s+init.*bridgetown-webfinger/)
  say(<<~MSG)

    When running a static website, bridgetown-webfinger can only return a single
    author's Webfinger response. If you host a multi-author site and wish to enable
    Webfinger for all authors, you will need to run a Bridgetown server to serve
    at minimum the Webfinger requests.

  MSG

  if (dynamic = no?("Are you hosting a static website? (Y/n)"))
    say(<<~MSG)

      By default, Webfinger requests SHOULD be accessible to the world unless you
      are hosting a private directory.

    MSG

    if yes?("Do you need to limit the origins that can access Webfinger? (y/N)")
      say(<<~MSG)

        See https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Allow-Origin
        for more information.

      MSG

      allowed_hosts = ask("What origins do you want to limit to?")
      allowed_hosts = "allowed_hosts: #{allowed_hosts.inspect}"
    end
  end

  parts = ["static: #{!dynamic}", allowed_hosts].tap(&:compact!)

  add_initializer "bridgetown-webfinger", ", #{parts.join(", ")}"
else
  say(
    "Already configured initializer, skipping",
    :yellow
  )
end

say_status(:configuring, "authors")

if has_content?("src/_data/authors.yml", /[[:space:]]+webfinger:/)
  say("Already configured author, skipping", :yellow)
elsif File.exist?("src/_data/authors.yml")
  say(<<~MSG)

    You already have an authors.yml. For each author in that file, you will
    need to insert a webfinger section like the one below:

    #{template}
  MSG
else
  author = ask("What is the account name of your main author?") until author && !author.empty?

  create_file "src/_data/authors.yml" do
    <<~YAML
      ---
      # This account will be represented as acct:#{author}@<your host>
      #{author}:
        #{template.gsub(/^[[:blank:]]{2}/, "    ")}
    YAML
  end
end
