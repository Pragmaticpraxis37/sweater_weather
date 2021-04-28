# Sweater Weather

## About this Project
Sweater Weather is a backend application that consumes four third-party API endpoints and allows access to five endpoints for a frontend application to consume.  The functionality of Sweater Weather revolves around allowing a user to register, obtain an API key, and use it to plan road trips with the weather in mind.  

## Table of Contents 

  - [Getting Started](#getting-started)
  - [Running the tests](#running-the-tests)
  - [Service Oriented Architecture](#service-oriented-architecture)
  - [Built With](#built-with)
  - [Contributing](#contributing)
  - [Versioning](#versioning)
  - [Author](#authors)
  - [Acknowledgments](#acknowledgments)

## Getting Started

To get the web application running, please fork and clone down the repo.

`git clone <your@github.account:Pragmaticpraxis37/sweater_weather.git>` 

### Prerequisites

To run this application you will need Ruby 2.5.3 and Rails 5.2.5

### Installing

- Install the gem packages  
  - `bundle install`
- Generate your local `application.yml` file to store the api key and confirm it was added to your `.gitignore`
  - `bundle exec figaro install`

## Running the tests
RSpec testing suite is utilized for testing this application.
- Run the RSpec suite to ensure everything is passing as expected  
`bundle exec rspec`

## Service Oriented Architecture
- The purpose of this backend application is to facilitate the communication between a frontend application that renders views that allow users to interact with the data provided through the consumption of third-party APIs and the repackaging of that data.  

## Endpoints
- GET `http://localhost:3000/api/v1/forecast?location=charleston,sc`
```json
{
    "data": {
        "id": null,
        "type": "forecast",
        "attributes": {
            "current_weather": {
                "datetime": "2021-04-27T20:54:16.000-06:00",
                "sunrise": "2021-04-27T04:36:10.000-06:00",
                "sunset": "2021-04-27T17:58:11.000-06:00",
                "temperature": 66.29,
                "feels_like": 66.52,
                "humidity": 83,
                "uvi": 0,
                "visibility": 10000,
                "conditions": "clear sky",
                "icon": "01n"
            },
            "daily_weather": [
                {
                    "date": "04-27-21",
                    "sunrise": "2021-04-27T04:36:10.000-06:00",
                    "sunset": "2021-04-27T17:58:11.000-06:00",
                    "max_temp": 75.78,
                    "min_temp": 59.9,
                    "conditions": "overcast clouds",
                    "icon": "04d"
                },
                {
                    "date": "04-28-21",
                    "sunrise": "2021-04-28T04:35:09.000-06:00",
                    "sunset": "2021-04-28T17:58:55.000-06:00",
                    "max_temp": 76.14,
                    "min_temp": 63.59,
                    "conditions": "overcast clouds",
                    "icon": "04d"
                },
                {
                    "date": "04-29-21",
                    "sunrise": "2021-04-29T04:34:09.000-06:00",
                    "sunset": "2021-04-29T17:59:40.000-06:00",
                    "max_temp": 78.46,
                    "min_temp": 65.41,
                    "conditions": "scattered clouds",
                    "icon": "03d"
                },
                {
                    "date": "04-30-21",
                    "sunrise": "2021-04-30T04:33:10.000-06:00",
                    "sunset": "2021-04-30T18:00:25.000-06:00",
                    "max_temp": 84.6,
                    "min_temp": 67.01,
                    "conditions": "light rain",
                    "icon": "10d"
                },
                {
                    "date": "05- 1-21",
                    "sunrise": "2021-05-01T04:32:12.000-06:00",
                    "sunset": "2021-05-01T18:01:10.000-06:00",
                    "max_temp": 67.33,
                    "min_temp": 63.46,
                    "conditions": "overcast clouds",
                    "icon": "04d"
                }
            ],
            "hourly_weather": [
                {
                    "time": "20:00:00",
                    "temp": 66.15,
                    "description": "few clouds",
                    "icon": "02n"
                },
                {
                    "time": "21:00:00",
                    "temp": 66.29,
                    "description": "clear sky",
                    "icon": "01n"
                },
                {
                    "time": "22:00:00",
                    "temp": 65.98,
                    "description": "few clouds",
                    "icon": "02n"
                },
                {
                    "time": "23:00:00",
                    "temp": 65.57,
                    "description": "scattered clouds",
                    "icon": "03n"
                },
                {
                    "time": "00:00:00",
                    "temp": 64.94,
                    "description": "scattered clouds",
                    "icon": "03n"
                },
                {
                    "time": "01:00:00",
                    "temp": 64.65,
                    "description": "broken clouds",
                    "icon": "04n"
                },
                {
                    "time": "02:00:00",
                    "temp": 63.86,
                    "description": "broken clouds",
                    "icon": "04n"
                },
                {
                    "time": "03:00:00",
                    "temp": 63.84,
                    "description": "broken clouds",
                    "icon": "04n"
                }
            ]
        }
    }
}
```
- GET `http://localhost:3000/api/v1/backgrounds?location=grand junction`
```
json 
{
    "data": {
        "id": null,
        "type": "image",
        "attributes": {
            "image": {
                "location": "Grand Junction, Colorado",
                "image_url": "https://images.unsplash.com/photo-1563058106-c565ab30dc37?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwyMjU5NjZ8MHwxfHNlYXJjaHwxfHxncmFuZCUyMGp1bmN0aW9ufGVufDB8fHx8MTYxOTU1MjU0Nw&ixlib=rb-1.2.1&q=80&w=1080",
                "credit": {
                    "source": "unsplash.com",
                    "author": "Rebecca McKenna",
                    "attribution_link": "https://api.unsplash.com/users/reebs16"
                }
            }
        }
    }
}
```
- POST `http://localhost:3000/api/v1/users`, 
body:
```
json 
{
  "email": "do@example.com",
  "password": "help",
  "password_confirmation": "help"
}
```
response: 
```
{
    "data": {
        "id": "2",
        "type": "users",
        "attributes": {
            "email": "do@example.com",
            "api_key": "1bab62502bf804de9c1f75b757be0a55"
        }
    }
}
```
- POST `http://localhost:3000/api/v1/sessions`
body: 
```
json
{
  "email": "zelp@example.com",
  "password": "help"
}
```
response: 
```
{
    "data": {
        "id": "1",
        "type": "users",
        "attributes": {
            "email": "zelp@example.com",
            "api_key": "2cdb304d08dc035ab305535432419cdb"
        }
    }
}
```
- POST `http://localhost:3000/api/v1/road_trip`
body: 
```
{
  "origin": "Denver,CO",
  "destination": "Aurora, CO",
  "api_key": "2cdb304d08dc035ab305535432419cdb"
}
```
response: 
```
{
    "data": {
        "id": null,
        "type": "roadtrip",
        "attributes": {
            "start_city": "Denver, CO, US",
            "end_city": "Aurora, CO, US",
            "travel_time": "0 hours and 24 minutes",
            "weather_at_eta": {
                "temperature": 50,
                "conditions": "clear sky"
            }
        }
    }
}
```

## Built With
- [Ruby On Rails](https://github.com/rails/rails)
- [Ruby](https://www.ruby-lang.org/en/)
- [RSpec](https://github.com/rspec/rspec)
- [Rbenv](https://github.com/rbenv/rbenv)

## Contributing
Please follow the steps below and know that all contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/<New-Cool-Feature-Name>`)
3. Commit your Changes (`git commit -m 'Add <New-Cool-Feature-Name>'`)
4. Push to the Branch (`git push origin feature/<New-Cool-Feature-Name>`)
5. Open a Pull Request

## Versioning
- Ruby on Rails 5.2.5
- Ruby 2.5.3
- RSpec 3.10.0
- Rbev 1.1.2

## Author
- **Adam Bowers**
| [GitHub](https://github.com/Pragmaticpraxis37) |
  [LinkedIn](https://www.linkedin.com/in/adam-bowers-06a871209/)
