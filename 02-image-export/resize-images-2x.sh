#!/bin/bash

# ===============================================================
# 画像を2倍にリサイズするスクリプト（macOS 専用）
# ---------------------------------------------------------------
# ・対象OS: macOS（sips コマンドを使用）
# ・Windows 環境では使用しません
#   → Windows では WORKFLOW_02_IMAGE_RENAMING.md に記載の
#      「PowerShell + ImageMagick」の手順を使用してください
# ---------------------------------------------------------------
# 使用方法（例）:
#   ./resize-images-2x.sh src/images/interview/
# ===============================================================

# macOS 以外では実行させないためのガード
if [[ "$OSTYPE" != "darwin"* ]]; then
  echo "このスクリプトは macOS 専用です。Windows では使用しないでください。"
  exit 1
fi

# 画像を2倍にリサイズするメイン処理
# 使用方法: ./resize-images-2x.sh {画像ディレクトリ}/{ページ名}/

if [ -z "$1" ]; then
  echo "使用方法: $0 {画像ディレクトリ}/{ページ名}/"
  echo "例: $0 src/images/interview/"
  exit 1
fi

TARGET_DIR="$1"

if [ ! -d "$TARGET_DIR" ]; then
  echo "エラー: ディレクトリが見つかりません: $TARGET_DIR"
  exit 1
fi

cd "$TARGET_DIR" || exit 1

echo "画像を2倍にリサイズ中: $TARGET_DIR"

for file in *.png *.jpg *.jpeg; do
  if [ -f "$file" ]; then
    echo "処理中: $file"
    # 現在の解像度を取得
    width=$(sips -g pixelWidth "$file" 2>/dev/null | grep pixelWidth | awk '{print $2}')
    height=$(sips -g pixelHeight "$file" 2>/dev/null | grep pixelHeight | awk '{print $2}')
    
    if [ -n "$width" ] && [ -n "$height" ]; then
      # 2倍にリサイズ（元のファイルを上書き）
      sips -z $((height * 2)) $((width * 2)) "$file" > /dev/null 2>&1
      if [ $? -eq 0 ]; then
        echo "  ✓ 完了: ${width}x${height} → $((width * 2))x$((height * 2))"
      else
        echo "  ✗ エラー: $file"
      fi
    else
      echo "  ⚠ スキップ: $file (画像情報を取得できませんでした)"
    fi
  fi
done

echo "リサイズ完了"

