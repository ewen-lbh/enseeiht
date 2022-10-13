;; This extracted scheme code relies on some additional macros
;; available at http://www.pps.univ-paris-diderot.fr/~letouzey/scheme
(load "macros_extr.scm")


(define append_impl (lambdas (l1 l2)
  (match l1
     ((Nil) l2)
     ((Cons t1 q1) `(Cons ,t1 ,(@ append_impl q1 l2))))))
  
(define rev_impl (lambda (l)
  (match l
     ((Nil) `(Nil))
     ((Cons t q) (@ append_impl (rev_impl q) `(Cons ,t ,`(Nil)))))))
  
