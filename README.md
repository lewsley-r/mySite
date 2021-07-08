```
Disclaimer: All commands featured are for Linux, may differ for mac or windows users.
```

Stack consists of:
```
Vue.js Front-end,
Laravel PHP Back-end,
Nginx Web Server,
Postgres DB
```
All of this is of course containerised with docker.

Pre Dependencies:
```
Node
NPM
Docker-Compose
MySql
Composer (For Laravel)
```

Install Instructions
```
Upon Cloning the repo, change directory to ms-frontend, run "NPM Install".
Once this has completed change to the ms-backend directory, run command "composer require install"
These two commands should install any package dependencies for the stack, you can now return to the parent directory "mySite" and run the docker-compose up. This will build and then run the images.
```