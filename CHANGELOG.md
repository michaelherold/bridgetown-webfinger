# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0](https://github.com/michaelherold/bridgetown-webfinger/tree/v0.1.0) - 2023-02-25

### Added

- Static file support for rendering a `.well-known/webfinger` file that always responds with the same information.
- Dynamic support via a Roda plugin for handling multiple authors and proper filtering for `rel` filters. This includes the ability to set `Access-Control-Allow-Origin` headers via the `allowed_hosts` option.
- Validation of all Webfinger properties and printed warnings for invalid values to help ensure you write interoperable Webfinger properties.
- An automation to quickly bootstrap your site's Webfinger capabilities.
