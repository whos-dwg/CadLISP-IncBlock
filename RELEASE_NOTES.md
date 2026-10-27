# INCBLOCK 首次預覽發行說明草稿

讀取來源屬性尾端數字，連續插入同名圖塊並遞增，其他屬性沿用原值。

- 指令：INCBLOCK。
- 相依與設定：原碼含 ATREQ／ATTREQ 拼字不一致，需先修正並測試，見已知問題；本包保留原碼。
- 驗證：完成來源與文件靜態檢查；AutoCAD 實機回歸待完成。
- 已知事項：原碼開頭及還原處使用 `ATREQ`，插入前設定的卻是標準變數 `ATTREQ`。可能在起始 getvar 即失敗；應統一拼字後測試正常結束、Esc、錯誤與變數還原。[ATTREQ 官方說明](https://help.autodesk.com/cloudhelp/2020/ENU/AutoCAD-Core/files/GUID-7A7229F8-C99D-42C5-8784-4231767611F8.htm)。
- 授權：MIT，Copyright (c) 2026 whos-dwg。

本次保留來源位元組；發布時請按實際修補及測試結果更新這份說明。[完整操作](README.md)。
