# good_migrations

This gem prevents Rails from auto-loading app code while it's running migrations,
preventing the common mistake of referencing ActiveRecord models from migration
code.

## Usage

Add good_migrations to your Gemfile:

``` ruby
gem 'good_migrations'
```

And you're done! That's it.

## Prerequisites

This gem requires that your app uses either of these autoloader strategies:

* The classic `ActiveSupport::Dependencies` autoloader (e.g. `config.autoloader
  = :classic`), which is going away with Rails 7
* **Version 2.5 or higher** of the Zeitwerk autoloader (e.g. `config.autoloader =
  :zeitwerk`) If your app uses an earlier version of zeitwerk, you'll see a
  warning every time `db:migrate` is run

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

## Adding to an existing app

If you add this to an existing app where past migrations had this problem, then those
past migration will be failing.

You have 2 options:
* Rewrite those past migrations to not use external code
* Use the `permit_autoloading_before_date` configuration (see below) to permit autoloading for
  these older migrations

## Configuration

To configure, add those lines to an initializer (such as `config/initializers/config_good_migrations.rb`)
 
#### permit_autoloading_before_date configuration

```ruby
GoodMigrations::Configuration.permit_autoloading_before_date = "2021-06-01"
```

Migrations with timestamps (the numbers at the beginning of the file name)
from before this configured time will be allowed to perform autoloading, bypassing the mechanism of this gem. Accepts:
* nil: meaning never permit autoloading
* String accepted by `Time.parse`, such as '20211103150610', '20211103_150610' and '2021-01-01'
* object responding to `to_time`, such as Date and Time

## Working around good_migrations

You can explicitly `require` the app code that you need in your migration.

If needed, it is possible to run a command with `good_migrations` disabled by running the command with the env var `GOOD_MIGRATIONS=skip`.

## Acknowledgements

Credit for figuring out where to hook into the ActiveSupport autoloader goes
to [@tenderlove](https://github.com/tenderlove) for [this
gist](https://gist.github.com/tenderlove/44447d1b1e466a28eb3f).

## Caveats

Because this gem works by monkey-patching the ActiveSupport auto-loader, it will
not work if your Rails environment (development, by default) is configured to
eager load your application's classes (see:
[config.eager_load](http://edgeguides.rubyonrails.org/configuring.html#rails-general-configuration)).
