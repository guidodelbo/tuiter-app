[![Ruby on Rails](https://img.shields.io/badge/Ruby%20on%20Rails-v8.0.1-red)](https://rubyonrails.org/)
[![AWS EC2](https://img.shields.io/badge/AWS-EC2-orange?logo=amazon-aws)](https://tuiter.guidodelbo.me/)

[![Kamal](https://img.shields.io/badge/Kamal-Deployed-green)](https://tuiter.guidodelbo.me/)

# Tuiter App 🐦

<h4 align="center">A Twitter-like social media app built with Ruby on Rails</h4>

## [Live Demo ✨](https://tuiter.guidodelbo.me/)

Sign up for an account, validate it through email, and create your first post with an image!

## About the App 🚀

The **Tuiter App** is an open-source, feature-rich, Twitter-like social media platform.

It's built with **Ruby on Rails** and serves as a project for **learning purposes**, **testing new technologies**, and **showcasing Rails development practices**. Contributions are welcome to improve and expand the app further.

### Key Features 🌟

- **User registration and authentication**: Secure account creation, login, logout, and session remembering for persistent sessions.
- **Account activation**: New users receive an email with a link to activate their account using a secure token.
- **Password reset**: Users can reset their forgotten passwords through a secure, email-based process.
- **Microposts**: Create, read and delete short posts (like tweets) with optional image attachments.
- **Image upload**: Supports image uploads using Active Storage and AWS S3.
- **Follow system**: Users have a feed of microposts from the people they are following.
- **Modern JavaScript**: Uses Stimulus.js for dynamic features.
- **Testing**: Comprehensive RSpec test suite including system, request, and unit tests.
- **Dockerized**: Application runs in Docker containers for consistency across environments.
- **Kamal Deployment**: Easy deployment to AWS EC2 using Kamal.

## Contributing 🧑‍💻

Contributions are more than welcome!

Feel free to open an Issue or submit a Pull Request to suggest improvements or add new features.

### Run It Locally 🛠️

1. Prerequisites:
    ```sh
    > ruby -v
    ruby 3.4.2
    ```
    ```sh
    > rails -v
    Rails 8.0.1
    ```
    ```sh
    > node -v
    v16.20.2
    ```
2. Install dependencies:
    ```sh
    > yarn install
    ```

    ```sh
    > bundle install
    ```
3. Set up the database:
    ```sh
    > bin/setup
    ```
4. Start the Rails server:
    ```sh
    > bin/dev
    ```
5. You should now be able to access the app at [http://localhost:3000](http://localhost:3000).

### Running Tests 🧪

The application uses RSpec for testing. To run the test suite:

```sh
> bin/rspec
```

To run specific test files:
```sh
> bin/rspec spec/system/microposts/feed_spec.rb
```

## Purpose and Progress 🛤️

This application was initially inspired by the [_Ruby on Rails Tutorial_](https://www.railstutorial.org/) by [Michael Hartl](http://www.michaelhartl.com/).

As an **open-source project** and **continuous work in progress**, it has been evolving with several improvements so far:
- Updated to Rails 8.0.1 and Ruby 3.4.2
- Replaced Minitest with RSpec for improved testing
- Added FactoryBot for better test data management
- Added Stimulus.js for modern JavaScript functionality
- Integrated Mailgun for production email delivery
- Configured AWS S3 for image storage in production
- Migrated from Heroku to AWS EC2 using Docker and Kamal
- Added SSL support with Let's Encrypt

More improvements are planned and contributions are always welcome! Check the Issues tab for planned features or suggest your own.
