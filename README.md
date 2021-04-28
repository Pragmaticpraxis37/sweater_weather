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
