FROM ruby:3.3.6

ENV INSTALL_PATH=/opt/inferno/
ENV APP_ENV=production
RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

ADD lib/covid19_vci/version.rb $INSTALL_PATH/lib/covid19_vci/version.rb
ADD *.gemspec $INSTALL_PATH
ADD Gemfile* $INSTALL_PATH
RUN gem install bundler
RUN bundle install

ADD . $INSTALL_PATH

EXPOSE 4567
CMD ["bundle", "exec", "puma"]
