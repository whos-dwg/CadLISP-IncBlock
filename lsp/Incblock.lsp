(defun c:IncBlock ( / subEnt subData targetTag baseVal len i numStr prefix numLen curNum blkEnt blkData blkName pt newEnt newSubData oldAtreq oldError attList nextEnt entData tag val)
  
  ;; 儲存原本的 ATREQ 設定值
  (setq oldAtreq (getvar "ATREQ"))
  
  ;; 1. 直接點選圖塊中的「屬性文字」
  (setq subEnt (car (nentsel "\n請直接點選圖塊中要遞增的屬性文字 (如 01): ")))
  (if (not subEnt) 
    (progn 
      (princ "\n未選擇物件。") 
      (exit)
    )
  )
  
  (setq subData (entget subEnt))
  
  ;; 檢查點選的是否為屬性物件 (ATTRIB)
  (if (= (cdr (assoc 0 subData)) "ATTRIB")
    (progn
      ;; 取得屬性標籤（Tag）與目前的初始值（Value）
      (setq targetTag (strcase (cdr (assoc 2 subData))))
      (setq baseVal (cdr (assoc 1 subData)))
      
      ;; 取得父圖塊的名稱與圖元名稱
      (setq blkEnt (cdr (assoc 330 subData)))
      (setq blkData (entget blkEnt))
      (setq blkName (cdr (assoc 2 blkData)))
      
      ;; === 新增：撈取來源圖塊內「所有屬性」的現有內容 ===
      (setq attList nil)
      (setq nextEnt (entnext blkEnt))
      (while (and nextEnt (= (cdr (assoc 0 (setq entData (entget nextEnt)))) "ATTRIB"))
        (setq tag (strcase (cdr (assoc 2 entData))))
        (setq val (cdr (assoc 1 entData)))
        ;; 建立關聯清單，例如 (("TAG1" . "值1") ("TAG2" . "值2"))
        (setq attList (cons (cons tag val) attList))
        (setq nextEnt (entnext nextEnt))
      )
      ;; ================================================
      
      ;; 2. 解析屬性值 (分離文字字首與數字)
      (setq len (strlen baseVal)
            i len
            numStr "")
      (while (and (> i 0) (wcmatch (substr baseVal i 1) "[0-9]"))
        (setq numStr (strcat (substr baseVal i 1) numStr))
        (setq i (1- i))
      )
      
      (if (= numStr "")
        (progn (princ "\n所選屬性值結尾不是數字，無法遞增。") (exit))
      )
      
      (setq prefix (substr baseVal 1 i)
            numLen (strlen numStr)
            curNum (atoi numStr))
      
      (princ (strcat "\n成功偵測！標籤: " targetTag " | 初始值: " baseVal))
      
      ;; 暫時將 ATREQ 設定為 0 (不提示輸入屬性，直接抓預設)
      (setvar "ATTREQ" 0)
      
      ;; 3. 循環放置新圖塊並遞增
      (princ "\n開始放置圖塊 (按 ESC 或 滑鼠右鍵 結束)...")
      
      ;; 錯誤處理：按 ESC 也能將變數還原
      (setq oldError *error*)
      (setq *error* (lambda (msg)
                      (setvar "ATREQ" oldAtreq)
                      (setq *error* oldError)
                      (princ (strcat "\n指令已中斷: " msg))
                      (princ)
                    ))
      
      (while (setq pt (getpoint "\n請點擊放置新圖塊的位置: "))
        
        ;; 數字遞增 1
        (setq curNum (1+ curNum))
        
        ;; 補零格式化 (例如 1 變成 "01")
        (setq numStr (itoa curNum))
        (while (< (strlen numStr) numLen)
          (setq numStr (strcat "0" numStr))
        )
        (setq newVal (strcat prefix numStr))
        
        ;; 使用 Command 指令直接插入圖塊
        (command "-insert" blkName pt "1" "1" "0")
        
        ;; 尋找剛剛插入的新圖塊，並依據紀錄還原/修改屬性
        (setq newEnt (entnext (entlast)))
        (while (and newEnt (= (cdr (assoc 0 (setq newSubData (entget newEnt)))) "ATTRIB"))
          (setq tag (strcase (cdr (assoc 2 newSubData))))
          
          ;; 判斷：如果是目標遞增標籤，寫入遞增後的值；如果是其他標籤，從 attList 撈出原值寫入
          (if (= tag targetTag)
            (setq newSubData (subst (cons 1 newVal) (assoc 1 newSubData) newSubData))
            (if (assoc tag attList)
              (setq newSubData (subst (cons 1 (cdr (assoc tag attList))) (assoc 1 newSubData) newSubData))
            )
          )
          
          (entmod newSubData)
          (entupd newEnt)
          (setq newEnt (entnext newEnt))
        )
        (princ (strcat " -> 已生成編號: " newVal))
      )
      
      ;; 正常結束循環後，還原錯誤處理程序
      (setq *error* oldError)
    )
    (princ "\n您點選的不是屬性文字！請精準點擊圖塊上的數字。")
  )
  
  ;; 程式結束前，將 ATREQ 還原為原本的值
  (setvar "ATREQ" oldAtreq)
  (princ)
)
(princ "\n載入成功。輸入 INCBLOCK 執行指令。")
(princ)