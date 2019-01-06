# Jennifer + Spider-Gazelle sample application

This is a project presenting efficient integration of [Jennifer](https://github.com/imdrasil/jennifer.cr) ORM and [Spider-Gazelle](https://spider-gazelle.net) web framework.

This project is inspired by [Ruby on Rails Tutorial sample application](https://bitbucket.org/railstutorial/sample_app_4th_ed).

## Getting Started

To get started with the app, clone the repo and then install the needed dependencies:

```shell
$ cd /path/to/repos
$ git clone git@github.com:imdrasil/spider-gazelle_jennifer_sample_app.git
$ cd spider-gazelle_jennifer_sample_app
$ shards
$ make setup
```

The last command copies `./config/database.yml.example` to `./config/database.yml`. All database parameters are located in `./config/database.yml` - complete them with your own values.

Next do the database setup.

```shell
$ make sam db:setup
```

This will automatically create development database, run all migrations and populate seeds.

To start a dev server run in a separate console tabs next commands:

```shell
$ make server
$ make webpack
```

### NOTES

Spider-Gazelle has own url builder (e.g. `ClientsController.show(@client.id)`) but controllers and views have cross dependencies. To keep everything simple, all routes are hardcoded in `RouterHelper` module.

### Dependencies

This is the lists of top-level application dependencies.

* [action-controller](https://github.com/spider-gazelle/action-controller) - ActionController library which is a core component of Spider-Gazelle web framework used to build this application;
* [jennifer](https://github.com/imdrasil/jennifer.cr) - ORM with DB migrating tool;
* [sam](https://github.com/imdrasil/sam.cr) - task/script manager (is used only for some commands - Amber provides own CLI);
* [pg](https://github.com/will/crystal-pg) - PostgreSQL driver;
* [carbon](https://github.com/luckyframework/carbon) - email library;
* [form_object](https://github.com/imdrasil/form_object) - library provides Form Object pattern - allows to move all parameter parsing and data validating logic outside of models and controllers;
* [pager](https://github.com/imdrasil/pager) - simple pagination library;
* [view_model](https://github.com/imdrasil/view_model.cr) - View-Model layer - allows to encapsulate all view-related logic in a separate classes and brings HTML helper methods.
* [slang](https://github.com/jeromegn/slang) - template language;
* [http_method_emulator](https://github.com/imdrasil/http_method_emulator) - library to emulate all HTTP methods by sending method name in `_method` query parameter in `POST` request;
* [flash_container](https://github.com/imdrasil/flash_container.cr) - simple flash messages container.

#### Development dependencies

* [email_opener](https://github.com/imdrasil/email_opener) - opens all sent emails in a browser tab.

## Tests

TBA

## TODO

* [ ] implement "Remember me* using cookies
* [ ] cover functionality with tests
* [ ] 404 and 500 pages; "rescue from" functionality

## Contributing

1. Fork it ( https://github.com/imdrasil/test/fork )
2. Create your feature branch ( `git checkout -b my-new-feature` )
3. Commit your changes ( `git commit -am 'Add some feature'` )
4. Push to the branch ( `git push origin my-new-feature` )
5. Create a new Pull Request

## Contributors

- [imdrasil](https://github.com/imdrasil) Roman Kalnytskyi - creator, maintainer
