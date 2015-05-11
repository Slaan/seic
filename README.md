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
