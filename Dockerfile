FROM ruby:3.1.2

ENV INSTALL_PATH=/opt/inferno/
ENV APP_ENV=production
RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

ADD lib/shc_vaccination_test_kit/version.rb $INSTALL_PATH/lib/shc_vaccination_test_kit/version.rb
ADD *.gemspec $INSTALL_PATH
ADD Gemfile* $INSTALL_PATH
RUN gem install bundler
RUN bundle install

ADD . $INSTALL_PATH

EXPOSE 4567
CMD ["bundle", "exec", "puma"]
