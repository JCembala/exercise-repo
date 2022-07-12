### Prerequisites
Set up fresh app with the following settings:
- ruby 3.1.2
- rails 7.0.3
- testing: `rspec` + `factory_bot` + `faker`
- db: PostgreSQL 14
- `rubocop` as static code analyzer

### Sendgrid

Application uses Sendgrid. You have to add your .env.local file with your API_KEY.
Check .env for more info

### Overcommit
This project is using overcommit to ensure commit quality. 

Run `gem install overcommit`
Move to your project dir
Run `overcommit --install`
