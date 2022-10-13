
type 'a liste =
| Nil
| Cons of 'a * 'a liste

(** val append_impl : 'a1 liste -> 'a1 liste -> 'a1 liste **)

let rec append_impl l1 l2 =
  match l1 with
  | Nil -> l2
  | Cons (t1, q1) -> Cons (t1, (append_impl q1 l2))

(** val rev_impl : 'a1 liste -> 'a1 liste **)

let rec rev_impl = function
| Nil -> Nil
| Cons (t, q) -> append_impl (rev_impl q) (Cons (t, Nil))
