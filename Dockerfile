# Stage 1: Build the application
FROM ruby:3.4.2

# Install system dependencies
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    nodejs \
    postgresql-client \
    netcat-traditional \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Install application dependencies
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

# Copy the application code
COPY . .

# Install JavaScript dependencies
COPY package.json yarn.lock ./
RUN yarn install

# Precompile assets
RUN RAILS_ENV=production bundle exec rails assets:precompile

# Add a script to be executed every time the container starts
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

# Configure the main process to run when running the image
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]

