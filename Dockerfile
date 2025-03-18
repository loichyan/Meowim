# Run docker build -t meowim:latest .
#       && docker run --rm -it meowim:latest
# or  docker build --target=base -t neovim:alpine-latest
#       && docker run --rm -it -v $PWD:/root/.config/nvim neovim:alpine-latest

FROM alpine:3.20 AS base

RUN apk add --no-cache --update \
    neovim~=0.10 alpine-sdk git ripgrep

ENTRYPOINT ["nvim"]

FROM base AS meowim

COPY . /root/.config/nvim
