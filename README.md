# Project

Teletask assessment project. It implements the Twilio Service for sms sending and receiving status callback about those sms through a webhook. The app has two trigger points for sms sending including the welcome sms on signup. The app also implements the real time notification system for showing the status of sms received via webhook.

## Table of Contents
- [Ruby version](#ruby-version)
- [System dependencies](#system-dependencies)
- [Configuration](#configuration)
- [Database creation](#database-creation)
- [To run the test suite](#how-to-run-the-test-suite)

## Ruby version

3.1.3

## System dependencies

ruby, rails, node, postgresql

## Configuration

- Bundle the project
```sh
bundle install
```
- DB Setup
```sh
rails db:create
rails db:migrate
```

- Asset precompilation
```sh
rails assets:precompile
```
- Twilio account and credentials setup
-- Get your `${phone number}`, `${account_sid}`, `${auth_token}` from your twilio account and put them inside the credentials file using
```sh
EDITOR='nano' rails credentials:edit
```
(you can use any editor. here 'nano' is used)
-- For status-callback webhook, add your URL in the twilio account and also in credentials file in `${TWILIO_CALLBACK_URL}`
-- Lastly, set the`${TWILIO_HOST}` in credentials file. (it is a substring of your `{TWILIO_CALLBACK_URL}`)

## Database creation

```sh
rails db:create
rails db:migrate
```

## To run the test suite

```sh
bundle expec rspec 
```
