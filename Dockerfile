FROM ubuntu:14.04
MAINTAINER Kingsquare <docker@kingsquare.nl>

WORKDIR /usr/local/newrelic_aws_cloudwatch_plugin-latest
ENV DEBIAN_FRONTEND noninteractive

####
# Base stuff, software dependencies from APT
RUN echo "Europe/Amsterdam" > /etc/timezone && \
	dpkg-reconfigure tzdata && \
	apt-get update && \
	apt-get upgrade -y --no-install-recommends && \
	apt-get install -y --no-install-recommends build-essential curl git ruby ruby-dev libxml2-dev libxslt-dev && \
	gem install --no-rdoc --no-ri bundler

####
# App installation: latest version of the newrelic plugin
RUN curl -L https://github.com/newrelic-platform/newrelic_aws_cloudwatch_plugin/archive/latest.tar.gz > latest.tar.gz && \
	tar -zxf latest.tar.gz -C /usr/local && \
	cp config/template_newrelic_plugin.yml config/newrelic_plugin.yml && \
	sed -e "s/YOUR_LICENSE_KEY_HERE/<%= ENV[\"NEWRELIC_KEY\"] %>/g" -i config/newrelic_plugin.yml && \
	sed -e "s/YOUR_AWS_ACCESS_KEY_HERE/<%= ENV[\"AWS_ACCESS_KEY\"] %>/g" -i config/newrelic_plugin.yml && \
	sed -e "s/YOUR_AWS_SECRET_KEY_HERE/<%= ENV[\"AWS_SECRET_KEY\"] %>/g" -i config/newrelic_plugin.yml && \
	bundle install

####
# CLEAN up
RUN apt-get clean && \
    rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

CMD bundle exec ./bin/newrelic_aws
