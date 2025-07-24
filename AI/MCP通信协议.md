


## 基本原理



## 标准输入输出

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
            print("client initialize successful")

if __name__ == "__main__":
    asyncio.run(main())

```


### 服务器

```python
#!/usr/bin/env python3

import asyncio
from mcp.server import Server
from mcp.server.stdio import stdio_server

app = Server("example-server")

async def main():
    async with stdio_server() as streams:
        await app.run(
            streams[0],
            streams[1],
            app.create_initialization_options()
        )

if __name__ == "__main__":
    asyncio.run(main())

```

## 流式HTTP


