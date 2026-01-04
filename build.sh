#!/bin/bash
# build.sh - 一键打包 VSIX 插件
# 使用方法: ./build.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VERSION=$(grep '"version"' "$SCRIPT_DIR/package.json" | sed 's/.*"version": "\([^"]*\)".*/\1/')
OUTPUT_FILE="claude-code-image-paste-wsl-$VERSION.vsix"

echo "🔨 Building Claude Code Image Paste (WSL) v$VERSION..."

# 创建临时目录
TEMP_DIR=$(mktemp -d)
mkdir -p "$TEMP_DIR/extension"

# 复制文件
echo "📦 Copying files..."
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

# 打包
echo "🗜️  Creating VSIX package..."
cd "$TEMP_DIR"
zip -rq "$OUTPUT_FILE" '[Content_Types].xml' extension.vsixmanifest extension/
cp "$OUTPUT_FILE" "$SCRIPT_DIR/"

# 清理
rm -rf "$TEMP_DIR"

echo ""
echo "✅ Successfully built: $SCRIPT_DIR/$OUTPUT_FILE"
echo ""
echo "📥 To install:"
echo "   1. Cursor: Ctrl+Shift+P → 'Extensions: Install from VSIX...'"
echo "   2. Select: $OUTPUT_FILE"
echo "   3. Reload: Ctrl+Shift+P → 'Developer: Reload Window'"

