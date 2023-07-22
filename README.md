# AviUtl Batch Register

- AviUtl
- AutoHotkey V2

AviUtl でシーン毎にバッチ登録を行うスクリプトです。  
詳細な説明は用意していません。


## 動作について

- エンコードの細かい設定はできません
  - シーン名がファイル名になります
  - 出力先のディレクトリは選べません
- プラグイン出力のショートカットを設定する必要があります


## 使い方

`main.ahk` の `defaultExportShortcut` と `sceneArray` を変更して使います。

```ahk
defaultExportShortcut := "^+!E" ; Ctrl+Shift+Alt+E でプラグイン出力する場合
sceneArray := [
  "Scene 13",
  "Scene 17",
  "Scene 19",
  "Scene 23",
  ["Scene 23", "^+!F"], ; Ctrl+Shift+Alt+F でプラグイン出力する場合
]
```

