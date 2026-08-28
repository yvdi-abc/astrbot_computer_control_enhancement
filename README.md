# AstrBot 电脑控制 + 插件编排增强包

> **作者：yvdi-abc（yudi）** · 2026-08-28

本仓库是 AstrBot「电脑控制 + 插件编排」整套增强的说明与打包：

- **插件**：[astrbot_plugin_server_ops](https://github.com/yvdi-abc/astrbot_plugin_server_ops)（服务器管理工具包，9 个 LLM 工具 + 2 个指令，42/42 测试通过）
- **《增强说明.md》**：全部改动清单（内置 Computer Use 启用、tool_schema_mode=skills_like 省 token、simple_memory 记忆周期注入、关键工具重新激活、管理员配置）
- **upload_to_github.sh**：一键上传脚本

## 增强包含什么

1. 服务器管理工具包插件（系统状态 / 磁盘 / 进程 / systemd 服务 / 日志 / 安全 shell / 插件能力索引 / AstrBot 状态 / gsuid_core 状态）
2. AstrBot 配置优化：`computer_use_runtime=local`、`tool_schema_mode=skills_like`
3. simple_memory 记忆注入改每 30 轮一次（省 ~95% 记忆 token）
4. 重新激活被停用的关键记忆工具

详见《增强说明.md》。
