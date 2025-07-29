
## fastmcp_quickstart

```bash
 # 执行命令
 uv run mcp dev examples/snippets/servers/fastmcp_quickstart.py
```

这里的`dev` 表示mcp 的 dev 模式.

命令执行之后，可以启动 调试器，通过web 进行mcp 调试.

通过web 进行serve 调试过程:

- 后台启动服务
- 浏览器连接服务器
- 配置中添加 Token 连接即可

### 添加到claude code

```bash
 # 添加到claude 执行
 claude mcp add fastmcp uv run mcp run examples/snippets/servers/fastmcp_quickstart.py
```

## 结构化输出



