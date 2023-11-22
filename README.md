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

## Running with Docker Compose

### Build from source code (Optional)

Prerequisites -

* Ubuntu, 22.04+
* Docker, 20.10.10+
* Docker Compose,  v2.12+

```
cd $ROOT_DIR
 ./cloudnative/admin/build.sh
 ./cloudnative/admin/push.sh
```

### Launch Services

```
cd $ROOT_DIR
 ./cloudnative/admin/start.sh
```

### Flush All

Re provison services, drop all data.

```
cd $ROOT_DIR
 ./cloudnative/admin/flush.sh
```

### Clean Logs

Drop all logs.

```
cd $ROOT_DIR
 ./cloudnative/admin/truncate.sh
```

## Contribute

TODO

# License

[GNU AFFERO GENERAL PUBLIC LICENSE](./LICENSE)