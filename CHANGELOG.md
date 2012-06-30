Pry Theme changelog
===================

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
