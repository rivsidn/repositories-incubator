







































```
MCP Server Module
MCP 服务器模块

This module provides a framework for creating an MCP (Model Context Protocol) server.
It allows you to easily define and handle various types of requests and notifications
in an asynchronous manner.
该模块提供了MCP 服务器框架.
允许你在异步情况下定义、处理各种请求和通知.

Usage:
使用方法:
1. Create a Server instance:
   服务器创建:
   server = Server("your_server_name")

2. Define request handlers using decorators:
   通过装饰器定义请求处理函数:
   @server.list_prompts()
   async def handle_list_prompts() -> list[types.Prompt]:
       # Implementation

   指定函数类型，这里的None 表示参数可以为None
   @server.get_prompt()
   async def handle_get_prompt(
       name: str, arguments: dict[str, str] | None
   ) -> types.GetPromptResult:
       # Implementation

   @server.list_tools()
   async def handle_list_tools() -> list[types.Tool]:
       # Implementation

   工具调用
   @server.call_tool()
   async def handle_call_tool(
       name: str, arguments: dict | None
   ) -> list[types.TextContent | types.ImageContent | types.EmbeddedResource]:
       # Implementation

   资源模板
   @server.list_resource_templates()
   async def handle_list_resource_templates() -> list[types.ResourceTemplate]:
       # Implementation

3. Define notification handlers if needed:
   定义通知处理
   @server.progress_notification()
   async def handle_progress(
       progress_token: str | int, progress: float, total: float | None,
       message: str | None
   ) -> None:
       # Implementation
       # 实现

4. Run the server:
   服务器运行:
   async def main():
       async with mcp.server.stdio.stdio_server() as (read_stream, write_stream):
           await server.run(
               read_stream,
               write_stream,
               InitializationOptions(
                   server_name="your_server_name",
                   server_version="your_version",
                   capabilities=server.get_capabilities(
                       notification_options=NotificationOptions(),
                       experimental_capabilities={},
                   ),
               ),
           )

   # 运行main()
   asyncio.run(main())

The Server class provides methods to register handlers for various MCP requests and
notifications. It automatically manages the request context and handles incoming
messages from the client.

Server 类提供了用于注册请求和通知的方法，Server 会自动管理请求上下文并处理到来的请求.

```



## 附录

### TODO

from AI, 待整理.

> ● 这个server.py文件是MCP (Model Context Protocol) 低级服务器的核心实现，提供了以下主要功能：
> 
>   1. MCP协议服务器框架
> 
>   - 实现完整的MCP服务器，支持异步请求-响应模式
>   - 处理客户端连接、初始化、消息路由等底层协议细节
> 
>   2. 装饰器注册系统
> 
>   提供装饰器来注册各种MCP处理器：
>   - @server.list_prompts() - 提示列表处理
>   - @server.get_prompt() - 获取特定提示
>   - @server.list_tools() - 工具列表处理
>   - @server.call_tool() - 工具调用（支持输入/输出验证）
>   - @server.list_resources() - 资源列表处理
>   - @server.read_resource() - 资源读取处理
>   - @server.completion() - 自动补全功能
> 
>   3. 工具系统增强功能
> 
>   - 工具缓存机制 (_tool_cache) - 缓存工具定义提高性能
>   - JSON Schema验证 - 自动验证工具的输入/输出
>   - 多种返回格式支持 - 支持结构化、非结构化和混合内容返回
>   - 错误处理 - 统一的错误响应格式
> 
>   4. 能力发现机制
> 
>   - get_capabilities() 根据已注册处理器自动生成服务器能力声明
>   - 支持提示、资源、工具、日志、补全等各种MCP能力
> 
>   5. 请求上下文管理
> 
>   - 提供RequestContext访问会话状态和生命周期对象
>   - 支持异步上下文管理器进行资源初始化/清理
> 
>   6. 生命周期管理
> 
>   - 支持自定义生命周期上下文管理器
>   - 异步消息处理循环
>   - 优雅的错误处理和资源清理
> 
>   你代码中的一些问题：
>   1. 第650行异常处理过于宽泛 - 使用通用Exception可能掩盖具体错误
>   2. 工具缓存线程安全性 - 在并发环境下缓存更新可能有竞态条件
>   3. 缺少工具缓存过期机制 - 可能导致内存泄漏
> 
>   建议改进方向：
>   - 使用更具体的异常类型
>   - 添加工具缓存的TTL机制
>   - 增强并发安全性控制

