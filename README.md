README.md
=================

This gem is intended as a direct replacement for acts\_as\_archive (AAA)
in Rails 3 apps with all of the same functionality and wrapping AAA's 
methods in aliases to maintain compatibilty for some time. Thanks to 
[Winton Welsh](https://github.com/winton "Winton on github") for his 
original work on AAA, it is good solution to a problem that makes 
maintaining audit records a breeze.

More Later

TODO
-----------------

v1.0

 *  License
 *  Base Module
     *  <strike>Inserting Subclass (SomeModel::Archive)</strike>
     *  Archive method
     *  Intercept destroy/deletes
     *  Restore archive
 *  Migrations Module
     *  ??

Future

 *  give subclass Archive its parent's methods
 *  give Archive relations
 *  give Archive scopes 
