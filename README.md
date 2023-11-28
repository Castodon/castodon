<div align=right>

[主页](https://github.com/Castodon/castodon)　|　[开源许可协议](https://github.com/Castodon/castodon/blob/develop/LICENSE)　|　[工单列表](https://github.com/castodon/castodon/issues)

</div>

# [Castodon](https://github.com/castodon/castodon)
[![CLA assistant](https://cla-assistant.io/readme/badge/Castodon/castodon)](https://cla-assistant.io/Castodon/castodon)

私域微博，企业微博，社区建设 -

* 类微博服务，支持用户分层，会员订阅
* Based on [mastodon](https://github.com/mastodon/mastodon), [readmore](https://github.com/castodon/castodon/tree/main)


## Helps

* [Issues](https://github.com/castodon/castodon/issues)

## Contribute

Pre-conditions, check out [https://docs.joinmastodon.org/dev/setup/](https://docs.joinmastodon.org/dev/setup/).

### Start Services

```
cp .env.development.sample .env # modify .env
./scripts/start-api-server.sh
./scripts/start-sidekiq.sh
./scripts/start-streaming-server.sh
./scripts/start-webpack.sh
```

Then, open `http://127.0.0.1:3000/home`.


# License

[GNU AFFERO GENERAL PUBLIC LICENSE](./LICENSE)