# good_migrations

This gem prevents Rails from auto-loading app code while it's running migrations,
preventing the common mistake of referencing ActiveRecord models from migration
code.

## Usage

Add `good_migrations` to your Gemfile:

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

If you add `good_migrations` to an existing application **and** any of those
migrations relied on auto-loading code from `app/`, then you'll see errors
raised whenever those migrations are run.

You have several options if this happens:

* If you're confident that every long-lasting environment has run the latest
  migrations, you could consider squashing your existing migrations into a
  single migration file that reflects the current state of your schema. This is
  a tricky procedure to pull off in complex apps, and can require extra
  coordination in cases where a high number of contributors are working on the
  application simultaneously. The
  [squasher](https://github.com/jalkoby/squasher) gem may be able to help.
* You can rewrite those past migrations to inline any application code inside
  the migration's namespace. One way to do this is to run migrations until they
  fail, check out the git ref of the failing migration so the codebase is
  rewound to where it was at the time the migration was written, and finally
  inline the necessary app code to get the migration passing before checking out
  your primary branch. Rewriting any migration introduces risk of the resulting
  schema diverging from production, so this requires significant care and
  attention
* If neither of the above options are feasible, you can configure the
  `good_migrations` gem to ignore migrations prior to a specified date with the
  [permit_autoloading_before](#permit_autoloading_before-configuration)
  option, which will effectively disable the gem's auto-loading prevention for
  all migrations prior to a specified time

## Configuration

To configure the gem, call `GoodMigrations.config` at some point as Rails is
loading (a good idea would be an initializer like
`config/initializers/good_migrations.rb`)

```ruby
GoodMigrations.config do |config|
  # Setting `permit_autoloading_before` will DISABLE good_migrations for
  # any migrations before the given time. Don't set this unless you need to!
  #
  # Accepts parseable time strings as well as `Date` & `Time` objects
  # config.permit_autoloading_before = "20140728132502"

  # Setting `load_error_message` will change error message that is be raised
  # if a migration attempts to autoload.
  # The %{attempted_path} format parameter is available to indicate the
  # path of the file that would have been autoloaded.
  # The default message is quite exhaustive, but this setting can be useful to
  # add a some information specific to your application at the end if you use `+=`.
  #
  # config.load_error_message = <<~MSG
  #   A migration tried to load this path: %{attempted_path}
  # MSG
end
```

## Working around good_migrations

The gem only prevents auto-loading, so you can always can explicitly `require`
the app code that you need in your migration.

If needed, it is possible to run a command with `good_migrations` disabled by
running the command with the env var `GOOD_MIGRATIONS=skip`.

## Acknowledgements

Credit for figuring out where to hook into the ActiveSupport autoloader goes
to [@tenderlove](https://github.com/tenderlove) for [this
gist](https://gist.github.com/tenderlove/44447d1b1e466a28eb3f). And thanks to
[@fxn](https://github.com/fxn) for implementing the hook necessary for zeitwerk
support to be possible.

## Caveats

Because this gem works by augmenting the auto-loader, it will not work if your
Rails environment (development, by default) is configured to eager load your
application's classes (see:
[config.eager_load](http://edgeguides.rubyonrails.org/configuring.html#rails-general-configuration)).
