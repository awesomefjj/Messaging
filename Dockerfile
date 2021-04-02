# ======== build common image =======
FROM uhub.service.ucloud.cn/tamigosmirrors/ruby:2.5.8-alpine3.13 as base
LABEL maintainer="xiaohui@tanmer.com"

WORKDIR /app
RUN mkdir -p /app \
    && sed -i 's!https://dl-cdn.alpinelinux.org!https://mirrors.aliyun.com!' /etc/apk/repositories \
    && apk add tzdata postgresql-dev ruby-nokogiri ruby-ffi \
       postgresql-dev libxml2-dev libxslt-dev nodejs-current \
    && apk add --virtual rails-build-deps \
       build-base ruby-dev libc-dev linux-headers \
       git yarn python2 \
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
RUN echo 'https://mirrors.aliyun.com/alpine/edge/community' >> /etc/apk/repositories \
    && apk -u add yarn \
    && yarn

# ======== build gems image =======
FROM base as assets
# install Gems
COPY Gemfile Gemfile.lock /app/
COPY vendor/cache /app/vendor/cache
ARG BUNDLE_GEMS__TANMER__COM
RUN BUNDLE_GEMS__TANMER__COM="${BUNDLE_GEMS__TANMER__COM}" \
      bundle config build.nokogiri --use-system-libraries \
      && bundle install -j $(nproc) --local
COPY .git .git
COPY --from=node_modules /app/node_modules /app/node_modules/
COPY --from=node_modules /yarn-cache /yarn-cache

# 提供给 sentry brower 的参数: dsn, release
ARG RELEASE_COMMIT
ARG SENTRY_JS_DSN
ENV RELEASE_COMMIT=${RELEASE_COMMIT}
ENV SENTRY_JS_DSN=${SENTRY_JS_DSN}

RUN git checkout -- . \
    && rm -f package-lock.json \
    && RAILS_ENV=production \
       SECRET_KEY_BASE=xxx \
       DATABASE_ADAPTER=nulldb \
       bundle exec rails assets:precompile \
    && rm -rf .git

# ======== build rails image =======
FROM base as rails
EXPOSE 3000
RUN rm -rf /usr/local/bundle
COPY --from=assets /usr/local/bundle /usr/local/bundle
COPY --from=assets /app/public/assets /app/public/assets
COPY .git .git
RUN git checkout -- . \
    && rm -rf .git vendor/cache \
    && apk del rails-build-deps

ARG RELEASE_BRANCH
ARG RELEASE_COMMIT
ENV RELEASE_BRANCH=${RELEASE_BRANCH}
ENV RELEASE_COMMIT=${RELEASE_COMMIT}

RUN addgroup -S app && adduser -S -G app app && chown app:app -R /app
USER app
