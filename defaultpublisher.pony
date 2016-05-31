actor DefaultPublisher[A: Any #share] is ManagedPublisher[A]
  """
  This actor is modelled as the TcpConnection using Notify classes that
  run inside the actor and determine the behaviour of the Publisher.
  """
  let _pn: PublisherNotify[A]


  new create(notify: PublisherNotify[A] iso) =>
    """
    Accept the nofify object and keep it.
    """
    _pn = consume notify


  be subscribe(sub: Subscriber[A] tag) =>
    """
    Pass the subscription
    """
    if _pn.on_subscribe(this, sub) then
      sub.on_subscribe(recover _Subscription[A](sub, this) end)
    end

  be send_data() =>
    _pn.on_send_data(this)


  be publish(d: A) =>
    _pn.on_publish(this, d)


  be _request(sub: Subscriber[A] tag, n: U64) =>
    """
    Increment the bound on the subscription.
    """
    _pn.on_request(this, sub, n)


  be _cancel(sub: Subscriber[A] tag) =>
    """
    Subscriber canceled the subscription.
    """
    _pn.on_cancel(this, sub)
