; filepath: c:\Users\notel\OneDrive\群勝系統\AutoCad\AutoCad-Lisp\直接插入.lsp

(defun c:InsertDWG ( / folder files fileName idx insPt )
  (setq folder (getstring "\n請輸入DWG檔案所在資料夾完整路徑: "))
  (if (and folder (/= folder ""))
    (progn
      (setq files (vl-directory-files folder "*.dwg" 1))
      (if files
        (progn
          (setq idx 1)
          (foreach file files
            (setq fileName (vl-filename-base file))
            (setq insPt (list (* 10000 idx) 0 0))
            ;; 直接插入區塊，不炸開
            (command "_.-INSERT" (strcat folder "\\" file) insPt 1 1 0)
            ;; 插入檔名文字
            (command "_.TEXT" (list (car insPt) 5000 0) 1000 0 fileName)
            (setq idx (1+ idx))
          )
        )
        (princ "\n此資料夾沒有DWG檔案。")
      )
    )
    (princ "\n未輸入資料夾路徑。")
  )
  (princ)
)
(princ "\n請輸入 BatchInsertDWG 來批次插入資料夾內所有DWG檔案。\n")

(defun c:CopyUnfrozenToClipboard ( / ss unfrozenLayers layList filter )
  (setq unfrozenLayers '())
  (vlax-for lay (vla-get-Layers (vla-get-ActiveDocument (vlax-get-acad-object)))
    (if (= (vla-get-Freeze lay) :vlax-false)
      (setq unfrozenLayers (cons (vla-get-Name lay) unfrozenLayers))
    )
  )
  (if unfrozenLayers
    (progn
      (setq layList (mapcar '(lambda (x) (list 8 x)) unfrozenLayers))
      (setq filter (append (list (cons 410 (getvar "CTAB")) (cons -4 "<OR>")) layList (list (cons -4 "OR>"))))
      (setq ss (ssget "X" filter))
      (if ss
        (progn
          (command "_.COPYBASE" '(0 0 0) ss)
          (princ "\n已複製未凍結圖層物件到剪貼簿。請切換到新圖面並執行 PASTECLIP。")
        )
        (princ "\n找不到未凍結圖層物件。")
      )
    )
    (princ "\n找不到未凍結圖層。")
  )
  (princ)
)
(princ "\n請在來源圖面輸入 CopyUnfrozenToClipboard 複製未凍結圖層物件。\n")