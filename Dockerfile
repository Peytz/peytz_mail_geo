FROM ruby:2.7.1
EXPOSE 3000

RUN mkdir -p /app
COPY . /app
WORKDIR /app

RUN gem install bundler --no-document
RUN bundle install

CMD [ "rackup --host 0.0.0.0 -p 3000" ]
