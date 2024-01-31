# ПРОДАКШЕН

### Помилка
**Логи продакшена**
```
  I, [2023-03-18T23:18:16.910108 #69863]  INFO -- : [ba1af601-bf3a-4ee9-8623-e0beca9bacac] Started GET "/" for 127.0.0.1 at 2023-03-18 23:18:16 +0200
  I, [2023-03-18T23:18:16.915117 #69863]  INFO -- : [ba1af601-bf3a-4ee9-8623-e0beca9bacac] Processing by BooksController#user_books as HTML
  I, [2023-03-18T23:18:16.963248 #69863]  INFO -- : [ba1af601-bf3a-4ee9-8623-e0beca9bacac]   Rendered books/user_books.html.erb within layouts/application (Duration: 4.4ms | Allocations: 1413)
  I, [2023-03-18T23:18:16.967220 #69863]  INFO -- : [ba1af601-bf3a-4ee9-8623-e0beca9bacac]   Rendered layout layouts/application.html.erb (Duration: 8.5ms | Allocations: 2370)
  I, [2023-03-18T23:18:16.967760 #69863]  INFO -- : [ba1af601-bf3a-4ee9-8623-e0beca9bacac] Completed 500 Internal Server Error in 51ms (MongoDB: 0.0ms | Allocations: 12715)
  F, [2023-03-18T23:18:16.969051 #69863] FATAL -- : [ba1af601-bf3a-4ee9-8623-e0beca9bacac]   
  [ba1af601-bf3a-4ee9-8623-e0beca9bacac] ActionView::Template::Error (The asset "application.css" is not present in the asset pipeline.
  ):
  [ba1af601-bf3a-4ee9-8623-e0beca9bacac]      6:     <%= csrf_meta_tags %>
  [ba1af601-bf3a-4ee9-8623-e0beca9bacac]      7:     <%= csp_meta_tag %>
  [ba1af601-bf3a-4ee9-8623-e0beca9bacac]      8: 
  [ba1af601-bf3a-4ee9-8623-e0beca9bacac]      9:     <%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>
  [ba1af601-bf3a-4ee9-8623-e0beca9bacac]     10:     <%= javascript_importmap_tags %>
  [ba1af601-bf3a-4ee9-8623-e0beca9bacac]     11:     <%= javascript_pack_tag 'application', 'data-turbolinks-track': 'reload' %>
  [ba1af601-bf3a-4ee9-8623-e0beca9bacac]     12: 
  [ba1af601-bf3a-4ee9-8623-e0beca9bacac]   
  [ba1af601-bf3a-4ee9-8623-e0beca9bacac] app/views/layouts/application.html.erb:9
```
**Рішення**
  Ok, first thing.

  Do you have ``config.serve_static_files = true`` set in your production.rb file under ``config/environment`` folder.

  Since we run behind NGINX, in our case it looks like ``config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?``

  Second thing. Did you do rails ``assets:precompile`` before the uploading it to the server?

  And the third thing is. Have you tried calling your file ``application.css.scss``, and redoing the ``rails assets:precompile?``

  Last, and not least thing. How does your application.scss file look like?

  Did you remove all those ``*= and`` used ``@import`` instead for Bootstrap

**Посилання на рішення**
 1. [https://stackoverflow.com/questions/56614166/rails-application-css-not-in-asset-pipeline](https://stackoverflow.com/questions/56614166/rails-application-css-not-in-asset-pipeline)


 ### Помилка
 **Не вантажилися ассети**
  повна відсутність іконок для мов

  **Рішення**
```
rails production не завантажуються ассети
Если в вашем приложении Ruby on Rails в production-окружении не загружаются ассеты, это может быть связано с несколькими причинами:

Необходимо предварительно скомпилировать ассеты. В production-окружении ассеты не компилируются автоматически, поэтому необходимо предварительно скомпилировать их перед запуском приложения. Вы можете выполнить это, запустив следующую команду:

shell
Copy code
$ bundle exec rake assets:precompile RAILS_ENV=production
Эта команда создаст все необходимые файлы в папке public/assets.

Неправильно настроены параметры config.assets.compile и config.assets.digest. Убедитесь, что в файле config/environments/production.rb параметр config.assets.compile установлен в значение true. Если этот параметр установлен в значение false, Rails не будет компилировать ассеты в runtime. Кроме того, убедитесь, что параметр config.assets.digest установлен в значение true. Это позволяет Rails добавлять уникальный хеш к именам файлов ассетов, что помогает избежать кэширования старых версий ассетов.

Ошибки в конфигурации веб-сервера. Если вы используете веб-сервер, такой как Nginx или Apache, для обслуживания статических ассетов, убедитесь, что ваша конфигурация правильно настроена для обработки запросов на статические ассеты. Например, для Nginx вам может потребоваться добавить следующую директиву в вашу конфигурацию:

vbnet
Copy code
location /assets/ {
  root /path/to/your/app/public;
  gzip_static on;
  expires max;
  add_header Cache-Control public;
}
Это позволяет Nginx обслуживать статические ассеты из папки public/assets вашего приложения.

Проблемы с путями. Убедитесь, что все пути в ваших файловых ассетах правильно настроены. Например, если у вас есть файл application.js с инструкцией //= require jquery, убедитесь, что файл jquery.js находится в папке app/assets/javascripts.

Включение config.serve_static_assets в Rails 4. В Rails 4 параметр config.serve_static_assets был заменен параметром config.serve_static_files. Убедитесь, что у вас установлен верный параметр в config/environments/production.rb.

Ошибки прав доступа к папкам. Убедитесь, что папки public/assets и `
```

 ### Помилка

**`validate_secret_key_base': Missing `secret_key_base`**

### Рішення

додати до ```words_dev/words/config/environments/production.rb```
```
config.secret_key_base = '<%= ENV["SECRET_KEY_BASE"] %>'
```