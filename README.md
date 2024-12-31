[![Ruby on Rails](https://img.shields.io/badge/Ruby%20on%20Rails-v6.1.4-red)](https://rubyonrails.org/)
[![Heroku](https://img.shields.io/badge/Heroku-Live-brightgreen?logo=heroku)](https://tuiter-c74eae68137b.herokuapp.com/)

# Tuiter App 🐦

<h4 align="center">A Twitter-like social media app built with Ruby on Rails</h4>

## [Live Demo ✨](https://tuiter-c74eae68137b.herokuapp.com/)

Sign up for an account, validate it through email, and create your first post with an image!

## About the App 🚀

The **Tuiter App** is an open-source, feature-rich, Twitter-like social media platform.

It's built with **Ruby on Rails** and serves as a project for **learning purposes**, **testing new technologies**, and **showcasing Rails development practices**. Contributions are welcome to improve and expand the app further.

### Key Features 🌟

- **User registration and authentication**: Secure account creation, login, logout, and session remembering for persistent sessions.
- **Account activation**:  New users receive an email with a link to activate their account using a secure token.
- **Password reset**: Users can reset their forgotten passwords through a secure, email-based process.
- **Microposts**: Create, read and delete short posts (like tweets) with optional image attachments.
- **Image upload**: Supports image uploads using Active Storage and AWS S3.
- **Follow system**: Users have a feed of microposts from the people they are following.
- **Testing**: Comprehensive unit and integration test suite.

## Contributing 🧑‍💻

Contributions are more than welcome!

Feel free to open an Issue or submit a Pull Request to suggest improvements or add new features.

### Run It Locally 🛠️

1. Prerequisites:
    ```sh
    > ruby -v
    ruby 2.7.5
    ```
    ```sh
    > rails -v
    Rails 6.1.7.7
    ```
    ```sh
    > node -v
    v16.13.0
    ```
2. Install dependencies:
    ```sh
    > yarn add jquery@3.5.1 bootstrap@3.4.1
    ```

    ```sh
    > gem install bundler -v 2.2.17
    > bundle _2.2.17_ config set --local without 'production'
    > bundle _2.2.17_ install
    ```
3. Set up the database:
    ```sh
    > rails db:migrate
    > rails db:seed
    ```
4. Start the Rails server:
    ```sh
    > rails server
    ```
5. You should now be able to access the app at [http://localhost:3000](http://localhost:3000).

## Purpose and Progress 🛤️

This application was initially inspired by the [_Ruby on Rails Tutorial_](https://www.railstutorial.org/) by [Michael Hartl](http://www.michaelhartl.com/). Over time, it has evolved to include additional features and modern techniques to enhance functionality and usability. It is a **work in progress**, with the goal of continually improving the app.
