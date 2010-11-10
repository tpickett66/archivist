README.md
=================

This gem is intended as a direct replacement for acts\_as\_archive (AAA)
in Rails 3 apps with most of the same functionality and wrapping AAA's 
methods in aliases to maintain compatibilty for some time. Thanks to 
[Winton Welsh](https://github.com/winton "Winton on github") for his 
original work on AAA, it is good solution to a problem that makes 
maintaining audit records a breeze.

More Later

TODO
-----------------

v1.0

 *  License
 *  <del>Base Module</del>
     *  <del> Inserting Subclass (SomeModel::Archive) </del>
     *  <del> Archive method </del>
     *  <del> Intercept destroy/deletes </del>
     *  <del>Restore archive</del>
     *  <del> Build archive table for existing models </del>
 *  Migrations Module
     *  ??

Future

 *  give subclass Archive its parent's methods
 *  give Archive relations
 *  give Archive scopes
 *  make archive\_all method chain-able with scopes 
