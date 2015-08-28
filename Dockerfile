FROM rails:4.1.4

RUN mkdir -p /usr/src/app/coupondeliverer2
WORKDIR /usr/src/app/coupondeliverer2
COPY Gemfile /usr/src/app/coupondeliverer2/
RUN bundle install

EXPOSE 3000
