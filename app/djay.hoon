::  djay: socially-fueled music player
::
/-  hall
/+  http
::
|%
++  state
  $:  videos=(map video-id video)
      queue=(list video-id)
      now-playing=video-id
  ==
::
++  video-id  cord
++  video
  $:  name=cord
      duration=@dr
  ==
::
::
++  move  (pair bone card)
++  card
  $%  [%peer wire dock path]
      [%hiss wire (unit user:eyre) mark %hiss hiss:eyre]
      [%wait wire @da]
  ==
--
::
|_  [bol=bowl:gall state]
++  this  .
::
++  prep
  |=  old=(unit state)
  ^-  (quip move _this)
  ~&  %prep-called
  ?~  old  [~ this]
  [~ this(+<+ u.old)]
::
++  poke-noun
  |=  cmd=?(%watch %debug)
  ^-  (quip move _this)
  ?-  cmd
      %watch
    :_  this
    :_  ~
    ^-  move
    :-  ost.bol
    :*  %peer
        /hall-sub
        [our.bol %hall]
        /circle/testing/grams
    ==
  ::
      %debug
    ~&  videos=videos
    ~&  queue=queue
    [~ this]
  ==
::
++  diff-hall-prize
  |=  [wir=wire piz=prize:hall]
  ^-  (quip move _this)
  ?>  ?=(%circle -.piz)
  =/  video-ids=(list cord)
    (murn nes.piz get-video-from-message)
  =.  video-ids
    (skip video-ids ~(has by videos))
  ?~  video-ids  [~ this]
  :_  this
  [(request-video-details video-ids) ~]
::
++  diff-hall-rumor
  |=  [wir=wire dif=rumor:hall]
  ^-  (quip move _this)
  ?>  ?=(%circle -.dif)
  ?>  ?=(%gram -.rum.dif)
  ::
  =/  video-id  (get-video-from-message nev.rum.dif)
  ?~  video-id  [~ this]
  :_  this
  [(request-video-details [u.video-id]~) ~]
::
++  get-video-from-message
  |=  envelope:hall
  ^-  (unit cord)
  ?.  ?=(%url -.sep.gam)  ~
  =*  url  url.sep.gam
  =*  host  r.p.p.url
  =*  path  q.q.p.url
  =*  quer    r.p.url
  ?:  ?=(%| -.r.p.p.url)  ~
  ?:  ?&  =(`0 (find ~['com' 'youtube'] p.host))
          ?=(^ (find ~['watch'] path))
      ==
    `(~(got by (~(gas by *(map @t @t)) quer)) 'v')
  ?:  =(`0 (find ~['be' 'youtu'] p.host))
    `(snag 0 path)
  ~
::
++  request-video-details
  |=  video-ids=(list cord)
  ^-  move
  =/  ids=cord
    %+  roll  video-ids
    |=  [id=cord all=cord]
    ^-  cord
    ?:  =(`@`0 all)  id
    (cat 3 (cat 3 all ',') id)
  :-  ost.bol
  =-  [%hiss /yt-vid ~ %json %hiss -]
  ^-  hiss:eyre
  %-  request-to-hiss:http
  ^-  request:http
  :*  ~['com' 'googleapis' 'www']
      /youtube/v3/videos
      %get
      *math:eyre
      :~  ['part' 'snippet,contentDetails']
          ['key' 'AIzaSyBl-nNNveSpKMXL8YDdF4_ctiNlFhPuSOI']
          ['id' ids]
      ==
  ==
::
++  sigh-json-yt-vid
  |=  [wir=wire jon=json]
  ^-  (quip move _this)
  =+  res=(parse-video-details jon)
  =/  was-idle=?  =(0 ~(wyt by videos))
  ::  update state with potential new videos
  ::
  =.  queue
    %+  roll  res
    |=  [[id=cord *] q=_queue]
    ?:  (~(has by videos) id)  q
    (weld q [id]~)
  =.  videos  (~(gas by videos) res)
  ::  if we weren't playing yet, and there's a queue now, start playing
  ::
  ?.  was-idle  [~ this]
  ?:  =(0 (lent queue))  [~ this]
  %-  play-next(queue (slag 1 queue))
  (snag 0 queue)
::
++  parse-video-details
  =,  dejs:format
  |=  jon=json
  ^-  (list [id=cord title=cord duration=@dr])
  %.  jon
  =-  (ot 'items'^- ~)
  %-  ar
  =-  %-  ot
      :~  'id'^so
          'snippet'^(ot 'title'^so ~)
          'contentDetails'^(ot 'duration'^(cu yule (su parse-duration)) ~)
      ==
  ::  parse ISO 8401 duration (excluding months, years)
  ::
  ^=  parse-duration
  ;~  pfix  (jest 'PT')
    ;~  plug
      (easy 0)
      ;~(pose ;~(sfix dum:ag (just 'H')) (easy 0))
      ;~(pose ;~(sfix dum:ag (just 'M')) (easy 0))
      ;~(pose ;~(sfix dum:ag (just 'S')) (easy 0))
      (easy ~)
    ==
  ==
::
++  wake-next
  |=  [wir=wire ~]
  ^-  (quip move _this)
  =^  next-id=video-id  queue
    ?^  queue  [i.queue t.queue]
    :_  queue
    =+  video-list=~(tap by videos)
    =+  count=(lent video-list)
    =<  p
    %+  snag
      (~(rad og eny.bol) count)
    video-list
  ::TODO  update subscribers
  ~&  [%now-playing next-id]
  (play-next next-id)
::
++  play-next
  |=  next-id=video-id
  ^-  (quip move _this)
  ?:  =(0 ~(wyt by videos))
    ~&  %silently-drop-timer
    [~ this]
  :_  this(now-playing next-id)
  =-  ~&  [%next-song-length-is -]
      [ost.bol %wait /next (add now.bol -)]~
  duration:(~(got by videos) next-id)
--
