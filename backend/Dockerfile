# Use Ruby 3.3.7
ARG RUBY_VERSION=3.3.7
FROM ruby:$RUBY_VERSION-slim

# Rails app lives here
WORKDIR /rails

# Install base packages
RUN apt-get update && apt-get install -y \
    build-essential \
    libyaml-dev \
    pkg-config \
    default-libmysqlclient-dev \  
 && rm -rf /var/lib/apt/lists/*
# Copy Gemfile first so we can install gems during image build
COPY Gemfile Gemfile.lock ./

# make bundled executables and /rails/bin available
ENV PATH="/rails/vendor/bundle/ruby/3.3.0/bin:/rails/bin:${PATH}"

# Ensure correct Bundler version is available globally
RUN gem install bundler -v '~> 2.6'

# Configure bundler and install gems with retry logic
RUN bundle config set --local deployment 'false' && \
    bundle config set --local path 'vendor/bundle' && \
    bundle config set --local bin 'vendor/bundle/ruby/3.3.0/bin' && \
    bundle install --jobs 4 --retry 3

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile --gemfile app/ lib/

# Entrypoint prepares the database
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]