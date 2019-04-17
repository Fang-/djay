::
|_  id/cord
::
++  grab                                                ::  convert from
  |%
  ++  noun  ~&  %from-noun  cord                                        ::  from %noun
  ++  json                                              ::  from %json
    ~&  %from-json
    |=  a=^json
    ?>  ?=(%s -.a)
    p.a
  --
::
++  grow                                                ::  convert to
  |%
  ++  json                                              ::  to %json
    ~&  %to-json
    ^-  ^json
    s+id
  --
--
