; filepath: c:\Users\notel\OneDrive\群勝系統\AutoCad\AutoCad-Lisp\直接插入.lsp

(defun c:BatchInsertDWG ( / files file fileName idx insPt )
  (setq files '())
  (while (setq file (getfiled "選擇要插入的DWG檔案(按取消結束)" "" "dwg" 8))
    (setq files (append files (list file)))
  )
  (if files
    (progn
      (setq idx 1)
      (foreach file files
        (setq fileName (vl-filename-base file))
        (setq insPt (list (* 10000 idx) 0 0))
        (command "_.-INSERT" file insPt 1 1 0)
        (command "_.TEXT" (list (car insPt) 5000 0) 1000 0 fileName)
        (setq idx (1+ idx))
      )
    )
    (princ "\n未選擇任何檔案。")
  )
  (princ)
)
(princ "\n請輸入 BatchInsertDWG 來批次插入DWG檔案。\n")