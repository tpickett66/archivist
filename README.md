README.md
=================

This gem is intended as a direct replacement for acts\_as\_archive (AAA)
in Rails 3 apps with most of the same functionality and wrapping AAA's 
methods in aliases to maintain compatibilty for some time. Thanks to 
[Winton Welsh](https://github.com/winton "Winton on github") for his 
original work on AAA, it is good solution to a problem that makes 
maintaining audit records a breeze.

Requirements
------------
This gem is intended to be used with ActiveRecord/ActiveSupport 3.0.1 and later.

Install
-------
**Gemfile**:
    gem 'archivist'
    
Update models
-------------
add `has_archive` to your models:
    class SomeModel < ActiveRecord::Base
      has_archive
    end

N.B. if you have any serialized attributes the has\_archive declaration *MUST* be after the serialization declarations or they will not be preserved and things will break when you try to deserialize the attributes.

i.e.
    class AnotherModel < ActiveRecord::Base
      serialize(:some_array,Array)
      has_archive
    end

*NOT*
    class ThisModel < ActiveRecord::Base
      has_archive
      serialize(:a_hash,Hash)
    end

<a name="add_archive_tables"></a>
Add Archive tables
------------------
There are two ways to do this, the first is to use the built in updater like acts as archive.
`Archivist.update SomeModel`
Currently this doesn't support adding indexes automatically (AAA does) but I'm working on doing multi column indexes (any help is greatly appreciated)

The second way of adding archive tables is to build a migration yourself, there currently is no advantage of doing this. I am working on allowing overriding the copy\_to\_archive method to allow injection of additional information along with the original data (i.e. tracking what user caused the archival) which may require hand built migrations.

Usage
-----
Use `destroy`, `delete`, `destroy_all` as usual and the data will get moved to the archive table. If you really want the data to go away you can still do so by simply calling `destroy!` etc. This bypasses the archiving step but leaves your callback chain intact where appropriate. 

Migrations affecting the columns on the original model's table will be applied to the archive table as well.

Contributing
------------
If you'd like to help out please feel free to fork and browse the TODO list below or  add a feature that you're in need of. Then send a pull request my way and I'll happily merge in well tested changes.

Also, I use autotest and MySQL but [nertzy (Grant Hutchins)](https://github.com/nertzy "Grant on github") was kind enough to add a rake task for running the specs as well as adding support for testing against Postgres using the pg gem.

TODO
----

 *  <del>Maintain seralized attributes from original model</del>
 *  give Archive scopes from parent (may only work w/ 1.9 since scopes are Procs)
 *  <del>give subclass Archive its parent's methods (method\_missing?)</del>
 *  associate SomeModel::Archive with SomeModel (if archiving more than one copy)
 *  associate Archive with other models (SomeModel.reflect\_on\_all\_associations?)
 *  make archive\_all method chain-able with scopes and other finder type items
