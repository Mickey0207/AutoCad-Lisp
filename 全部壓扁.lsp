(defun c:FlattenAll ( / ss i ent ename coords newcoords)
  (vl-load-com)
  (setq ss (ssget "X"))
  (if ss
    (progn
      (setq i 0)
      (while (< i (sslength ss))
        (setq ename (ssname ss i))
        (setq ent (vlax-ename->vla-object ename))
        (cond
          ;; 處理有座標的物件
          ((vlax-property-available-p ent 'Coordinates)
            (setq coords (vlax-get ent 'Coordinates))
            (setq newcoords
              (vlax-make-safearray vlax-vbDouble (cons 0 (1- (vlax-safearray-get-u-bound coords 1)))))
            (vlax-safearray-fill newcoords
              (mapcar
                (lambda (n idx)
                  (if (= (mod idx 3) 2) 0.0 n))
                (vlax-safearray->list coords)
                (number-sequence 0 (1- (vlax-safearray-get-u-bound coords 1)))))
            (vlax-put ent 'Coordinates newcoords)
          )
          ;; 處理插入點
          ((vlax-property-available-p ent 'InsertionPoint)
            (setq ipt (vlax-get ent 'InsertionPoint))
            (vlax-put ent 'InsertionPoint (list (car ipt) (cadr ipt) 0.0))
          )
          ;; 處理文字基點
          ((vlax-property-available-p ent 'Position)
            (setq pos (vlax-get ent 'Position))
            (vlax-put ent 'Position (list (car pos) (cadr pos) 0.0))
          )
        )
        (setq i (1+ i))
      )
      (princ "\n全部物件Z座標已歸零。")
    )
    (princ "\n找不到任何物件。")
  )
  (princ)
)
(princ "\n請輸入 FLATTENALL 來將全部物件Z座標歸零。")
(princ)