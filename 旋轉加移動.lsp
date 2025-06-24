(defun c:RotateMove ( / selSet rotBasePt moveBasePt moveToPt moveVec)
  (prompt "\n選取要旋轉和移動的物件: ")
  (setq selSet (ssget))
  (if selSet
    (progn
      (prompt "\n指定旋轉基準點: ")
      (setq rotBasePt (getpoint))
      ;; 互動式旋轉（讓使用者用滑鼠決定角度）
      (command "_.ROTATE" selSet "" rotBasePt pause)
      (prompt "\n指定移動基準點: ")
      (setq moveBasePt (getpoint))
      (prompt "\n指定移動終點: ")
      (setq moveToPt (getpoint moveBasePt "\n指定移動終點: "))
      (setq moveVec (mapcar '- moveToPt moveBasePt))
      ;; 只需移動一次整個選集
      (command "_.MOVE" selSet "" moveBasePt moveToPt)
      (princ "\n物件已旋轉並移動。")
    )
    (prompt "\n未選取任何物件。")
  )
  (princ)
)
(princ "\n請輸入 ROTATEMOVE 來執行旋轉加移動指令。")
(princ)