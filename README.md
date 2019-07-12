# Testing docker image for [Shepherd](https://github.com/apluslms/shepherd)
*This image is only for testing shepherd, don't use it for production deployment.*

## Features
* Based on [apluslms-service-base](https://github.com/apluslms/service-base/).
* Start [Shepherd](https://github.com/apluslms/shepherd) in one go.
* Using [s6](https://github.com/skarnet/s6) for service supervision.
## User in container
* `shepherd`: used for run shepherd, celery, broker, etc.
* `postgresql`: used in the init of database.

## S6 Services
* `shepherd-celery-beat`: run scheduled task, such as repo cleaning and RSA key auto-validation.
* `shepherd-celery-beat`: run other background task
* `shepherd-broker`: run message broker.
