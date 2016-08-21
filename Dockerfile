FROM ruby:2.3
ENV RAILS_ENV production

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends mariadb-client nodejs

WORKDIR /usr/src/app
ADD Gemfile* ./
RUN bundle install --without development test
ADD . .
RUN rake assets:precompile

EXPOSE 3000
RUN chmod +x start.sh
CMD ["/usr/src/app/start.sh"]
