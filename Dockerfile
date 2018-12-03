FROM elixir:1.6.6
ARG NODEREPO="node_10.x"
ARG DISTRO="stretch"
ARG APP_NAME=accent
ARG PHOENIX_SUBDIR=.
ENV MIX_ENV=prod REPLACE_OS_VARS=true TERM=xterm
WORKDIR /opt/app
RUN apt update && apt upgrade -y \
    && apt install -y git nodejs-legacy build-essential nodejs libyaml-dev apt-transport-https \
    && mix local.rebar --force \
    && mix local.hex --force
# https://github.com/nodesource/distributions/issues/529
RUN curl -sSO https://deb.nodesource.com/gpgkey/nodesource.gpg.key
RUN apt-key add nodesource.gpg.key
RUN echo "deb https://deb.nodesource.com/${NODEREPO} ${DISTRO} main" > /etc/apt/sources.list.d/nodesource.list
RUN echo "deb-src https://deb.nodesource.com/${NODEREPO} ${DISTRO} main" >> /etc/apt/sources.list.d/nodesource.list
RUN apt-get update -q && apt-get install -y 'nodejs=10.*' && npm i -g npm@5
RUN git clone https://github.com/fire/accent.git && \
  mv accent/* ./ && \
  mv accent/.[!.]* ./
RUN mix do deps.get, deps.compile, compile
RUN npm --prefix webapp install
RUN mix release --env=prod --verbose \
    && mv _build/prod/rel/${APP_NAME} /opt/release \
    && mv /opt/release/bin/${APP_NAME} /opt/release/bin/start_server
FROM debian:stretch
RUN apt update && apt upgrade -y && apt install -y bash libssl-dev libyaml-0-2 locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8
ENV PORT=4000 WEBAPP_PORT=4200 MIX_ENV=prod REPLACE_OS_VARS=true
WORKDIR /opt/app
EXPOSE ${PORT}
EXPOSE ${WEBAPP_PORT}
COPY --from=0 /opt/release .
CMD ["/opt/app/bin/start_server", "foreground"]