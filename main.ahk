#include aviutl-batch-register.ahk

defaultExportShortcut := "^+!E" ; Ctrl+Shift+Alt+E でプラグイン出力する場合
sceneArray := [
  "Scene 13",
  "Scene 17",
  "Scene 19",
  "Scene 23",
  ["Scene 23", "^+!F"], ; Ctrl+Shift+Alt+F でプラグイン出力
]

for scene in sceneArray
{
  if Type(scene) == "Array"
  {
    sceneName := scene[1]
    exportShortcut := scene[2]
  }
  else
  {
    sceneName := scene
    exportShortcut := defaultExportShortcut
  }

  AviutlControl.ChooseSceneFromName(sceneName)

  AviutlControl.OpenEasyMP4(exportShortcut)

  sceneNameEscaped := RegExReplace(sceneName, "[\/:*?`"<>|]+", "-")
  EasyMP4Control.BatchRegister(sceneNameEscaped)
}

Msgbox "Done!"

