### Prerequisites
Set up fresh app with the following settings:
- ruby 3.1.2
- rails 7.0.3
- testing: `rspec` + `factory_bot` + `faker`
- db: PostgreSQL 14
- `rubocop` as static code analyzer

### Admin
login: admin@example.com  
password: password
### DB setup
1. rails db:create
2. rails db:migrate
3. rails db:seed

### Sendgrid

Application uses Sendgrid. You have to add your .env.local file with your API_KEY.
Check .env for more info

### Lockbox

You have to add your Master_key to .env.local file: 

* generate it with `Lockbox.generate_key`
* add it to .env.local file: `LOCKBOX_MASTER_KEY=your_key_here`


### Overcommit
This project is using overcommit to ensure commit quality. 

* Run `gem install overcommit`
* Move to your project dir
* Run `overcommit --install`

### OAuth Google
On Google Cloud:
* Create your project
* Confirgure OAuth consent screen
* Add your e-mail as test account
* Add to .env.local your OAuth credentials:
GOOGLE_CLIENT_ID
GOOGLE_CLIENT_SECRET
