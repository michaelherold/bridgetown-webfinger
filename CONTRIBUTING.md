# Contributing

In the spirit of [free software](http://www.fsf.org/licensing/essays/free-sw.html), we encourage **everyone** to help improve this project. Here are some ways _you_ can contribute:

* Use alpha, beta, and pre-release versions.
* Report bugs.
* Suggest new features.
* Write or edit documentation.
* Write specifications.
* Write code (**no patch is too small**: fix typos, add comments, clean up inconsistent whitespace).
* Refactor code.
* Fix [issues].
* Review patches.

[issues]: https://github.com/michaelherold/bridgetown-webfinger/issues

## Submitting an Issue

We use the [GitHub issue tracker][issues] to track bugs and features. Before submitting a bug report or feature request, check to make sure no one has already submitted it.

When submitting a bug report, please include a `<details>` block that includes a stack trace and any details that may be necessary to reproduce the bug, including your gem version, Ruby version, and operating system. This looks like the following:

```markdown
<details>
<summary>A description of the details block</summary>

All of the content that you want in here, perhaps with code fences. Note that
if you only have a code fence in here, you _must_ separate it from the <summary>
tag and the closing </details> or it won't render correctly.

Notice the empty line here ↓

</details>
```

Ideally, a bug report should include a pull request with failing specs.

## Submitting a Pull Request

1. Fork the repository.
2. Create a topic branch.
3. Add specs for your unimplemented feature or bug fix.
4. Run `bundle exec rake test`. If your specs pass, return to step 3.
5. Implement your feature or bug fix.
6. Run `bundle exec rake`. If your specs or any of the linters fail, return to step 5.
7. Open `coverage/index.html`. If your changes are not fully covered by your tests, return to step 3.
8. Add documentation for your feature or bug fix.
9. Commit and push your changes.
10. Submit a pull request.

## Tools to Help You Succeed

After checking out the repository, run `bin/setup` to install dependencies. Then, run `bundle exec rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

Before committing code, run `bundle exec rake` to check that the code conforms to the style guidelines of the project, that all of the tests are green (if you're writing a feature; if you're only submitting a failing test, then it does not have to pass!), and that you sufficiently documented the changes.
