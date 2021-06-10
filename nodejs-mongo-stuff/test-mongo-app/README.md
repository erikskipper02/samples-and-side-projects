# test-mongo-app

test-mongo-app is a full-stack app (minus the front-end) that includes a REST API built in NodeJS that talks to MongoDB and runs on Docker.

## Prerequisites

- macOS Big Sur (version 11.4)
- Docker/Docker Desktop

## Installation

If Docker/Docker Desktop is installed, clone this repo and run the following:

```bash
cd /test-mongo-app
docker compose build
docker compose up
```

To stop the containers, run the following:

```bash
cd /test-mongo-app
docker compose down
```

## API Specification

The server runs on port 8080, so all requests should start with http://localhost:8080/ followed by the endpoint. For example:

`http://localhost:8080/user`

### Endpoints

```bash
GET /user # Returns a list of users

# Example

curl --location --request GET 'http://localhost:8080/user/'

# Sample output

[
    {
        "_id": "60c09bf8122d090014291a81",
        "first": "Erik",
        "last": "Skipper",
        "interests": [
            "Golfing",
            "Fishing"
        ],
        "latitude": 38.0047645,
        "longitude": -78.180221
    },
    {
        "_id": "60c09c22122d090014291a82",
        "first": "Elise",
        "last": "Skipper",
        "interests": [
            "Camping",
            "Hiking"
        ],
        "latitude": 38.0047645,
        "longitude": -78.180221
    }
]
```
```bash
GET /user/:_id # Returns a user by _id

# Example

curl --location --request GET 'http://localhost:8080/user/60c09bf8122d090014291a81'

# Sample output

{
    "_id": "60c09bf8122d090014291a81",
    "first": "Erik",
    "last": "Skipper",
    "interests": [
        "Golfing",
        "Fishing"
    ],
    "latitude": 38.0047645,
    "longitude": -78.180221
}
```
```bash
POST /user # Creates a user

# Example

curl --location --request POST 'http://localhost:8080/user' \
--header 'Content-Type: application/json' \
--data-raw '{
    "first" : "Erik",
    "last" : "Skipper",
    "interests" : ["Golfing","Fishing"],
    "latitude": 38.0047645,
    "longitude": -78.1802210
}'

# Sample output

{
    "ok": 1,
    "n": 1
}
```

## Additional Questions

Were you able to complete all the functionality in the time allotted? If not, which pieces are outstanding?

```
I was not able to complete all the functionality in the time allotted. The following pieces are still outstanding:

a. Returning the City and State as part of the GET request
b. Returning the Current Temperature as part of the GET request

If you take a look at `weather.js`, I wrote a function to retrieve the City, State, and Temperature data from **api.weather.gov**. The function is currently logging the data to the console, but it is not returning the data.

This can be tested by running `node weather.js`. The lat/long are hard-coded in the form of variables to simulate the lat/long be pulled from the user's data and being passed as inputs to the `getCityStateTemp` function.
```

What potential issues do you see with your API, as implemented? How would you address them?

```
a. The API is currently not returning the City, State, and Temperature data. In order to finish that, I would need to do some additional research on JavaScript - specifically, callbacks. Whenever I returned the data, it returned as `undefined`. If I could get the function returning the data, I could drop the function into the GET request, parse the user's lat/long data, pass the user's lat/long data as input to the function, and write some additional logic to append the City, State, and Temperature to the response that is sent to the front-end.

b. The API is currently running on HTTP. This is problematic from a security standpoint. If I had additional time, I would implement HTTPS and require the front-end to have to authenticate when making requests. 

c. The API is currently not performing any validation/error handling. This is problematic from a functional standpoint. For example, if the user were to enter in a lat/long that is not supported by api.weather.gov, the API would not be able to gracefully handle that. If I had additional time, I would implement proper validation/error handling using try/catch blocks or something similar.

d. An API specification in the form of a `README.md` is not delevoper-friendly. I would use Swagger Documentation or, at the very least, Postman Collections to provide better documentation.
```

What security limitations does your API have?

```
See part b. of question 2. I got ahead of myself.

I would also encrypt the connection between the API and the DB, and encrypt the volumes associated with the API and DB, that way data is encrypted in transit, in process, and at rest.
```