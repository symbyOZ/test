FROM ruby:2.5

LABEL maintainer="nikita.sosnov@dataart.com"

ENV RACK_ENV production

RUN mkdir -p /usr/src/app/config

WORKDIR /usr/src/app

ADD Gemfile* /usr/src/app/

RUN bundle install

ADD main.rb /usr/src/app/main.rb
ADD config/ /usr/src/app/config/

EXPOSE 7000

CMD ["ruby", "main.rb"]
