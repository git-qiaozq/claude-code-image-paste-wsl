# Claude Code Image Paste (WSL) - 构建和使用指南

## 📦 如何打包 VSIX 插件

### 方法 1：使用 vsce 工具（推荐）

```bash
# 1. 安装 vsce 工具
npm install -g @vscode/vsce

# 2. 进入插件目录
cd /home/qiaozq/study/AI/claude-code-utils/claude-code-image-paste-wsl

# 3. 打包
vsce package --allow-missing-repository

# 生成文件：claude-code-image-paste-wsl-1.2.0.vsix
```

### 方法 2：手动打包（无需 vsce）

VSIX 文件本质上是 ZIP 文件，可以手动创建：

```bash
# 1. 进入插件目录
cd /home/qiaozq/study/AI/claude-code-utils/claude-code-image-paste-wsl

# 2. 创建临时打包目录
mkdir -p /tmp/vsix-build/extension

# 3. 复制必要文件
cp package.json extension.js icon.png LICENSE README.md CHANGELOG.md /tmp/vsix-build/extension/

# 4. 创建 [Content_Types].xml
cat > /tmp/vsix-build/'[Content_Types].xml' << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension=".json" ContentType="application/json"/>
  <Default Extension=".js" ContentType="application/javascript"/>
  <Default Extension=".png" ContentType="image/png"/>
  <Default Extension=".md" ContentType="text/markdown"/>
  <Default Extension=".txt" ContentType="text/plain"/>
  <Default Extension=".vsixmanifest" ContentType="text/xml"/>
</Types>
EOF

# 5. 创建 extension.vsixmanifest（根据 package.json 中的版本号修改）
cat > /tmp/vsix-build/extension.vsixmanifest << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<PackageManifest Version="2.0.0" xmlns="http://schemas.microsoft.com/developer/vsx-schema/2011">
  <Metadata>
    <Identity Language="en-US" Id="claude-code-image-paste-wsl" Version="1.2.0" Publisher="melon-hub"/>
    <DisplayName>Claude Code Image Paste (WSL)</DisplayName>
    <Description xml:space="preserve">Paste images from clipboard into VS Code/Cursor terminal for Claude Code conversations.</Description>
    <Tags>claude,image,paste,wsl</Tags>
    <Categories>Other</Categories>
    <GalleryFlags>Public</GalleryFlags>
    <Properties>
      <Property Id="Microsoft.VisualStudio.Code.Engine" Value="^1.74.0"/>
      <Property Id="Microsoft.VisualStudio.Code.ExtensionDependencies" Value=""/>
      <Property Id="Microsoft.VisualStudio.Code.ExtensionPack" Value=""/>
      <Property Id="Microsoft.VisualStudio.Code.LocalizedLanguages" Value=""/>
    </Properties>
    <Icon>extension/icon.png</Icon>
  </Metadata>
  <Installation>
    <InstallationTarget Id="Microsoft.VisualStudio.Code"/>
  </Installation>
  <Dependencies/>
  <Assets>
    <Asset Type="Microsoft.VisualStudio.Code.Manifest" Path="extension/package.json" Addressable="true"/>
    <Asset Type="Microsoft.VisualStudio.Services.Icons.Default" Path="extension/icon.png" Addressable="true"/>
  </Assets>
</PackageManifest>
EOF

# 6. 打包为 VSIX
cd /tmp/vsix-build
zip -r claude-code-image-paste-wsl-1.2.0.vsix '[Content_Types].xml' extension.vsixmanifest extension/

# 7. 复制到插件目录
cp claude-code-image-paste-wsl-1.2.0.vsix /home/qiaozq/study/AI/claude-code-utils/claude-code-image-paste-wsl/
```

### 一键打包脚本

创建 `build.sh` 脚本：

```bash
#!/bin/bash
# build.sh - 一键打包 VSIX 插件

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VERSION=$(grep '"version"' "$SCRIPT_DIR/package.json" | sed 's/.*"version": "\([^"]*\)".*/\1/')
OUTPUT_FILE="claude-code-image-paste-wsl-$VERSION.vsix"

echo "🔨 Building version $VERSION..."

# 创建临时目录
TEMP_DIR=$(mktemp -d)
mkdir -p "$TEMP_DIR/extension"

# 复制文件
cp "$SCRIPT_DIR/package.json" "$TEMP_DIR/extension/"
cp "$SCRIPT_DIR/extension.js" "$TEMP_DIR/extension/"
cp "$SCRIPT_DIR/icon.png" "$TEMP_DIR/extension/"
cp "$SCRIPT_DIR/LICENSE" "$TEMP_DIR/extension/"
cp "$SCRIPT_DIR/README.md" "$TEMP_DIR/extension/"
cp "$SCRIPT_DIR/CHANGELOG.md" "$TEMP_DIR/extension/"

# 创建 [Content_Types].xml
cat > "$TEMP_DIR/[Content_Types].xml" << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension=".json" ContentType="application/json"/>
  <Default Extension=".js" ContentType="application/javascript"/>
  <Default Extension=".png" ContentType="image/png"/>
  <Default Extension=".md" ContentType="text/markdown"/>
  <Default Extension=".txt" ContentType="text/plain"/>
  <Default Extension=".vsixmanifest" ContentType="text/xml"/>
</Types>
EOF

# 创建 extension.vsixmanifest
cat > "$TEMP_DIR/extension.vsixmanifest" << EOF
<?xml version="1.0" encoding="utf-8"?>
<PackageManifest Version="2.0.0" xmlns="http://schemas.microsoft.com/developer/vsx-schema/2011">
  <Metadata>
    <Identity Language="en-US" Id="claude-code-image-paste-wsl" Version="$VERSION" Publisher="melon-hub"/>
    <DisplayName>Claude Code Image Paste (WSL)</DisplayName>
    <Description xml:space="preserve">Paste images from clipboard into VS Code/Cursor terminal for Claude Code conversations.</Description>
    <Tags>claude,image,paste,wsl</Tags>
    <Categories>Other</Categories>
    <GalleryFlags>Public</GalleryFlags>
    <Properties>
      <Property Id="Microsoft.VisualStudio.Code.Engine" Value="^1.74.0"/>
    </Properties>
    <Icon>extension/icon.png</Icon>
  </Metadata>
  <Installation>
    <InstallationTarget Id="Microsoft.VisualStudio.Code"/>
  </Installation>
  <Dependencies/>
  <Assets>
    <Asset Type="Microsoft.VisualStudio.Code.Manifest" Path="extension/package.json" Addressable="true"/>
    <Asset Type="Microsoft.VisualStudio.Services.Icons.Default" Path="extension/icon.png" Addressable="true"/>
  </Assets>
</PackageManifest>
EOF

# 打包
cd "$TEMP_DIR"
zip -r "$OUTPUT_FILE" '[Content_Types].xml' extension.vsixmanifest extension/
cp "$OUTPUT_FILE" "$SCRIPT_DIR/"

# 清理
rm -rf "$TEMP_DIR"

echo "✅ Built: $SCRIPT_DIR/$OUTPUT_FILE"
```

使用方法：

```bash
chmod +x build.sh
./build.sh
```

---

## 📥 如何安装插件

### 方法 1：通过命令面板安装

1. 打开 Cursor/VS Code
2. 按 `Ctrl+Shift+P` 打开命令面板
3. 输入 `Extensions: Install from VSIX...`
4. 选择 `.vsix` 文件

### 方法 2：通过命令行安装

```bash
# Cursor
cursor --install-extension claude-code-image-paste-wsl-1.2.0.vsix

# VS Code
code --install-extension claude-code-image-paste-wsl-1.2.0.vsix
```

### 方法 3：从 Windows 安装 WSL 中的插件

```powershell
# 在 Windows PowerShell 中
cursor --install-extension "\\wsl$\Ubuntu\home\qiaozq\study\AI\claude-code-utils\claude-code-image-paste-wsl\claude-code-image-paste-wsl-1.2.0.vsix"
```

---

## ⚙️ 插件配置

在 Cursor/VS Code 设置中 (`Ctrl+,`) 搜索 `claudeImagePaste`：

| 配置项 | 默认值 | 说明 |
|--------|--------|------|
| `claudeImagePaste.saveDirectory` | `""` | 图片保存目录。留空使用临时目录；支持 `~` 和相对路径 |
| `claudeImagePaste.skipRenamePrompt` | `false` | 跳过重命名提示 |
| `claudeImagePaste.maxImages` | `10` | 保存目录中最多保留的图片数量 |
| `claudeImagePaste.filenamePrefix` | `img_` | 自动生成的文件名前缀 |

### 推荐配置

```json
{
    "claudeImagePaste.saveDirectory": ".claude-images",
    "claudeImagePaste.skipRenamePrompt": true,
    "claudeImagePaste.maxImages": 20
}
```

---

## 🎯 使用方法

1. **复制图片**：截图或复制图片文件
2. **打开终端**：确保 Claude Code 终端已激活
3. **粘贴**：按 `Ctrl+Alt+V`
4. **完成**：图片路径会自动插入到终端

---

## 🔧 故障排除

### 问题：中文用户名导致的路径问题

**症状**：报错 "Save directory could not be accessed"，路径中显示乱码

**原因**：Windows 用户名包含中文，PowerShell 输出到 Node.js 时编码出错

**解决方案**：已在 v1.2.0 中修复，使用 `C:\Windows\Temp` 替代用户临时目录

### 问题：WSL 项目中无法保存图片

**症状**：在 Windows Cursor 中打开 WSL 项目，保存失败

**原因**：路径格式转换问题

**解决方案**：已在 v1.2.0 中修复，支持 WSL UNC 路径

---

## 📝 开发说明

### 目录结构

```
claude-code-image-paste-wsl/
├── extension.js      # 主逻辑代码
├── package.json      # 插件配置
├── CHANGELOG.md      # 更新日志
├── README.md         # 使用说明
├── BUILD.md          # 构建指南（本文件）
├── LICENSE           # MIT 许可证
└── icon.png          # 插件图标
```

### 核心函数

| 函数 | 说明 |
|------|------|
| `getImageFromClipboard()` | 使用 PowerShell 从剪贴板获取图片 |
| `handleCustomSaveDirectory()` | 处理自定义保存目录 |
| `windowsToWslPath()` | Windows 路径转 WSL 路径 |
| `isWslUncPath()` | 检测是否是 WSL UNC 路径 |

### 修改代码后测试

1. 修改 `extension.js`
2. 运行 `./build.sh` 重新打包
3. 在 Cursor 中重新安装插件
4. 按 `Ctrl+Shift+P` → `Developer: Reload Window`

---

## 🔗 相关链接

- **Fork 仓库**：https://github.com/git-qiaozq/claude-code-image-paste-wsl
- **原始仓库**：https://github.com/melon-hub/claude-code-image-paste-wsl
- **修复分支**：`fix/unicode-path-and-wsl-unc`

