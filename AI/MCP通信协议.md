
## stdio模式

### 环境搭建

```bash

 # 创建工作目录
 uv init transport && cd transport

 # 添加mcp库
 uv add "mcp[cli]"

```

### 客户端

```python
#!/usr/bin/env python3

import asyncio
from mcp.client.stdio import stdio_client, StdioServerParameters
from mcp.client.session import ClientSession

async def main():
    params = StdioServerParameters(
        command="uv",
        args=["run", "python", "server.py"]
    )

    async with stdio_client(params) as streams:
        async with ClientSession(streams[0], streams[1]) as session:
            await session.initialize()

            tools = await session.list_tools()
            print(f"Available tools: {[t.name for t in tools.tools]}")

if __name__ == "__main__":
    asyncio.run(main())

```


### 服务器

```python
#!/usr/bin/env python3

import asyncio
from mcp.server.fastmcp import FastMCP

mcp = FastMCP("example-server")

@mcp.tool()
def add(a: int, b: int) -> int:
    """Add two numbers"""
    return a + b

if __name__ == "__main__":
    mcp.run()

```

### 运行

```bash
# 服务器作为客户端的子进程运行
uv run client.py
```

## HTTP模式

### 环境搭建

```bash
 # 创建工作目录
 uv init transport && cd transport

 # 添加mcp库
 uv add mcp[cli] fastapi httpx sse-starlette uvicorn

```

### 客户端

```bash

#!/usr/bin/env python3

import asyncio
from mcp.client.streamable_http import streamablehttp_client
from mcp.client.session import ClientSession

async def main():
    # 使用streamable HTTP客户端连接服务器
    async with streamablehttp_client("http://localhost:8000/mcp") as (read_stream, write_stream, _):
        async with ClientSession(read_stream, write_stream) as session:
            await session.initialize()

            # 列出可用工具
            tools = await session.list_tools()
            print(f"Available tools: {[t.name for t in tools.tools]}")

            # 调用add工具
            result = await session.call_tool("add", {"a": 5, "b": 3})
            print(f"5 + 3 = {result.content[0].text}")

if __name__ == "__main__":
    asyncio.run(main())

```

### 服务器

```bash

#!/usr/bin/env python3

from mcp.server.fastmcp import FastMCP

mcp = FastMCP("http-example-server")

@mcp.tool()
def add(a: int, b: int) -> int:
    """Add two numbers"""
    return a + b

if __name__ == "__main__":
    mcp.run(transport="streamable-http")

```

### 运行

```bash
# 服务器运行(需要运行在客户端之前运行)
uv run server.py

# 客户端运行(需要排除本地代理影响)
http_proxy="" https_proxy="" uv run python client.py

```

## 附录

### TODO

- 如何配置使支持

  > The server MAY write UTF-8 strings to its standard error (stderr) for logging purposes.
  > Clients MAY capture, forward, or ignore this logging.

- HTTP模式下，`client`、`server` 交互过程

- HTTP模式下认证

### 参考资料

- [Transports](https://modelcontextprotocol.io/specification/2025-06-18/basic/transports)


