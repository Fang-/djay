::
|_  pl=(list [id=cord name=cord duration=@dr])
::
++  grab                                                ::  convert from
  |%
  ++  noun  ,(list [id=cord name=cord duration=@dr])     ::  from %noun
  --
::
++  grow                                                ::  convert to
  |%
  ++  json                                              ::  to %json
    =,  enjs:format
    ^-  ^json
    :-  %a
    %+  turn  pl
    |=  [id=cord name=cord duration=@dr]
    %-  pairs
    :~  'id'^s+id
        'name'^s+name
        'duration'^n+(crip ((d-co:co 1) (div duration ~s1)))
    ==
  --
--
