
## MCP特性支持

- Resources
- Prompts
- Tools
- Discovery
- Sampling
- Roots
- Elicitation




`MCP` 提供AI模型和不同数据源和工具的标准链接方式.

| 角色        | 功能                                       |
|-------------|--------------------------------------------|
| MCP Host    | 能够通过MCP协议访问特定数据的工具          |
| MCP Clients | 客户端，与服务器维持1:1关系                |
| MCP Servers | 服务器，通过MCP 服务器暴露特定能力给客户端 |


```

  +-------------+                   +--------------+
  |     LLM     |                   |  MCP server  |
  +-------------+                   +--------------+
         ^                                  ^
         |                                  |
         |                                  |
         |                                  |
         v                                  v
  +-------------+                   +--------------+
  | Claude code | <---------------> |  MCP client  |
  +-------------+                   +--------------+

```


## MCP服务器

1. 资源
   客户端可读的资源
2. 工具
   LLM可以调用的工具
3. 提示词
   可以帮助用户实现特定任务的预置提示词




## 附录

### 参考资料

* [MCP](https://modelcontextprotocol.io/introduction)

