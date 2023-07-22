if (!AviutlControl.isInitialized)
{
  AviutlControl.Initialize()
}

class AviutlControl
{
  static isInitialized := False

  static exeditWindowTitle := "拡張編集 ahk_exe aviutl.exe"
  static exeditWindowText := "Bar"

  static sceneWindowTitle := "ahk_class #32770 ahk_exe aviutl.exe"
  static sceneControl := "ListBox1"
  static sceneControlPosition := [30, 10]

  static mainWindowTitle := "exedit ahk_class AviUtl ahk_exe aviutl.exe"
  static mainWindowTitleWithSplitWindow := ".aup ahk_class AviUtl ahk_exe aviutl.exe"

  static waitTime := 1500
  static waitTimeForChooseScene := 3000


  static Initialize()
  {
    if WinExist(this.mainWindowTitleWithSplitWindow)
    {
      this.usingSplitWindow := True
      this.mainWindowTitle := this.mainWindowTitleWithSplitWindow
    }
    else
    {
      this.usingSplitWindow := False
      if !WinExist(this.mainWindowTitle)
      {
        Throw(Error())
      }
    }

    this.SetSceneNameArray()

    this.SetCurrentSceneIndex()
  }

  static SceneControlBefore()
  {
    ; 後処理はしない
    id := WinGetId(this.exeditWindowTitle, this.exeditWindowText)
    WinMoveTop(id)

    CoordMode("Mouse", "Screen")
    WinGetPos(&x, &y, &w, &h, id)
    MouseMove(x + w/2, y + h/2)

    WinActivate(id)

    CoordMode("Mouse", "Client")
    MouseClick("Left", this.sceneControlPosition[1], this.sceneControlPosition[2])

    sleep this.waitTime
  }

  static GetSceneNameArray()
  {
    this.SceneControlBefore()

    return ControlGetItems(this.sceneControl, this.sceneWindowTitle)
  }

  static SetSceneNameArray()
  {
    this.sceneNameArray := this.GetSceneNameArray()
    return True
  }

  static SetCurrentSceneIndex()
  {
    ; Initialize() と ChooseSceneFromIndex(index) で更新
    this.SceneControlBefore()

    choice := ControlGetChoice(this.sceneControl, this.sceneWindowTitle)
    this.currentSceneIndex := GetIndexFromArray(
      this.sceneNameArray,
      choice
      )
    return True
  }

  static GetSceneIndexFromName(sceneName)
  {
    i := GetIndexFromArray(
      this.sceneNameArray,
      sceneName
      )
    return i
  }

  static GetSceneNameFromIndex(sceneIndex)
  {
    if sceneIndex <= 0 || this.sceneNameArray.Length < sceneIndex
    {
      Throw(Error())
    }
    return this.sceneNameArray[sceneIndex]
  }

  static GetCurrentSceneName()
  {
    return this.GetSceneNameFromIndex(this.currentSceneIndex)
  }

  static ChooseSceneFromIndex(index)
  {
    if Type(sceneName) != "Integer"
    {
      Throw(Error())
    }

    this.SceneControlBefore()

    ControlChooseIndex(index, this.sceneControl, this.sceneWindowTitle)
    this.currentSceneIndex := index

    ; 完全に変わるまで待ちたい
    sleep this.waitTimeForChooseScene

    return True
  }

  static ChooseSceneFromName(sceneName)
  {
    if Type(sceneName) != "String"
    {
      Throw(Error())
    }

    sceneIndex := this.GetSceneIndexFromName(sceneName)
    return this.ChooseSceneFromIndex(sceneIndex)
  }

  static ChooseScene(sceneNameOrIndex)
  {
    if Type(sceneNameOrIndex) == "Integer"
    {
      return this.ChooseSceneFromIndex(sceneNameOrIndex)
    } else if Type(sceneNameOrIndex) == "String" {
      return this.ChooseSceneFromName(sceneNameOrIndex)
    } else {
      Throw(Error())
    }
  }


  static OpenEasyMP4(exportShortcut)
  {
    id := WinGetId(this.mainWindowTitle)
    WinMoveTop(id)

    CoordMode("Mouse", "Screen")
    WinGetPos(&x, &y, &w, &h, id)
    MouseMove(x + w/2, y + h/2)

    WinActivate(id)

    Send exportShortcut
    sleep this.waitTime
  }

}

class EasyMP4Control
{
  static windowTitle := "ahk_class #32770 ahk_exe aviutl.exe"
  static windowText := "バッチ登録"

  static filenameControl := "Edit1"

  ; static batchRegisterControl := "Button5"
  static batchRegisterControl := "バッチ登録"

  static batchRegisterControlOverwriteWindowTitle := "名前を付けて保存の確認 ahk_exe aviutl.exe"
  static batchRegisterControlOverwriteYesControl := "Button1"

  static waitTime := 1500

  static ActivateWindow()
  {
    id := WinGetId(this.windowTitle, this.windowText)

    CoordMode("Mouse", "Screen")
    WinGetPos(&x, &y, &w, &h, id)
    MouseMove(x + w/2, y + h/2)

    WinActivate(id)
  }

  static InputFilename(filename)
  {
    ControlSetText(filename, this.filenameControl, this.windowTitle, this.windowText)
    sleep this.waitTime

    return True
  }

  static PressBatchRegisterButton()
  {
    ControlFocus(this.batchRegisterControl, this.windowTitle, this.windowText)
    ControlSend("{space}", this.batchRegisterControl, this.windowTitle, this.windowText, "Left")
    sleep this.waitTime

    if WinExist(this.batchRegisterControlOverwriteWindowTitle)
    {
      id := WinGetId(this.batchRegisterControlOverwriteWindowTitle)

      CoordMode("Mouse", "Screen")
      WinGetPos(&x, &y, &w, &h, id)
      MouseMove(x + w/2, y + h/2)

      WinActivate(id)

      ControlClick(this.batchRegisterControlOverwriteYesControl, id, "Left")
      sleep this.waitTime
    }

    if WinExist(this.windowTitle, this.windowText)
    {
      Throw(Error())
    }

    return True
  }

  static BatchRegister(filename)
  {
    if WinExist(this.windowTitle, this.windowText)
    {
      this.ActivateWindow()
      this.InputFilename(filename)
      this.PressBatchRegisterButton()
    }
    else
    {
      Throw(Error())
    }
    return True
  }
}

GetIndexArrayFromArray(arr, query)
{
  res := []
  for index, value in arr
  {
    if value == query
    {
      res.push(index)
    }
  }
  return res
}

GetIndexFromArray(arr, query)
{
  indexArray := GetIndexArrayFromArray(arr, query)
  if indexArray.length != 1
  {
    Throw(Error())
  }
  return indexArray[1]
}

