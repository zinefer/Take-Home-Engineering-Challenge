# Take Home Engineering Challenge

## :oncoming_taxi: triphelper.nyc
![Build Status](https://travis-ci.com/zinefer/Take-Home-Engineering-Challenge.svg?branch=master)

I am going to use Ruby and Rails on this project due to the extreme time constraint. Rails will allow me to leverage a ton of web application convention to speed up my development. However, 3 hours is not much time to put all the skills I've gained over the past 8 years on display. As such, I am going to relax these of my development processies for this challenge:

- Third party code should be audited for activity, number of issues and any of _their_ dependancies to determine project health before including them in your own work
  - Gems will not be scrutinized as hard as if this was a real project
- Rubocop is a great tool to enforce consistent style across the project without taking time away from constructive code review
  - Complexity metrics will be disabled to save time

However, in this project I am still aiming to provide:

- Clear, consistent, commented and DRY code
- A functional interface
- Reasonable code coverage
- CI

Other Decisions that I'd like to point out:

- I like minitest over rspec
- I usually use Bootstrap but I want to try out [Bulma](https://bulma.io) for this challenge
- I tried using the Ruby CSV built-in but the data wasn't strict enough. I tried the smarter_csv gem but it left some features to be desired.

### Branding

- [Color palette](https://coolors.co/ffdd57-fe5f55-d6d1b1-c7efcf-eef5db)
- [Fonts](https://fonts.google.com/specimen/Baloo+Bhai?selection.family=Baloo+Bhai|Roboto)

## Setup

`Rails v5.2.3` `Ruby v2.5.3` `Bundler v2.0.1`

- Clone repository
- Install bundler

```bash
$ bundle install
$ rails db:create db:setup
```

### Seeding

You can seed the database with a presampled set of January 2018 data by just running

```bash
$ rails db:seed
```

#### Or

If you want to do a full data import or sample it yourself, place your `csv` files inside `db/data`. A `taxi+_zone_lookup.csv` is required and expected. Trip data file names should be formatted like `{trip_type}_tripdata_{year}_{month}.csv`

Then, use the `db:seed:data` task to parse and import:
```bash
$ rails db:seed:data
```

To sample the data, define a `TRIPDATA_SAMPLE` environment variable:
```bash
$ rails db:seed:data TRIPDATA_SAMPLE=10000
```

## Run

### Application

```bash
$ rails s
```

### Testing

```bash
$ rubocop
$ brakeman
$ rails test
$ rails test:system
```

Running the system tests on a Windows (WSL) machine requires a little bit of hoop jumping:
- Comment out webdrivers in Gemfile
  - The WSL is a little too good at hiding the fact that we're on windows, so it's a difficult to detect inside the gemfile. Thinking about it now I wonder if we could look for a windows specific file on the FS to detect this.
- Follow [This](http://ngauthier.com/2017/09/rails-system-tests-with-headless-chrome-on-windows-bash-wsl.html)

## Going further

- Dry out models and controllers
- Test the hash outputs of the CSV parser
- Click on values in the table to put them in the filter box
- Graph each type as a different series
- Test the charts in system tests
- Sort table columns
- Dry out Search index with a FormBuilder
- Add Drop off day and time filter