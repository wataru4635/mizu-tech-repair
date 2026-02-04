# 工程 2: 画像のダウンロードと命名

※本手順は **Windows（PowerShell）前提** です。

## 概要

Figma MCP 経由で画像をダウンロードし、わかりやすい命名規則に従ってリネームします。
最重要：構築に必要な画像のみダウンロードしてください。

適宜、mcp-logフォルダのコンテキストを参照しながらリネームを実施してください。

**注意**: プロジェクトによって画像ディレクトリのパスが異なる場合があります（例: `src/images/`, `assets/images/`, `images/` など）。

## 前提条件

- Figma MCP が接続されていること
- Figma で対象のノードが選択されていること

## 命名規則

```
{セクション名}_{連番}.{拡張子}
```

### セクション名の例

**注意**: セクション名はプロジェクトごとに異なります。Figma のデザイン構造に従って、適切なセクション名を使用してください。

命名例：

- **Header**: `header_01.png`, `header_02.png`, `header_03.svg`
- **FV / Hero**: `fv_01.png`, `fv_02.svg`, `hero_01.png`
- **Search**: `search_01.svg`, `search_02.png`
- **News**: `news_01.svg`, `news_02.png`
- **Pickup / Featured**: `pickup_01.png`, `featured_01.png`
- **Map / Location**: `map_01.png`
- **Slider / Carousel**: `slider_01.png`, `carousel_01.png`
- **Gallery**: `gallery_01.png`, `gallery_02.png`
- **Info**: `info_01.svg`, `info_02.png`
- **Footer**: `footer_01.svg`, `footer_02.svg`
- **Common**: `common_logo.png`, `common_icon.svg`

## 手順

### 1. ページディレクトリの作成

画像をダウンロードする前に、対象ページ用のディレクトリを作成します。

#### Windows の例（PowerShell）
```powershell
# 例: page-company.php の場合
New-Item -ItemType Directory -Force "src/images/company" | Out-Null

# 例: page-contact.php の場合
New-Item -ItemType Directory -Force "src/images/contact" | Out-Null

# 例: page-service.php の場合
New-Item -ItemType Directory -Force "src/images/service" | Out-Null

# 共通画像の場合は common ディレクトリを使用
New-Item -ItemType Directory -Force "src/images/common" | Out-Null
```

**注意**: ディレクトリ名は `page-{ページ名}.php` の `{ページ名}` 部分を使用します（例: `page-company.php` → `company`）。

### 2. Figma から画像をダウンロード（MCP 経由）

Figma で対象のノードを選択し、MCP 経由で画像をダウンロードします。

#### 2-1. Figma でノードを選択

1. Figma Desktop アプリを開く
2. ダウンロードしたい画像を含むノード（フレーム、コンポーネント、グループなど）を選択
3. 複数の画像をダウンロードする場合は、親ノードを選択するか、各画像ノードを個別に選択

#### 2-2. MCP ツールを使用してダウンロード

MCP ツールを使用して画像をダウンロードします。以下の方法を使用します：

**方法: `get_design_context` を使用（推奨）**

- デザインコンテキストと画像アセットを同時に取得
- `dirForAssetWrites` パラメータに画像保存先の**絶対パス**を指定
- 例: `C:/projects/hertech/src/images/company/`


**注意**: MCP ツールには解像度（2 倍書き出しなど）を指定するパラメータがありません。2 倍書き出しが必要な場合は、以下のいずれかの方法を使用してください：

1. **Figma Desktop アプリ側で事前設定**（推奨）
   - Figma Desktop で対象ノードを選択
   - 右側の「Export」パネルで「2x」を選択して設定
   - 設定後、MCP ツールでダウンロードすると 2 倍解像度で書き出される可能性があります

2. **ダウンロード後にリサイズ**（自動化可能）
   - ダウンロード後に画像を 2 倍にリサイズするスクリプトを使用（下記参照）

#### 2-4. ダウンロードの実行

MCP ツールを実行すると、選択したノード内の画像アセットが自動的にダウンロードされ、指定したディレクトリに保存されます。

**注意**:

- 画像は指定した `{画像ディレクトリ}/{ページ名}/` に保存されます
- 保存先は**絶対パス**で指定する必要があります
- ダウンロードされたファイルはハッシュ名（例: `d9cb69a8d33580a8d1783d2d4d80016a70c8eae8.png`）になります
- 複数の画像を一度にダウンロードする場合は、親ノードを選択すると効率的です

#### 2-5. 【原則】2 倍で取得する方針

MCP ツールには解像度（2 倍書き出しなど）を指定するパラメータがありません。

- **原則**: Figma Desktop の「Export」で **あらかじめ 2x を設定** してから MCP で画像を取得する  
  （この場合、追加のリサイズは不要）
- **例外**: どうしても 1x でしか取得できなかった場合のみ、ステップ 5 の ImageMagick による 2 倍リサイズを使う

### 3. ダウンロードされたファイルを確認

#### Windows の例（PowerShell）

```powershell
# ページディレクトリ内のファイルを確認
Get-ChildItem "{画像ディレクトリ}/{ページ名}/" | Select-Object -Last 20

# 例: company ページの場合
Get-ChildItem "src/images/company/" | Select-Object -Last 20
```

**注意**: プロジェクトによって画像ディレクトリのパスが異なる場合があります（例: `src/images/`, `assets/images/`, `images/` など）。

ダウンロードされたファイルはハッシュ名（例: `d9cb69a8d33580a8d1783d2d4d80016a70c8eae8.png`）になっています。

### 4. 【必須】使用されている画像のみを特定

**重要**: ダウンロードされた画像の中から、**実際に使用されている画像のみ**を特定してください。

```powershell
# ページディレクトリ内のファイルを確認（Windows）
Set-Location "{画像ディレクトリ}/{ページ名}/"
Get-ChildItem *.png,*.jpg,*.svg | Select-Object -First 20

# 例: interview ページの場合
Set-Location "src/images/interview/"
Get-ChildItem *.png,*.jpg,*.svg | Select-Object -First 20
```

**注意**:

- Figma からダウンロードすると、ページ全体の画像がダウンロードされる場合があります
- **実際に使用されている画像のみ**をリネームし、それ以外は削除してください
- 使用されている画像は、Figma のデザインを確認して特定します

### 4-1. 【必須】使用されていない画像の削除（リネーム前）

**重要**: リネームする前に、**使用されていない画像を削除**してください。これにより、不要なファイルを処理する手間を省けます。

```powershell
# 使用されていないSVGファイルを削除（Windows の例）
Set-Location "{画像ディレクトリ}/{ページ名}/"
Remove-Item *.svg -Force -ErrorAction SilentlyContinue

# 例: interview ページの場合
Set-Location "src/images/interview/"
Remove-Item *.svg -Force -ErrorAction SilentlyContinue
```

※SVG をアイコンなどで使用している場合は削除しないでください。**SVG を使用していないことが確定している場合のみ削除**します。

**注意**:

- 使用されている画像のハッシュ名は必ずメモしておいてください
- 削除前に、Figma のデザインを確認して、使用されていない画像を特定してください

### 5. 【必須】2 倍で取得（原則: Figma 2x / 例外: リサイズ）

**重要**: すべての画像は **2 倍解像度（@2x）** で扱う必要があります。

- 原則: Figma の Export 設定を 2x にして MCP で取得する
- 例外: 1x でしか取得できなかった場合のみ、以下の PowerShell スクリプトで 2 倍にリサイズする

#### Windows の例（PowerShell + ImageMagick を使用）

```powershell
cd {画像ディレクトリ}/{ページ名}/

Get-ChildItem -File | Where-Object { $_.Extension -in ".png", ".jpg" } | ForEach-Object {
  $info   = magick identify -format "%w %h" $_.FullName
  $width  = ($info -split " ")[0]
  $height = ($info -split " ")[1]

  if ($width -and $height) {
    $newW = [int]$width * 2
    $newH = [int]$height * 2
    Write-Host "処理中: $($_.Name) ${width}x${height} → ${newW}x${newH}"
    magick $_.FullName -resize "${newW}x${newH}" $_.FullName
  }
}
```

※環境によっては `identify` が単体コマンドとして使える場合があります。`magick identify` が動かない場合は `identify` に置き換えてください。

**注意**:

- リサイズは元のファイルを上書きします
- すべての画像を 2 倍にリサイズしてから、次のステップ（リネーム）に進んでください

### 6. 命名規則に従ってリネーム

#### 6-1. ファイル形式の使い分け

**重要**: 画像の種類に応じて適切な形式を使用してください。

- **メンバーの顔写真**: **jpg 形式**を使用（例: `member_01.jpg`, `member_02.jpg`）
- **その他の画像**: PNG 形式を使用（例: `fv_01.png`, `header_01.png`）
- **アイコン**: SVG 形式を使用（例: `common_icon.svg`）

#### 6-2. リネーム手順

**メンバーの顔写真の場合（jpg 形式に変換 / Windows）:**

```powershell
# 1. PNGファイルをコピーして一時ファイルを作成
Copy-Item "{画像ディレクトリ}/{ページ名}/{ハッシュ名}.png" "{画像ディレクトリ}/{ページ名}/member_01.png"

# 2. PNGからJPGに変換
magick "{画像ディレクトリ}/{ページ名}/member_01.png" "{画像ディレクトリ}/{ページ名}/member_01.jpg"

# 3. 一時のPNGファイルを削除
Remove-Item "{画像ディレクトリ}/{ページ名}/member_01.png"

# 例: interview ページの場合
Copy-Item "src/images/interview/{ハッシュ名}.png" "src/images/interview/member_01.png"
magick "src/images/interview/member_01.png" "src/images/interview/member_01.jpg"
Remove-Item "src/images/interview/member_01.png"
```

**その他の画像の場合（PNG / SVG 形式のまま）:**

```powershell
# 例: セクションの背景画像をリネーム（ページディレクトリ内）
Rename-Item "{画像ディレクトリ}/{ページ名}/{ハッシュ名}.png" "{セクション名}_01.png"

# 例: company ページの背景画像をリネーム
Rename-Item "src/images/company/{ハッシュ名}.png" "fv_01.png"

# 例: ロゴ画像をリネーム（common ディレクトリ）
Rename-Item "{画像ディレクトリ}/common/{ハッシュ名}.png" "common_logo.png"

# 例: 矢印アイコンをリネーム（common ディレクトリ）
Rename-Item "{画像ディレクトリ}/common/{ハッシュ名}.svg" "common_arrow.svg"
```

**注意**: `{画像ディレクトリ}` はプロジェクトごとに異なります。適切なパスに置き換えてください。

**注意**: `{ページ名}` は `page-{ページ名}.php` の `{ページ名}` 部分です（例: `page-company.php` → `company`）。

**注意**: `Rename-Item` を使用することで、元のハッシュ名ファイルは残りません。

### 7. ビルド結果を確認

**注意**: ビルドツール（Gulp など）が自動で動作している場合、画像の最適化と出力ディレクトリへのコピーは自動で行われます。

```powershell
# ページディレクトリ内の画像が正しく配置されているか確認
Get-ChildItem "{出力ディレクトリ}/{ページ名}/" | Where-Object Name -like "*{セクション名}*"

# 例: company ページの場合
Get-ChildItem "assets/images/company/" | Where-Object Name -like "*fv*"

# 特定のファイルの存在確認
if (Test-Path "{出力ディレクトリ}/{ページ名}/{ファイル名}") { "✓ {ファイル名}" } else { "✗ {ファイル名}" }

# 例: company ページの場合
if (Test-Path "assets/images/company/fv_01.png") { "✓ fv_01.png" } else { "✗ fv_01.png" }
```

**注意**: 出力ディレクトリはプロジェクトごとに異なります（例: `assets/images/`, `dist/images/`, `public/images/` など）。

**注意**: ビルドツールがディレクトリ構造を保持して出力する場合、ページディレクトリ構造もそのまま反映されます。

### 8. リネーム後のファイル名をメモ

**重要**: この工程は工程 3（全体コーディング）の前に完了させる必要があります。コーディング時に正しい画像パスを使用するためです。

リネーム後のファイル名をメモしておき、工程 3 でコーディングする際に使用します。

**注意**: 画像パスの形式はプロジェクトごとに異なる場合があります。ページディレクトリを使用する場合は以下のようになります：

- `<?php echo get_template_directory_uri(); ?>/assets/images/{ページ名}/{ファイル名}`
- 例: `<?php echo get_template_directory_uri(); ?>/assets/images/company/fv_01.png`

### 9. 【必須】不要なハッシュ名ファイルと使用されていない画像の削除

**重要**: リネーム後は、**不要なファイルが残っていないか必ず確認**してください。

- `Rename-Item` を使っている場合: 元のハッシュ名ファイルは残らないため、9-1 は基本的に不要です
- `Copy-Item` を使ってハッシュ名ファイルを残している場合のみ、9-1 を実施して削除します

#### 9-1. ハッシュ名ファイルの削除

```powershell
# ページディレクトリ内の特定のファイルを削除
Remove-Item "{画像ディレクトリ}/{ページ名}/{ハッシュ名}.{拡張子}" -Force

# 例: company ページの場合
Remove-Item "src/images/company/{ハッシュ名}.png" -Force

# 複数のハッシュ名ファイルを一括削除する場合（40桁ハッシュを前提）
Set-Location "{画像ディレクトリ}/{ページ名}/"
Get-ChildItem -File | Where-Object {
  $_.Name -match '^[0-9a-f]{40}\.(png|jpg|svg)$'
} | Remove-Item -Force
```

#### 9-2. 使用されていない画像の削除（リネーム後）

**重要**: リネーム済みのファイル以外はすべて削除してください。

```powershell
# リネーム済みのファイルを確認（まずは一覧で目視）
Set-Location "{画像ディレクトリ}/{ページ名}/"
Get-ChildItem -File

# リネーム済み以外のファイルを削除（安全版）
# 残したいセクション名を必要に応じて追加する
$sections = @("fv") # 例: "fv", "news", "header" など

$keepPatterns = @(
  '^member_\d{2}\.jpg$',
  '^common_.*\.(png|svg)$'
) + ($sections | ForEach-Object { param($s) "^${s}_\d{2}\.(png|jpg|svg)$" })

Write-Host "=== KEEP 対象 ==="
Get-ChildItem -File | Where-Object {
  $name = $_.Name
  ($keepPatterns | ForEach-Object { $name -imatch $_ } | Where-Object { $_ })
} | Select-Object Name

Get-ChildItem -File | Where-Object {
  $name = $_.Name
  -not ($keepPatterns | ForEach-Object { $name -imatch $_ } | Where-Object { $_ })
} | ForEach-Object {
  Write-Host "削除: $($_.Name)"
  # 本当に削除してよいか確認したい場合は、まず -WhatIf を付けて DryRun し、
  # 問題なければ -WhatIf を外して実行する
  Remove-Item $_.FullName -Force -WhatIf
  # 本番削除する場合は -WhatIf を外す
  # Remove-Item $_.FullName -Force
}

# 例: interview ページの場合（メンバーの顔写真のみ使用）
Set-Location "src/images/interview/"
$keepPatterns = @(
  '^member_\d{2}\.jpg$'
)

Get-ChildItem -File | Where-Object {
  $name = $_.Name
  -not ($keepPatterns | ForEach-Object { $name -imatch $_ } | Where-Object { $_ })
} | ForEach-Object {
  Write-Host "削除: $($_.Name)"
  Remove-Item $_.FullName -Force -WhatIf
  # 問題なければ -WhatIf を外して実行する
  # 本番削除する場合は -WhatIf を外す
  # Remove-Item $_.FullName -Force
}
```

**注意**:

- ステップ 4-1 で既に使用されていない画像を削除している場合、このステップでは主にハッシュ名のファイルを削除します
- リネーム済みのファイル以外はすべて削除してください

**注意**: ビルドツールが自動でクリーンアップを行う場合もありますが、手動で削除することを推奨します。

### 10. 【必須】使用されていない画像の確認と削除（コーディング完了後）

**重要**: コーディング完了後、使用されていない画像が残っていないか必ず確認し、削除してください。

#### 10-1. 使用されている画像の確認

```powershell
# PHPファイル内で使用されている画像パスを確認
Select-String "assets/images/{ページ名}/" "{プロジェクトルート}\*.php"

# 例: company ページの場合
Select-String "assets/images/company/" "*.php"
```

#### 10-2. ディレクトリ内の全画像を確認

```powershell
# ページディレクトリ内の全画像をリストアップ
Get-ChildItem "{画像ディレクトリ}/{ページ名}/"

# 例: company ページの場合
Get-ChildItem "src/images/company/"
```

#### 10-3. 使用されていない画像の特定と削除

```powershell
# 使用されていない画像を特定
# 1. ディレクトリ内の全ファイルを確認
# 2. Select-String の結果と照合して、使用されていないファイルを特定
# 3. 使用されていないファイルを削除

# 例: 特定のファイルを削除
Remove-Item "{画像ディレクトリ}/{ページ名}/{使用されていないファイル名}" -Force

# 例: ハッシュ名のファイルが残っている場合
Set-Location "{画像ディレクトリ}/{ページ名}/"
# リネーム済みのファイル（team_*.png など）以外を削除する前に必ず一覧を確認
Get-ChildItem
```

**確認チェックリスト**:

- [ ] ハッシュ名のファイルが残っていないか
- [ ] 使用されていない SVG ファイルが残っていないか
- [ ] リネームしたファイルが実際にコード内で使用されているか
- [ ] ディレクトリ内に不要なファイルが残っていないか

### 11. 【推奨】最終確認

すべての作業完了後、最終確認を行います：

```powershell
# 1. ディレクトリ内のファイル一覧を確認
Get-ChildItem "{画像ディレクトリ}/{ページ名}/"

# 2. 使用されている画像のみが残っているか確認
# （リネーム済みのファイル名のみが表示されることを確認）

# 3. ファイル数を確認（必要に応じて）
(Get-ChildItem "{画像ディレクトリ}/{ページ名}/").Count
```

**最終確認チェックリスト**:

- [ ] ハッシュ名のファイルがすべて削除されている
- [ ] 使用されていない画像がすべて削除されている
- [ ] リネーム済みのファイルのみが残っている
- [ ] すべてのリネーム済みファイルがコード内で使用されている

## 注意事項

- **ページディレクトリの作成**: 画像をダウンロードする前に、必ずページ用のディレクトリを作成してください
- **ディレクトリ名の規則**: `page-{ページ名}.php` の `{ページ名}` 部分をディレクトリ名として使用します（例: `page-company.php` → `company`）
- **共通画像**: 複数のページで使用する画像は `common` ディレクトリに保存します
- **【必須】2 倍で取得**: すべての画像は **2 倍解像度（@2x）** で扱う必要があります（原則: Figma の Export を 2x に設定 / 例外: 必要に応じてリサイズ）
- **【必須】ファイル形式の使い分け**:
  - **メンバーの顔写真**: **jpg 形式**を使用（例: `member_01.jpg`）
  - **その他の画像**: PNG 形式を使用（例: `fv_01.png`）
  - **アイコン**: SVG 形式を使用（例: `common_icon.svg`）
- **【必須】使用されている画像のみを処理**: ダウンロードされた画像の中から、**実際に使用されている画像のみ**をリネームし、それ以外は削除してください
- **【必須】ハッシュ名ファイルの削除**: `Copy-Item` などでハッシュ名ファイルを残した場合のみ削除してください（`Rename-Item` の場合は基本的に残りません）。忘れると不要なファイルが残り、リポジトリが肥大化します
- **【必須】使用されていない画像の削除**: リネーム済みのファイル以外はすべて削除してください（SVG、PNG、JPG など）
- ハッシュ名は Figma から取得するたびに変わる可能性があるため、都度確認が必要です
- 画像の保存先と出力先はプロジェクトごとに異なります（例: `src/images/{ページ名}/` → `assets/images/{ページ名}/` など）
- WebP 形式も自動生成される場合があります（ビルドツールの設定による）
- 画像の最適化（圧縮）も自動で行われる場合があります（ビルドツールの設定による）
- この工程は工程 3（全体コーディング）の前に完了させる必要があります

## トラブルシューティング

### 画像が表示されない場合

1. **ファイルの存在確認**

   ```powershell
   # ファイルの存在確認
   if (Test-Path "{出力ディレクトリ}/{ファイル名}") { "存在" } else { "不存在" }
   ```

2. **HTML のパス確認**

   ```powershell
   # HTML 内の画像パス確認
   Select-String "src=`"./{画像パス}/{ファイル名}`"" "{メインHTMLファイル}"
   ```

3. **ビルドツールの確認**

   **注意**: ビルドツールが自動で動作している場合、手動でのビルドは不要です。ファイルが出力ディレクトリに正しく配置されているか確認してください。

### 使用されていない画像が残っている場合

1. **使用されている画像の確認**

   ```powershell
   # PHPファイル内で使用されている画像パスを確認
   Select-String "assets/images/{ページ名}/" "{プロジェクトルート}\*.php"
   ```

2. **ディレクトリ内の全ファイルを確認**

   ```powershell
   # ページディレクトリ内の全ファイルをリストアップ
   Get-ChildItem "{画像ディレクトリ}/{ページ名}/"
   ```

3. **使用されていないファイルの削除**

   ```powershell
   # 使用されていないファイルを削除
   Remove-Item "{画像ディレクトリ}/{ページ名}/{使用されていないファイル名}" -Force

   # ハッシュ名のファイルが残っている場合
   Set-Location "{画像ディレクトリ}/{ページ名}/"
   # リネーム済みのファイル（team_*.png など）以外を削除する前に必ず一覧を確認
   Get-ChildItem
   ```

4. **最終確認**

   ```powershell
   # ディレクトリ内のファイル一覧を確認
   Get-ChildItem "{画像ディレクトリ}/{ページ名}/"
   # リネーム済みのファイルのみが残っていることを確認
   ```
