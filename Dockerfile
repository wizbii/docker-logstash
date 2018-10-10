FROM jruby as builder

WORKDIR /usr/src/app

RUN curl -L https://api.github.com/repos/wizbii/logstash-output-algolia/tarball/master | tar xz --strip=1 && \
    bundle install --without development test && \
    gem build logstash-output-algolia.gemspec

FROM docker.elastic.co/logstash/logstash-oss:6.4.2

COPY --from=builder /usr/src/app/logstash-output-algolia-0.1.0.gem /

RUN bin/logstash-plugin install /logstash-output-algolia-0.1.0.gem
