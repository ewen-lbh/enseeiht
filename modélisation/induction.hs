module Induction where

import qualified Prelude

data Liste a =
   Nil
 | Cons a (Liste a)

append_impl :: (Liste a1) -> (Liste a1) -> Liste a1
append_impl l1 l2 =
  case l1 of {
   Nil -> l2;
   Cons t1 q1 -> Cons t1 (append_impl q1 l2)}

rev_impl :: (Liste a1) -> Liste a1
rev_impl l =
  case l of {
   Nil -> Nil;
   Cons t q -> append_impl (rev_impl q) (Cons t Nil)}

