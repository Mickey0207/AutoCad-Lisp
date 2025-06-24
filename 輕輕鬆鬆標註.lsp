(defun c:SmartDimLinear ( / ent entData ptList oldOsnap i pt1 pt2)
  (setq oldOsnap (getvar "OSMODE")) ; 儲存原本鎖點設定
  (prompt "\n請選取一條線段（LINE、LWPOLYLINE、POLYLINE）：")
  (setq ent (car (entsel)))
  (if (and ent (wcmatch (cdr (assoc 0 (entget ent))) "LINE,LWPOLYLINE,POLYLINE"))
    (progn
      (setq entData (entget ent))
      (cond
        ((= (cdr (assoc 0 entData)) "LINE")
         (setq ptList (list (cdr (assoc 10 entData)) (cdr (assoc 11 entData)))))
        ((or (= (cdr (assoc 0 entData)) "LWPOLYLINE") (= (cdr (assoc 0 entData)) "POLYLINE"))
         ;; 取得所有頂點
         (setq ptList nil)
         (setq i 0)
         (while (setq pt (vlax-curve-getPointAtParam ent i))
           (setq ptList (append ptList (list pt)))
           (setq i (1+ i))
         )
        )
      )
      ;; 對每一段進行標註
      (setq i 0)
      (while (< i (1- (length ptList)))
        (setq pt1 (nth i ptList))
        (setq pt2 (nth (1+ i) ptList))
        (if (> (distance pt1 pt2) 1e-8) ; 距離大於0才標註
          (progn
            (setvar "OSMODE" 0) ; 關閉所有鎖點
            (command "_.DIMLINEAR" pt1 pt2 pause)
            (setvar "OSMODE" oldOsnap) ; 恢復鎖點
          )
          (prompt (strcat "\n第 " (itoa (1+ i)) " 段長度為 0，已自動跳過。"))
        )
        (setq i (1+ i))
      )
      (princ "\n標註完成，鎖點已恢復。")
    )
    (progn
      (setvar "OSMODE" oldOsnap)
      (princ "\n未選取正確的線段，鎖點已恢復。")
    )
  )
  (princ)
)
(princ "\n請輸入 SmartDimLinear 來執行自訂線性標註。")
(princ)