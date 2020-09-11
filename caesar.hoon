:: from https://urbit.org/docs/tutorials/hoon/hoon-school/caesar/
::
!:
|=  [msg=tape steps=@ud op=?(%encode %decode %brute-force)]
|^  ^-  $%([%out tape] [%brute-mass (list tape)])
?.  =(op %brute-force)
  [%out (turn msg nurt)]
:-  %brute-mass
|-
?:  =(steps :(add (lent alpha) (lent big-alpha) (lent specials) (lent numbers)))
  ~
:-
  (turn msg nurt)
$(steps +(steps))
::
+|  %alphabets
++  alpha      "abcdefghijklmnopqrstuvwxyz"
++  big-alpha  "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
++  specials   "!@#$%^&*()_+-="
++  numbers    "1234567890"
::
+|  %operators
++  nurt
  |=  a=@t
  (~(got by coder) a)
++  zipper
  |=  [a=tape b=tape]
  ^-  (list [@t @t])
  =|  result=(list [@t @t])
  |-
  ?:  |(?=(~ a) ?=(~ b))
    result
  $(result [[i.a i.b] result], a t.a, b t.b)
++  rotation
  |=  my-alphabet=tape
  =/  length=@ud  (lent my-alphabet)
  =/  rot-steps
    ?:(=(op %decode) (sub length (mod steps length)) (mod steps length))
  =+  (trim rot-steps my-alphabet)
  (weld q p)
++  coder
  ^-  (map @t @t)
  =/  raw-tape  :(weld alpha big-alpha specials numbers)
  =/  rot-tape  :(weld (rotation alpha) (rotation big-alpha) (rotation specials) (rotation numbers))
  =|  output=(map @t @t)
(~(gas by output) [[' ' ' '] (zipper raw-tape rot-tape)])
--
