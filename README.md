# good_migrations

[![Build Status](https://travis-ci.org/testdouble/good-migrations.svg?branch=master)](https://travis-ci.org/testdouble/good-migrations)

This gem prevents Rails from auto-loading app code while it's running migrations,
preventing the common mistake of referencing ActiveRecord models from migration
code.

## Usage

Add good_migrations to your gemfile:

``` ruby
gem 'good_migrations'
```

And you're done! That's it.


## Background

Over the life of your [Ruby on Rails](http://rubyonrails.org) application, your
app's models will change dramatically, but according to the [Rails
guides](http://guides.rubyonrails.org/active_record_migrations.html#changing-existing-migrations), your migrations _shouldn't_:

> In general, editing existing migrations is not a good idea. You will be
creating extra work for yourself and your co-workers and cause major headaches
if the existing version of the migration has already been run on production
machines. Instead, you should write a new migration that performs the changes you
require.

That means that if your migrations reference the ActiveRecord model objects
you've defined in `app/models`, your old migrations are likely to break. That's
not good.

By adding this gem to your project's `Gemfile`, autoloading paths inside `'app/'`
while running any of the `db:migrate` Rake tasks will raise an error, explaining
the dangers inherent.

Some will reply, "who cares if old migrations are broken? I can still run `rake
db:setup` because I have a `db/schema.rb` file". The problem with this approach
is that, so long as some migrations aren't runnable, the `db/schema.rb` can't
be regenerated from scratch and its veracity can no longer be trusted. In
practice, we've seen numerous projects accumulate cruft in `db/schema.rb` as the
result of erroneous commits to work-in-progress migrations, leading to the
development and test databases falling out of sync with production. That's not
good!

For more background, see the last section of this blog post on [healthy migration
habits](http://blog.testdouble.com/posts/2014-11-04-healthy-migration-habits.html)

## Options

There's no public API to this gem. If you want to work around its behavior, you
have a few options:

1. Run the command with the env var `GOOD_MIGRATIONS=skip`
2. Explicitly `require` the app code you need in your migration
3. Remove the gem from your project

## Acknowledgements

Credit for figuring out where to hook into the ActiveSupport autoloader goes
to [@tenderlove](https://github.com/tenderlove) for [this
gist](https://gist.github.com/tenderlove/44447d1b1e466a28eb3f).

## Caveats

Because this gem works by monkey-patching the ActiveSupport auto-loader, it will
not work if your Rails environment (development, by default) is configured to
eager load your application's classes (See:
[config.eager_load](http://edgeguides.rubyonrails.org/configuring.html#rails-general-configuration).
