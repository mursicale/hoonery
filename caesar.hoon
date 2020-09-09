:: from https://urbit.org/docs/tutorials/hoon/hoon-school/caesar/
::
!:
|=  [msg=tape steps=@ud]
=<                      :: create the core first
=.  msg  (cass msg)     :: downcase everything, temp subject
:-  (shift msg steps)
(unshift msg steps)

|%
++  alpha  "abcdefghijklmnopqrstuvwxyz"
::
++  shift
  |=  [message=tape shift-steps=@ud]
  ^-  tape
  (operate message (encoder shift-steps))
++  unshift
  |=  [message=tape shift-steps=@ud]
  ^-  tape
  (operate message (decoder shift-steps))
++  encoder
  |=  [steps=@ud]
  ^-  (map @t @t)
  =/  value-tape=tape  (rotation alpha steps)
  (space-adder alpha value-tape)
++  decoder
  |=  [steps=@ud]
  ^-  (map @t @t)
  =/  value-tape=tape  (rotation alpha steps)
  (space-adder value-tape alpha)
++  operate
  |=  [message=tape shift-map=(map @t @t)]
  ^-  tape
  :: turn is haskell `map` so hoon=(list) hoon=(gate)
  %+  turn  message
  |=  a=@t
  (~(got by shift-map) a)
  ::
::::
::  once the map is made, spaces need to be preserved with:
++  space-adder
  |=  [key-position=tape value-result=tape]
  ^-  (map @t @t)
  (~(put by (map-maker key-position value-result)) ' ' ' ')
++  map-maker
  |=  [key-position=tape value-result=tape]
  ^-  (map @t @t)
  =|  chart=(map @t @t)
  :: freak out if the tapes aren't the same length
  ::
  ?.  =((lent key-position) (lent value-result))
  ~|  %uneven-lengths  !!
  :: otherwise recur to this point
  |-
  ?:  |(?=(~ key-position) ?=(~ value-result))
  chart
  %=  $
  :: update the chart with a pair from the head of each tape
  chart         (~(put by chart) i.key-position i.value-result)
  :: then pop the heads off
  key-position  t.key-position
  value-result  t.value-result
  ==
++  rotation
  |=  [my-alphabet=tape my-steps=@ud]
  =/  length=@ud  (lent my-alphabet)
  =+  (trim (mod my-steps length) my-alphabet)
      :: trim returns [p q] , which tislus pins to the head of the
      :: subject.
  (weld q p)
--
