FROM ruby:latest

RUN gem install bundler && apt-get update && apt-get install -y redis-server

WORKDIR /usr/src/app

COPY . .

RUN bundle install

EXPOSE 3000

CMD ["puma", "config.ru", "-C", "puma.rb"]
