![Pry Theme][logo]

* [https://github.com/kyrylo/pry-theme/][pt]

Warning
=======

The project is in its infancy, so do expect bugs.

Description
-----------

Pry Theme is a plugin for [Pry][pry], which helps you to customize your Pry
colors via `prytheme` files.

Installation
------------

All you need is to install the gem. The `pry-theme` plugin will be detected and
used automatically.

    gem install pry-theme

Synopsis
--------

### Configuration file

Pry Theme ships only with two themes: `pry-classic` and `pry-modern`. In order
to set up the desired theme, add the following line to your `.pryrc`:

    Pry.config.theme = "theme-name"

The default theme is `pry-classic` (basically, you won't notice it, because
it copies the default outlook of Pry, withouth the plugin). Let's change it to
something more neoteric:

    Pry.config.theme = "pry-modern"

That's all! Launch your Pry and you will see the changes.

### CLI

Pry Theme has a command-line interface via Pry. Currently, it can't do much. The
only thing you can do is to switch themes on the fly. Start Pry and type the
following:

    % pry --simple-prompt
    >> pry-theme pry-classic

We just temporary changed our current theme to `pry-classic`.

### Creating themes

It's not easy now, so let's just skip this paragraph :P

### Adding new themes

Theme files should have `.prytheme` extension. All theme files should be in
`$XDG_CONFIG_HOME/pry-theme` directory. Don't forget to change your `.pryrc`!

Limitations
-----------

* GNU/Linux (in future will support other popular platforms);
* CRuby 1.9.3 (in future will support other implementations).

License
-------

The project uses Zlib License. See LICENSE file for more information.

[pt]: https://github.com/kyrylo/pry-theme/ "Home page"
[logo]: http://img-fotki.yandex.ru/get/5107/98991937.a/0_7c6c8_871a1842_orig "Pry Theme"
[pry]: https://github.com/pry/pry/ "Pry's home page"
