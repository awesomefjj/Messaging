# ======== build common image =======
FROM ruby:2.5.5-alpine3.9 as base
LABEL project="tamigos-messaging"
LABEL maintainer="xiaohui@tanmer.com"

WORKDIR /app
RUN mkdir -p /app \
    && sed -i 's!http://dl-cdn.alpinelinux.org!https://mirrors.tuna.tsinghua.edu.cn/!' /etc/apk/repositories \
    && apk add tzdata postgresql-dev ruby-nokogiri ruby-ffi \
       postgresql-dev libxml2-dev libxslt-dev nodejs \
    && apk add --virtual rails-build-deps \
       build-base ruby-dev libc-dev linux-headers \
       git yarn python \
    && gem source --remove https://rubygems.org/ --add https://gems.ruby-china.com/ \
    && yarn config set registry http://registry.npm.taobao.org \
    && yarn config set sass-binary-site http://npm.taobao.org/mirrors/node-sass \
    && yarn config set cache-folder /yarn-cache \
    && gem install bundler \
    && bundle config mirror.https://rubygems.org https://gems.ruby-china.com \
    && bundle config force_ruby_platform true \
    && bundle config set without 'development test'

FROM base as node_modules
ENV NODE_ENV=production
# install node modules
COPY package.json yarn.lock /app/
RUN yarn

# ======== build gems image =======
FROM base as assets
# install Gems
COPY Gemfile Gemfile.lock /app/
COPY vendor/cache /app/vendor/cache
ARG BUNDLE_GEMS__TANMER__COM
RUN BUNDLE_GEMS__TANMER__COM="${BUNDLE_GEMS__TANMER__COM}" \
      bundle install -j $(nproc) --local
COPY .git .git
COPY --from=node_modules /app/node_modules /app/node_modules/
COPY --from=node_modules /yarn-cache /yarn-cache

RUN git checkout -- . \
    && rm -f package-lock.json \
    && cp config/application.example.yml config/application.yml \
    && RAILS_ENV=production \
       SECRET_KEY_BASE=xxx \
       DATABASE_ADAPTER=nulldb \
       bundle exec rails assets:precompile \
    && rm -rf .git

# ======== build rails image =======
FROM base as rails
EXPOSE 3000
ENV RAILS_ENV production
RUN rm -rf /usr/local/bundle
COPY --from=assets /usr/local/bundle /usr/local/bundle
COPY --from=assets /app/public/assets /app/public/assets
COPY .git .git
RUN git checkout -- . \
    && rm -rf .git vendor/cache \
    && apk del rails-build-deps

# && addgroup -S app && adduser -S -G app app && chown app:app -R /app

# # USER app
