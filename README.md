External Dependencies:
* Javascript runtime
Under windows: download Node.js

https://nodejs.org/download/

# Setup
```
bundle install --without production
rake db:schema:load
rake db:seed
```

After pull
```
(bundle install || bundle update)
rake db:migrate


To test locally with ssl:

https://gist.github.com/trcarden/3295935
http://www.railway.at/2013/02/12/using-ssl-in-your-local-rails-environment/
