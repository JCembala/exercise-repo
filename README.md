### Prerequisites
Set up fresh app with the following settings:
- ruby 3.1.2
- rails 7.0.3
- testing: `rspec` + `factory_bot` + `faker`
- db: PostgreSQL 14[^bignote]
- `rubocop` as static code analyzer

### Goal
- add `User` model (with `email`, `first_name` and `last_name`, `password` fields; all required; email should be valid, password should be at least 8 characters)
- display sign in / sign up form on the home page for new users
- after logging in, on the home page there should be a settings button which goes to the user settings
- user can: register new account, log in, log out, reset password and edit profile (first and last name)
- user account should be confirmed via email confirmation
- user can: destroy their account
- codebase should be covered by tests (keywords to google for: controller spec, features spec, unit spec)

### Hints:
- use [devise](https://github.com/heartcombo/devise) for user management
- [add some styles](https://github.com/twbs/bootstrap-rubygem) to make it look better (or skip if you don't care)
- use [mailcatcher](https://github.com/sj26/mailcatcher) for testing purposes, but set up real email sending too
- [dotenv](https://github.com/bkeepers/dotenv) for environment variables management

[^bignote]: `docker-compose.yml` file
    ```
    version: "3.7"
    
    services:
      db:
        image: "postgres:14-alpine"
        ports:
          - "5434:5432"
        volumes:
          - dev_path_app_db:/var/lib/postgresql/data
        environment:
          POSTGRES_USER: postgres
          POSTGRES_PASSWORD: secret
          POSTGRES_DB: "dev_path_app_db"
      
    volumes:
        dev_path_app_db:
    ```