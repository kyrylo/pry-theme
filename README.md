![Pry Theme][logo]

* [https://github.com/kyrylo/pry-theme/][pt]

Description
-----------

Pry Theme is a plugin for [Pry][pry], which helps you to customize your Pry
colors via `prytheme` files.

Installation
------------

All you need is to install the gem. The `pry-theme` plugin will be detected and
used automatically.

    gem install pry-theme --pre

Synopsis
--------

### Theme files

Theme file is a valid YAML file, which has `.prytheme` extension (for example,
`beautiful.prytheme`). Pry Theme ships only with two themes: `pry-classic` and
`pry-modern`. In order to set up the desired theme, add the following line into
your `.pryrc`:

    Pry.config.theme = "theme-name"

The default theme is `pry-classic` (basically, you won't notice it, because
it copies the default outlook of Pry, just as you didn't install anything).
Let's change it to something more neoteric:

    Pry.config.theme = "pry-modern"

That's all! Launch your Pry and you will see the changes.

### CLI

Pry Theme has a command-line interface available via Pry. Just launch Pry and
start working with it. For example, you can _temporary_ change themes on the
fly:

    [1] pry(main)> pry-theme pry-classic

This will switch your current theme to `pry-classic`.

### Creating themes

It's not easy now, so let's just skip this paragraph :P

### Adding new themes

Theme files must have `.prytheme` extension.

* On GNU/Linux

    Put your theme file in `$XDG_CONFIG_HOME/pry-theme` directory. 

* On Mac OS

    Put your theme file in `$HOME/Library/Application Support/pry-theme` directory. 

And don't forget to adjust your `.pryrc`!

Limitations
-----------

Basically, it will run on any terminal that is capable of displaying 256 colors,
but with a couple of admonishments.

### OS support

* GNU/Linux;
* Mac OS (I hope so, leastwise);

I don't plan to support Windows, because I can't even find a sane terminal for
it. Sorry, Windows guys. If want me to change my mind, you have to file an
issue.

### Ruby versions

* MRI 1.9.3
* MRI 1.9.2
* MRI 1.8.7
* REE 1.8.7-2012.02
* JRuby 1.6.7

Under the hood
--------------

Basically, Pry Theme is nothing but a CodeRay color scheme with a human-readable
syntax.

License
-------

The project uses Zlib License. See LICENSE file for more information.

[pt]: https://github.com/kyrylo/pry-theme/ "Home page"
[logo]: http://img-fotki.yandex.ru/get/5107/98991937.a/0_7c6c8_871a1842_orig "Pry Theme"
[pry]: https://github.com/pry/pry/ "Pry's home page"
