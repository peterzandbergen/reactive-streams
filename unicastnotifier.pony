use "collections"

class UnicastNotifier[A: Any #share] is PublisherNotify[A]
  var _sub: (Subscriber[A] | None) = None
  var _requests: U64 = 0
  let _data: List[A] = List[A]
  var _completed: Bool = false


  fun ref on_subscribe(pub: DefaultPublisher[A], sub: Subscriber[A] tag): Bool =>
    match _sub
    | let s: Subscriber[A] =>
      sub.on_error(AlreadySubscribed)
      false
    | None => _sub = sub
      send_data()
      true
    else
      false
    end


  fun ref on_request(pub: DefaultPublisher[A], 
    sub: Subscriber[A] tag, n: U64) 
  =>
    match _sub
    | let s: Subscriber[A] tag =>
      if _sub is s then
        _requests = _requests + n
        send_data()
      end
    end


  fun ref on_cancel(pub: DefaultPublisher[A], sub: Subscriber[A] tag) =>
    match _sub
    | let s: Subscriber[A] tag =>
      if _sub is s then
        _sub = None
      end
    end


  fun ref on_publish(pub: DefaultPublisher[A], d: A) =>
    """
    Collect the data and try to send it.
    """
    _data.push(d)
    send_data()


  fun ref on_complete(pub: DefaultPublisher[A]) =>
    match _sub
    | let s: Subscriber[A] tag =>
      if _sub is s then
        _completed = true
        send_data()
      end
    end

  fun ref send_data() =>
    match _sub
    | let s: Subscriber[A] tag =>
      if _sub is s then
        while (_requests > 0) and (_data.size() > 0) do
          try
            s.on_next(_data.shift())
            _requests = _requests - 1
          end
        end
        if _completed and (_data.size() == 0) then
          _sub = None
          s.on_complete()
        end
      end
    end
