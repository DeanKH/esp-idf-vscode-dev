# esp-id-vscode-dev

## 概要

## 注意

このコンテナ内ではデフォルトでシリアルデバイスへのアクセス権限が付与されています。

## 使い方

### 開発環境起動

1. コンテナイメージをビルドする

```
docker compose build
```

2. コンテナ起動

```
docker compose up -d
```

M5Stack の内蔵 Wi-Fi モジュールを使用する場合は SSID とパスワードを変数で与える

```
ESP_WIFI_SSID="SSID" ESP_WIFI_PASS="PASS" docker compose up -d
```

## EXTRA_COMPONENT_DIRS

コンテナの `/home/developer/components` に以下のソースコードが clone されています。

- M5Unified
- M5GFX
- mros2-esp32

これらをプロジェクト内で使用する場合、プロジェクトトップの CMakeLists.txt に以下の行を追加してください。

```cmake
set(EXTRA_COMPONENT_DIRS $ENV{MROS2_COMPONENTS_PATH})
```

### ビルド

基本は vscode の拡張機能 esp-idf で操作すればいいですが、Wi-Fi と外付け Ethernet を切り替えたい場合は CMake のオプション `USE_WIFI` を OFF に設定してください。

```
idf.py build -DUSE_WIFI=OFF

```

注意：現在は対応していません。
