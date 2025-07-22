
## 安装

```bash

 # ollama 安装
 curl -fsSL https://ollama.com/install.sh | sh

 # 模型下载
 ollama pull <模型名>  # 例如：ollama pull llama3

```


## 使用

```bash

 # 查看已安装模型
 ollama list

 # 终端运行模型
 ollama run <模型名>

 # 启动服务
 # 不需要指定使用哪个模型，API请求时明确指定模型名称
 ollama serve
```

## API调用

### curl命令行测试

```bash
curl -s http://localhost:11434/api/generate -d '{
  "model": "qwen2.5:14b",
  "prompt": "你好！",
  "stream": false
}' | jq -r '.response'

```

