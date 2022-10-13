
type 'a liste =
| Nil
| Cons of 'a * 'a liste

val append_impl : 'a1 liste -> 'a1 liste -> 'a1 liste

val rev_impl : 'a1 liste -> 'a1 liste
