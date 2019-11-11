FROM ruby:2.5.5

ENV LANG C.UTF-8
ENV APP_ROOT /app

RUN apt-get install -y gnupg && \
    curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get install -y nodejs yarn
RUN apt-get update -qq && gem install bundler
  
WORKDIR ${APP_ROOT}

COPY . ${APP_ROOT}

RUN bundle install
CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
