#!/usr/bin/env bash
# =============================================================================
# 一键上传 astrbot_plugin_server_ops 到 GitHub
#
# 用法：
#   1) 在 GitHub 生成 Personal Access Token（Settings → Developer settings
#      → Tokens (classic) → Generate new token，勾选 repo 权限）
#   2) 执行：
#        GH_USER=你的用户名 GH_TOKEN=你的token ./upload_to_github.sh
#      或：
#        ./upload_to_github.sh 你的用户名 你的token
#
# 默认仓库名：astrbot_plugin_server_ops（可用环境变量 REPO_NAME 覆盖）
# 默认公开仓库；想建私有仓库：REPO_PRIVATE=1 ./upload_to_github.sh ...
# =============================================================================
set -euo pipefail

GH_USER="${GH_USER:-${1:-}}"
GH_TOKEN="${GH_TOKEN:-${2:-}}"
REPO_NAME="${REPO_NAME:-astrbot_plugin_server_ops}"
PRIVATE_FLAG=$([ "${REPO_PRIVATE:-0}" = "1" ] && echo "true" || echo "false")
PLUGIN_DIR="$(cd "$(dirname "$0")/../astrbot_plugin_server_ops" && pwd)"

if [ -z "$GH_USER" ] || [ -z "$GH_TOKEN" ]; then
  echo "❌ 缺少参数。用法：GH_USER=xxx GH_TOKEN=yyy $0"
  exit 1
fi

echo "==> 检查/创建 GitHub 仓库 $GH_USER/$REPO_NAME ..."
CREATE_RESP=$(curl -s -o /tmp/gh_create.json -w "%{http_code}" \
  -X POST "https://api.github.com/user/repos" \
  -H "Authorization: token $GH_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"name\":\"$REPO_NAME\",\"private\":$PRIVATE_FLAG,\"description\":\"AstrBot 服务器管理工具包插件：系统状态/服务/日志/安全shell/插件能力索引（LLM 工具）\"}")
if [ "$CREATE_RESP" = "201" ]; then
  echo "✅ 仓库创建成功"
elif [ "$CREATE_RESP" = "422" ]; then
  echo "ℹ️  仓库已存在，直接推送"
else
  echo "⚠️  创建仓库响应码 $CREATE_RESP，继续尝试推送（可能是权限或网络问题）"
fi

echo "==> 配置 git 身份 ..."
cd "$PLUGIN_DIR"
git config user.name "${GH_USER}"
git config user.email "${GH_USER}@users.noreply.github.com"

echo "==> 推送代码 ..."
REPO_URL="https://${GH_USER}:${GH_TOKEN}@github.com/${GH_USER}/${REPO_NAME}.git"
git push -u "$REPO_URL" main 2>&1 | grep -v "^remote: Resolving" || true

echo ""
echo "🎉 完成！仓库地址：https://github.com/${GH_USER}/${REPO_NAME}"
echo "   使用说明见仓库 README.md 与增强包内《增强说明.md》"
