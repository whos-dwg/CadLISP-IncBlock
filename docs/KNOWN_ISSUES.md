# 已知問題

## 需先修正

原碼開頭及還原處使用 `ATREQ`，插入前設定的卻是標準變數 `ATTREQ`。可能在起始 getvar 即失敗；應統一拼字後測試正常結束、Esc、錯誤與變數還原。[ATTREQ 官方說明](https://help.autodesk.com/cloudhelp/2020/ENU/AutoCAD-Core/files/GUID-7A7229F8-C99D-42C5-8784-4231767611F8.htm)。

## 使用限制

原碼以縮放 1、旋轉 0 重新插入同名圖塊，不保證複製來源圖塊的縮放、旋轉與動態參數。此項為待修正工具，不能標示為已通過執行測試。

原碼含 ATREQ／ATTREQ 拼字不一致，需先修正並測試，見已知問題；本包保留原碼。

本次保留原始碼位元組，未修補功能；上述來源觀察不等於 AutoCAD 實機驗證結果。[返回 README](../README.md)。
