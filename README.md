# lemp_on_focal_fossa
Build LEMP in the environment of Ubuntu 20.04LTS.  

# Execution
```
# build an image
docker build -t image_name Dockerfile's_path
# launch container from the image
docker run -d -p 80:80 -p 443:443 image_name
```
You can see that wordpress works by accessing "https: // localhost".  
If you access it via http, you will be redirected to https.  
And you can see that phpMyAdmin and mysql work by accessing  
"https: // localhost / phpMyAdmin-5.0.4-all-languages /".  
The username for phpMyAdmin is "user" and the password is "password"  
The database name for wordpress is "dbname".
