; filepath: c:\Users\notel\OneDrive\群勝系統\AutoCad\AutoCad-Lisp\直接插入.lsp

(defun c:BatchInsertDWG ( / folder files fileName idx insPt )
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
            (command "_.-INSERT" (strcat folder "\\" file) insPt 1 1 0)
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