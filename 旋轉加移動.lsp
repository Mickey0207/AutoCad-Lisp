(defun c:RotateMove ( / selSet rotBasePt)
  (prompt "\n選取要旋轉和移動的物件: ")
  (setq selSet (ssget))
  (if selSet
    (progn
      (prompt "\n指定旋轉基準點: ")
      (setq rotBasePt (getpoint))
      ;; 互動式旋轉
      (command "_.ROTATE" selSet "" rotBasePt pause)
      ;; 直接呼叫 MOVE 指令，讓使用者互動式移動（有預覽）
      (command "_.MOVE" selSet "" pause pause)
      (princ "\n物件已旋轉並移動。")
    )
    (prompt "\n未選取任何物件。")
  )
  (princ)
)
(princ "\n請輸入 ROTATEMOVE 來執行旋轉加移動指令。")
(princ)