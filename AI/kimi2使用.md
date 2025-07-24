
kimi2 是国内 moonshot 发布的一个国产化大模型，兼容claude code API，兼容claude
code API，可以基于claude code 使用kimi2 ，需要以下几个步骤.

### 申请token

[moonshot console](https://platform.moonshot.cn/console/api-keys) 申请token.

注意这里的官网是cn ，翻墙用户可能会登录到国外网址，目前通过国外网址没有设置成功.

### 设置环境变量

设置环境变量.

```bash
export ANTHROPIC_AUTH_TOKEN="sk----"
export ANTHROPIC_BASE_URL="https://api.moonshot.cn/anthropic"
```

注意这里的是cn，不要弄混.

### 设置别名自动启动

.bashrc 中添加别名.

```bash
# AI工具设置
alias kimi='ANTHROPIC_AUTH_TOKEN="sk----" ANTHROPIC_BASE_URL="https://api.moonshot.cn/anthropic" claude'
```

这样就输入 kimi 就可以直接启动kimi 赋能的claude code 了.

