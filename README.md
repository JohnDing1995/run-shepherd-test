# The test docker image for [Shepherd](https://github.com/apluslms/shepherd)
*This image is only for testing shepherd, don't use it for production deployment.*

## Features
* Based on [apluslms-service-base](https://github.com/apluslms/service-base/).
* Start [Shepherd](https://github.com/apluslms/shepherd) in one go.
* Using [s6](https://github.com/skarnet/s6) for service supervision.
## User in container
* `shepherd`: used for run shepherd, celery, broker, etc.
* `postgresql`: used in the initialisation of database.

## S6 Services
* `shepherd-celery-beat`: run scheduled task, such as repo cleaning and RSA key auto-validation.
* `shepherd-celery-beat`: run other background task
* `shepherd-broker`: run message broker.

## Usage
### I. Prepare A+
1. Set up `A+` main server according to [here](https://apluslms.github.io/guides/quick/). 
2. Add lti service in [Django admin](http://127.0.0.1:8000/admin/external_services/ltiservice/add/).This link only works after you run `A+` on the localhost Username/Password: `root`. The setting should be as same as this screenshot.

![lti](img/lti.png)

3. Add lti service to menu, go to main page of `A+`, then go `Def. Course` -> `Edit course` -> Click `Menu` tab -> Add new menu item. Select `test_flask_lti` from `Service` and leave other empty.
4. Now you can see `test_flask_lti` on the left sidebar of the main page.
### II. Pull image and run.
1. `clone` this repository.
2. Check if the permission of `/var/run/docker.sock` allow other user to accesss, if not, change it with `sudo chmod o=rwx /var/run/docker.sock`, you need `sudo` privilege for this. 
3. Create `volume` for cloned files using `docker volume create shepherd_clone`. 
4. Run server using `docker build --no-cache -t shepherd . && docker run -p 5000:5000 -p 5001:5001 -v /var/run/docker.sock:/var/run/docker.sock -v shepherd_clone:/srv/shepherd/shepherd_test_clone/ shepherd:latest
`. 
5. Now you can use the system by click `test_flask_lti` on the the `A+`mian page. `LTI` protocal allows `A+` user log into `Shepherd` directly without passwords.
