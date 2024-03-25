# Tuiter App

## Purpose and Progress

The sole purpose of this application is to practice and improve Rails application development skills. It is a work in progress, with the aim of continually enhancing the application and incorporating more advanced and modern Rails versions and techniques.

While this application started as a variant of the reference implementation from the [_Ruby on Rails Tutorial: Learn Web Development with Rails_](https://www.railstutorial.org/) (6th Edition) by [Michael Hartl](http://www.michaelhartl.com/), it has evolved and will continue to evolve as more features and techniques are added.

## Key Features

The Tuiter App is a comprehensive implementation of a Twitter-like social media app.

It includes a wide range of features:

- **User registration and authentication**: Users can sign up with a secure password, log in, and log out. The application includes session remembering for persistent sessions.

- **Account activation**: New users receive an email with a link to activate their account using a secure token.

- **Password reset**: Users can reset their forgotten passwords through a secure, email-based process.

- **Microposts**: Users can create, read, and delete microposts, which are short posts like tweets.

- **Image upload**: Users can attach an image to their microposts. The application uses the Active Storage Rails feature in combination with the AWS S3 service.

- **Feed**: Users have a feed of microposts from the people they are following.

- **Following users**: Users can follow and unfollow other users.

- **Comprehensive testing suite**: The application includes a full suite of unit and integration tests.

## Getting started

First, make sure you have Ruby and Rails installed. You can check this by running:

```
$ ruby -v
$ rails -v
```

You should see something like ruby 2.7.5 and Rails 6.1.4.

If you don't have Ruby installed, you can install it using a Ruby version manager like rbenv or RVM. Once you have Ruby installed, you can install Rails by running:

 ```
$ gem install rails -v 6.1.4
```

Also make sure you’re using a compatible version of Node.js:

```
$ nvm install 16.13.0
$ node -v
v16.13.0
```

Clone the repo and `cd` into the directory:

```
$ git clone https://github.com/guidodelbo/tuiter_app.git
$ cd tuiter_app
```

Then install the needed packages (while skipping any Ruby gems needed only in production):

```
$ yarn add jquery@3.5.1 bootstrap@3.4.1
$ gem install bundler -v 2.2.17
$ bundle _2.2.17_ config set --local without 'production'
$ bundle _2.2.17_ install
```

Next, migrate the database:

```
$ rails db:migrate
```

Finally, run the test suite to verify that everything is working correctly:

```
$ rails test
```

If the test suite passes, you’ll be ready to seed the database with sample data:

```
$ rails db:seed
```

Finally, start the Rails server:

```
$ rails server
```

You should now be able to access the app at http://localhost:3000.
