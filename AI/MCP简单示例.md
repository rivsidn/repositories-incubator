
## 运行示例

```bash
$ https_proxy="" http_proxy="" uv run ollama_client.py /home/yuchao/demo/mcp/server/weather.py
[07/22/25 14:46:38] INFO     Processing request of type ListToolsRequest                                                                                                    server.py:625

Connected to server with tools: ['get_alerts', 'get_forecast']
Using Ollama model: qwen2.5:14b

Ollama-powered MCP Client Started!
Commands:
- Natural language queries (e.g., '加州的天气警报', 'weather forecast for 37.7749,-122.4194')
- 'model <name>' to switch models (e.g., 'model qwen2.5:7b')
- 'quit' to exit

Query: 加州天气
   
Calling tool: get_alerts with args: {'state': 'CA'}
[07/22/25 14:47:25] INFO     Processing request of type CallToolRequest                                                                                                     server.py:625
[07/22/25 14:47:26] INFO     HTTP Request: GET https://api.weather.gov/alerts/active/area/CA "HTTP/1.1 200 OK"                                                            _client.py:1740

Result: [TextContent(type='text', text='\nEvent: Coastal Flood Advisory\nArea: San Francisco; North Bay Interior Valleys; San Francisco Bay Shoreline\nSeverity: Minor\nDescription: * WHAT...Minor coastal flooding expected.\n\n* WHERE...San Francisco, North Bay Interior Valleys and San\nFrancisco Bay Shoreline Counties.\n\n* WHEN...From 8 PM Tuesday to 1 AM PDT Wednesday.\n\n* IMPACTS...Flooding of lots, parks, and roads with only\nisolated road closures expected.\n\n* ADDITIONAL DETAILS...Up to one foot inundation above ground\nlevel is possible in low lying areas near shorelines and tidal\nwaterways. At the San Francisco tidal gauge high tide is\nexpected to be 1.11 feet above normal (6.95 ft MLLW) at 9:57 PM\nPDT Tuesday. High tide timing varies up to 2 hours earlier or\nlater along the coast and throughout the Bay.\nInstructions: If travel is required, allow extra time as some roads may be\nclosed. Do not drive around barricades or through water of\nunknown depth. Take the necessary actions to protect flood-prone\nproperty.\n\n---\n\nEvent: Coastal Flood Advisory\nArea: San Francisco; North Bay Interior Valleys; San Francisco Bay Shoreline\nSeverity: Minor\nDescription: * WHAT...Minor coastal flooding expected.\n\n* WHERE...San Francisco, North Bay Interior Valleys and San\nFrancisco Bay Shoreline Counties.\n\n* WHEN...From 8 PM Tuesday to 1 AM PDT Wednesday.\n\n* IMPACTS...Flooding of lots, parks, and roads with only\nisolated road closures expected.\n\n* ADDITIONAL DETAILS...Up to one foot inundation above ground\nlevel is possible in low lying areas near shorelines and tidal\nwaterways. At the San Francisco tidal gauge high tide is\nexpected to be 1.11 feet above normal (6.95 ft MLLW) at 9:57 PM\nPDT Tuesday. High tide timing varies up to 2 hours earlier or\nlater along the coast and throughout the Bay.\nInstructions: If travel is required, allow extra time as some roads may be\nclosed. Do not drive around barricades or through water of\nunknown depth. Take the necessary actions to protect flood-prone\nproperty.\n', annotations=None, meta=None)]

Query: quit

```

## ollama设置

```bash

# 安装模型
ollama pull qwen2.5:14b

# 启动服务
ollama serve

# 测试服务是否正常启动
# 设置环境变量，确保不走本地代理
https_proxy="" http_proxy="" curl -s http://localhost:11434/api/generate -d '{
  "model": "qwen2.5:14b",
  "prompt": "你好！",
  "stream": false
}' | jq -r '.response'

# ollama的回复:
# 你好！有什么问题我可以帮助你解答吗？

```

## mcp_server设置

```bash

uv init server && cd server/

uv add "mcp[cli]" httpx

rm main.py 

# cp weather.py from github

# 测试(正常运行不报错即可)
uv run weather.py

```

## mcp_client设置

```bash
uv init client && cd client/
uv add mcp requests 

# cp ollama_client.py from somewhere

# 测试(输出提示信息)
uv run ollama_client.py 

```



## 附录

### ollama_client.py source code

需要修改`command` 为具体路径中的`python`.

```python

import asyncio
import json
import requests
from typing import Optional
from contextlib import AsyncExitStack

from mcp import ClientSession, StdioServerParameters
from mcp.client.stdio import stdio_client

class OllamaMCPClient:
    """MCP Client using local Ollama models"""
    
    def __init__(self, model_name: str = "qwen2.5:14b"):
        self.session: Optional[ClientSession] = None
        self.exit_stack = AsyncExitStack()
        self.model_name = model_name
        self.ollama_url = "http://localhost:11434/api/generate"
        
    async def connect_to_server(self, server_script_path: str):
        """Connect to an MCP server"""
        is_python = server_script_path.endswith('.py')
        is_js = server_script_path.endswith('.js')
        if not (is_python or is_js):
            raise ValueError("Server script must be a .py or .js file")
            
        command = "/home/yuchao/demo/mcp/server/.venv/bin/python" if is_python else "node"
        server_params = StdioServerParameters(
            command=command,
            args=[server_script_path],
            env=None
        )
        
        stdio_transport = await self.exit_stack.enter_async_context(stdio_client(server_params))
        self.stdio, self.write = stdio_transport
        self.session = await self.exit_stack.enter_async_context(ClientSession(self.stdio, self.write))
        
        await self.session.initialize()
        
        response = await self.session.list_tools()
        tools = response.tools
        print(f"\nConnected to server with tools: {[tool.name for tool in tools]}")
        print(f"Using Ollama model: {self.model_name}")
        
        # Store tools for reference
        self.available_tools = {}
        for tool in tools:
            self.available_tools[tool.name] = {
                "description": tool.description,
                "parameters": tool.inputSchema
            }

    def call_ollama(self, prompt: str) -> str:
        """Call Ollama API"""
        try:
            response = requests.post(self.ollama_url, json={
                "model": self.model_name,
                "prompt": prompt,
                "stream": False,
                "temperature": 0.1,
                "format": "json"
            })
            
            if response.status_code == 200:
                return response.json()['response']
            else:
                return f"Ollama error: {response.status_code}"
                
        except requests.exceptions.ConnectionError:
            return "Error: Cannot connect to Ollama. Please ensure 'ollama serve' is running."
        except Exception as e:
            return f"Error: {str(e)}"

    async def process_query(self, query: str) -> str:
        """Process query using Ollama"""
        # Create tool descriptions for the prompt
        tools_desc = "\n".join([
            f"- {name}: {info['description']}\n  Parameters: {info['parameters']}"
            for name, info in self.available_tools.items()
        ])
        
        # Prompt optimized for Qwen
        prompt = f"""你是一个工具调用助手。请将用户的自然语言查询转换为工具调用。

可用工具：
{tools_desc}

用户查询：{query}

请仅返回一个JSON对象，格式如下：
{{"tool": "工具名称", "args": {{"参数1": "值1", "参数2": "值2"}}}}

如果查询不匹配任何工具，返回：
{{"error": "没有找到匹配的工具"}}

注意：
- get_alerts 需要 state 参数（美国州名缩写，如 CA, NY）
- get_forecast 需要 latitude 和 longitude 参数（数字）"""

        # Call Ollama
        response_text = self.call_ollama(prompt)
        
        if "Cannot connect to Ollama" in response_text:
            return response_text
        
        try:
            # Parse JSON response
            tool_call = json.loads(response_text)
            
            if "error" in tool_call:
                return tool_call["error"]
            
            # Execute tool
            tool_name = tool_call["tool"]
            tool_args = tool_call["args"]
            
            print(f"\nCalling tool: {tool_name} with args: {tool_args}")
            result = await self.session.call_tool(tool_name, tool_args)
            return f"Result: {result.content}"
            
        except json.JSONDecodeError:
            return f"Failed to parse Ollama response: {response_text}"
        except Exception as e:
            return f"Error executing tool: {str(e)}"

    async def chat_loop(self):
        """Interactive chat loop"""
        print("\nOllama-powered MCP Client Started!")
        print("Commands:")
        print("- Natural language queries (e.g., '加州的天气警报', 'weather forecast for 37.7749,-122.4194')")
        print("- 'model <name>' to switch models (e.g., 'model qwen2.5:7b')")
        print("- 'quit' to exit")
        
        while True:
            try:
                query = input("\nQuery: ").strip()
                
                if query.lower() == 'quit':
                    break
                
                response = await self.process_query(query)
                print("\n" + response)
                    
            except KeyboardInterrupt:
                print("\nInterrupted by user")
                break
            except Exception as e:
                print(f"\nError: {str(e)}")
    
    async def cleanup(self):
        """Clean up resources"""
        await self.exit_stack.aclose()

async def main():
    import sys
    if len(sys.argv) < 2:
        print("Usage: python ollama_client.py <path_to_server_script> [model_name]")
        print("Example: python ollama_client.py weather.py qwen2.5:14b")
        sys.exit(1)
    
    # Get model name from args or use default
    model_name = sys.argv[2] if len(sys.argv) > 2 else "qwen2.5:14b"
    
    # Check if Ollama is running
    try:
        response = requests.get("http://localhost:11434/api/version")
        if response.status_code != 200:
            raise Exception("Ollama not responding")
    except:
        print("\nError: Ollama is not running!")
        print("Please start Ollama with: ollama serve")
        sys.exit(1)
        
    client = OllamaMCPClient(model_name)
    try:
        await client.connect_to_server(sys.argv[1])
        await client.chat_loop()
    finally:
        await client.cleanup()

if __name__ == "__main__":
    asyncio.run(main())
```

### 参考资料

- [mcp_quickstart For Server Developers](https://modelcontextprotocol.io/quickstart/server)
- [mcp_quickstart For Client Developers](https://modelcontextprotocol.io/quickstart/client)
- [quickstart-resources](https://github.com/modelcontextprotocol/quickstart-resources.git)

