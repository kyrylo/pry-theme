Pry Theme changelog
===================

### master

### v1.2.0 (January 16, 2016)

* **IMPORTANT:** dropped support for Ruby <2.0
  ([#51](https://github.com/kyrylo/pry-theme/pull/51))
* Started depending on stock JSON library (no more dependency on the `json` gem)
  ([#49](https://github.com/kyrylo/pry-theme/pull/51))
* Fixed warnings on Ruby 2.4.0+ with regard to Fixnum
  ([#50](https://github.com/kyrylo/pry-theme/pull/51))

### v1.1.3 (July 21, 2014)

* Re-fixed broken behaviour of Pry. It's a temporary hack, to be removed on the
  new Pry release [→](https://github.com/kyrylo/pry-theme/issues/40)
  [→](https://github.com/kyrylo/pry-theme/issues/42)

### v1.1.2 (June 16, 2014)

* Fixed broken behaviour when the Pry Rescue plugin isn't installed along with
  Pry Theme [→](https://github.com/kyrylo/pry-theme/issues/40)

### v1.1.1 (June 14, 2014)

* Fixed error message when `theme_options` is not set at
  all. [→](https://github.com/kyrylo/pry-theme/issues/41)

### v1.1.0 (June 13, 2014)

* Added `theme_options` config hash. It is a general config for Pry Theme
* Added option that enables painting hash keys as symbols.
  [→](https://github.com/kyrylo/pry-theme/issues/30)

  ```ruby
  {foo: 1, :bar => 2}
  #  ^       ^
  #  |       |
  # key    symbol
  ```

  By default `foo` and `bar` have different colours. If you put this inside your
  `.pryrc`, then the key will have the same colour as the symbol.

  ```ruby
  Pry.config.theme_options = {:paint_key_as_symbol => true}
  ```

### v1.0.3 (May 12, 2014)

* Fixed error when Pry.config.theme is set to a theme that doesn't exist
  [→](https://github.com/kyrylo/pry-theme/issues/39)
* Corrected README.md errors and confusing parts

### v1.0.2 (January 28, 2014)

* Set stricter dependencies (namely, Pry Theme started demanding CodeRay v1.1.0
  or higher)

### v1.0.1 (November 18, 2013)

* Fixed `pry-theme convert` and `pry-theme colors`

### v1.0.0 (November 13, 2013)

* **IMPORTANT**: This version is incompatible with CodeRay 1.0.9 and lower
* Fixed CodeRay 1.1.0 support

### v0.2.0 (March 26, 2013)

* **HOT**: Added Windows support
* **NOT SO HOT**: The plugin was rewritten from scratch
* The plugin works everywhere where you can launch Pry
* Improved `vim-detailed` theme
* Added support for 16 colour themes
* Introduced the new theme syntax
* Lots of rewordings, improvements of help messages
* Added fallback mode. It is useful when you are running Pry on poor terminals
  and trying to use a 256 colour theme. It is quite numpty, though.
* Converted switches to subcommands
* Added basic tab completion for installed themes
* Added support for italic font. Does not work eveywhere. For example, I use
  urxvt and it does support italic fonts.
* **NOT BAD**: Added a bunch of new themes

    * pry-monochrome
    * pry-modern-256 (old `pry-modern`)
    * pry-classic-256 (old `pry-classic`; default theme on 256 colour capable
      terminals)

    Including Windows friendly themes:

    * pry-classic-16 (default theme on Windows)
    * pry-classic-8
    * pry-zealand-16 (greenish)
    * pry-zealand-8
    * pry-love-16 (redish)
    * pry-love-8
    * pry-sibera-16 (bluish)
    * pry-sibera-8
    * pry-tepid-16 (yellowish)
    * pry-tepid-8
    * pry-modern-16
    * pry-modern-8
* And probably something else. I could forget something!

And do not forget to check out [the new CLI][cli]!

### v0.1.3 (September 21, 2012)

* Improved integration with [pry-rescue][prescue] plugin.

### v0.1.2 (August 31, 2012)

* Removed uninstaller. Actually, adding it, was a terrible idea. Remove theme
  files by hand, from now on.

### v0.1.1 (August 1, 2012)

* Fixed bug in `--test` command not displaying current theme name;
* Added new Pry Theme attributes: `escape`, `inline_delimiter` and `char`;
* Amended output of `--test` command in order to reflect new attributes.

### v0.1.0 (July 23, 2012)

* **HOT**: Boosted the load speed of the plugin:

  Before:
  ![Before](http://img-fotki.yandex.ru/get/6405/98991937.b/0_7f768_24d92170_orig)

        % time pry -e 'exit'
        0.75s user 0.06s system 94% cpu 0.847 total

  After:
  ![After](http://img-fotki.yandex.ru/get/6400/98991937.b/0_7f767_7c1ad4e9_orig)

        % time pry -e 'exit'
        0.69s user 0.04s system 94% cpu 0.773 total

* **WARM**: added `--edit` command (`-e`). `-e` brings new experience in
  creating themes. With this command you can create and edit themes, both. For
  example, you can create a new theme like this: `pry-theme -e +my-theme`. Check
  out [a wiki entry][cli] for more information;

* **TEPID**: improved `--color` command (`-c`). In this version `-c` can
  understand HEX, RGB, ANSI and human-readable colors. Interested in how to use
  it? Check out [Pry Theme CLI][cli] article in wiki;

* Added [Pry Theme Cheatsheet][cheatsheet] to Pry Theme Wiki;
* Fixed output for `--all-colors`, `--test`, `--list` and `--remote--list`. It
  was hard-coded to `$stdout`, so therefore, when it wasn't `$stdout`,
  information would be printed in the wrong place;
* Fixed duplicate colors 86:aquamarine03 and 122:aquamarine03;
* Fixed a bug when a user doesn't specify `Pry.config.theme` and tries to run
  `pry-theme -l`, which results in a TypeError;
* Added two new 8-color default themes for a users with limited terminals:
  "vim-default" and "vim-detailed";
* Changed output for `--test`: it's more terse and concise now;
* Changed output for `--list`, because the older one looked really silly;
* Removed some spurious attributes for `.prytheme` files;
* Fixed the name of theme "saturday".

### v0.0.10 (July 07, 2012)

* Themes can use any color from 256-color palette as background color. Before
  this release you could use only 8 colors;
* Changed command flag `--list --remote` to `--remote-list`. Now, to get a list
  of themes from Pry Theme Collection, you type `pry-theme -r` or
  `pry-theme --remote-list` instead of `pry-theme -lr`;
* Limited theme descriptions to 80 characters;
* Added "content" subparameter for "string" parameter (`.prytheme` syntax).
* Changed the appearance of output from `pry-theme --all-colors` command, so it
  displays data in 3 columns instead of 1;
* Changed some colors of Railscasts and Tomorrow themes;
* Fixed bug when a user installs fresh gem and gets an improper warning, because
  `Pry.config.theme` is not defined. Added a proper notification message for
  such situations;
* Renamed default theme `charcoal-black` to `pry-cold` (they are not the same).

### v0.0.9 (July 05, 2012)

* **HOT**: Added `--install` flag. Now, you can easily install Pry themes from
  Pry Theme Collection via command line (`pry-theme -i nifty-theme`);
* Added pager for long output. Try `pry-theme -a 256` and you will immediately
  notice the difference;
* Added more informative output for `--list` flag;
* Added a bunch of new default themes: solarized, zenburn, twilight, tomorrow,
  saturday, railscasts, monokai, github and charcoal-black;
* Fixed wrong color name in 256-color palette (`pale_conflower_blue` →
  `pale_cornflower_blue`);
* Fixed bug with respect to unwanted fall back to the `pry-classic` theme,
  when a user tries to switch to nonexistent theme;
* Added a feature to `pry-theme` command: when a user invokes `pry-theme`
  command without arguments, it returns name of the current theme.

### v0.0.8 (July 02, 2012)

* **IMPORTANT**: Changed directory where to store themes! Themes now live in
  `$HOME/.pry/themes` directory on Mac OS and GNU/Linux, both. Do not forget
  to delete or move your themes form the old path (On Mac OS it is
  `$HOME/Library/Application Support/pry-theme` and on GNU/Linux it is
  `$HOME/.pry/themes`).
* On some operating systems Pry Theme was failing to detect correct config path.
  Fixed.
* Fixed wrong behaviour, when uninstalling an unrelated gem. Pry Theme asked to
  uninstall themes every time you wanted to uninstall _any_ gem.
* Fixed a typo in `pry-classic` theme, which was preventing to set `delimiter`
  parameter to a string.
* Fixed wrong convertation of theme files.
* Implemented `--list` (`-l`) option, which displays a list of all installed
  themes.

### v0.0.7 (June 30, 2012)

* **HOTFIX**: v0.0.6 is broken (because of my inattentiveness).

### v0.0.6 (June 30, 2012)

* Fixed bug when a `prytheme` attribute has no color value, but with attributes
  (for example, `symbol : (b)`);
* Fixed bug when a `prytheme` has no color value at all (for example,
  `symbol : `);
* Add basic checking for a valid color in `prytheme`.

### v0.0.5 (June 29, 2012)

* No pre!
* Added Ruby 1.8.7, JRuby and Ruby Enterprise Edition support;
* Fixed 8-color themes bug. We could not even use them in the previous version;
* Added `--test` command, which allows to "test" your theme visually;
* Added uninstaller, which basically just asks a user if he or she wants to
  remove a directory with Pry themes (personally, I hate when software leave
  their crap);
* Slightly improved `help` of `pry-theme` command;
* Made theme attributes optional. Now, if you are not sure about some parameter
  in a Pry Theme, you can leave it empty.

Last but not least:

  * Check out new Wiki! (https://github.com/kyrylo/pry-theme/wiki).

### v0.0.4.pre (June 28, 2012)

* Added `--all-colors` and `--color` options for `pry-theme` command;
* Improved used experience when working with `pry-theme`.

### v0.0.3.pre (June 26, 2012)

* Added support for Mac OS and Windows (I believe so, at least).

### v0.0.2.pre (June 26, 2012)

* Fixed bug with wrong detection of the root directory of the project.

### v0.0.1.pre (June 26, 2012)

* Initial release.

[cli]: https://github.com/kyrylo/pry-theme/wiki/Pry-Theme-CLI
[cheatsheet]: https://github.com/kyrylo/pry-theme/wiki/Pry-Theme-Cheatsheet
[prescue]: https://github.com/ConradIrwin/pry-rescue/
