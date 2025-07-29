
常用API.






# 附录

## TODO

## MISCS

>  第一步：运行示例
>  # 测试快速示例
>  uv run mcp dev examples/snippets/servers/fastmcp_quickstart.py
>
>  # 或者用MCP Inspector调试
>  uv run mcp dev server.py
>
>  第二步：探索核心例子
>  - examples/snippets/servers/basic_tool.py - 工具实现
>  - examples/snippets/servers/basic_resource.py - 资源实现
>  - examples/snippets/servers/basic_prompt.py - 提示模板
>  - examples/snippets/clients/stdio_client.py - 客户端使用
>
>  第三步：学习高级特性
>  - examples/snippets/servers/structured_output.py - 结构化输出
>  - examples/snippets/servers/elicitation.py - 用户交互
>  - examples/snippets/servers/sampling.py - LLM采样
>  - examples/snippets/servers/oauth_server.py - 认证
>
>  4. 实际项目结构
>
>  - src/mcp/server/fastmcp/ - 高级服务器API
>  - src/mcp/server/lowlevel/ - 底层服务器实现
>  - src/mcp/client/ - 客户端实现
>  - src/mcp/types.py - 核心类型定义
>
>  5. 开发和测试
>
>  - 使用uv而不是pip管理依赖
>  - 代码格式化：uv run --frozen ruff format .
>  - 类型检查：uv run --frozen pyright
>  - 运行测试：uv run --frozen pytest
>
>  6. 实用命令
>
>  # 开发模式运行服务器
>  uv run mcp dev your_server.py
>
>  # 安装到Claude Desktop
>  uv run mcp install your_server.py
>
>  # 查看帮助
>  uv run mcp --help
>
>  建议从快速示例开始，逐步深入到复杂特性。有什么具体问题随时问我！

