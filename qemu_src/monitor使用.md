

## monitor使用

### HMP使用

包括几种链接方式:

* 字符界面
* 图形界面
* [TCP链接](#TCP链接)
* Unixt套接字

#### TCP链接

```bash
# 启动qemu，可以通过TCP端口访问
qemu-system-x86_64 -monitor tcp:127.0.0.1:4444,server,nowait

# 通过telnet访问
telnet 127.0.0.1 4444
```


### QMP使用


