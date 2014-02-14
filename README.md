# SimpleCMS #

SimpleCMS is a Rails engine that allows users to edit live website copy.

## How to use ##

1) Add ```simplecms``` to your Gemfile and run ```bundle install```.

2)
```
rake cms:install
rake db:migrate
```

3) Specify ```config.cms_controllers```, a list of controller names to enable live copy for, in ```config/initializers/cms.rb```

Cms uses a database table to store the copy items and wraps a page cache around the pages that displays copy. In a view, use the ct method where you would like to display some editable copy:

```erb
<h1><%= ct('main#index.1', 'some default text') %></h1>
```

Key name must follow the format controller#action.anything_can_go_here, all lowercase, for example: main#index.hej or main#faq.10. This name is not shown anywhere in the editor so feel free to use cursewords.


## Routes ##

The default route to edit content is '/cms'. This can be changed in the initializer

The Cms routes are configured automatically by the engine, after your Rails application's routes.rb file is run. This means that if your routes include a catchall route at the bottom, the Cms route will be masked.