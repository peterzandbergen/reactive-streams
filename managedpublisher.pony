interface ManagedPublisher[A: Any #share] is Publisher[A]
  """
  """

  be _request(s: Subscriber[A] tag, n: U64)
  """
  This behaviour is called by the _Subscription to request more data.
  """

  be _cancel(s: Subscriber[A] tag)
  """
  This behaviour is called by the _Subscription to cancel the subscription.
  """

interface PublisherNotify[A: Any #share]
  """
  Called by the DefaultPublisher to allow code injection.
  """
  fun on_subscribe(pub: ManagedPublisher[A] ref, sub: Subscriber[A] tag)

  fun on_request(pub: ManagedPublisher[A] ref, sub: Subscriber[A] tag, n: U64)

  fun on_cancel(pub: ManagedPublisher[A] ref, sub: Subscriber[A] tag)



actor DefaultPublisher[A: Any #share] is ManagedPublisher[A]
  """
  This actor is modelled as the TcpConnection using Notify classes that
  run inside the actor and determine the behaviour of the Publisher.
  """

  let _pn: PublisherNotify[A] box

  new create(notify: PublisherNotify[A] iso^) =>
    """
    sm needs to be an iso I can keep, hence the ^
    """
    _pn = notify


  be subscribe(sub: Subscriber[A] tag) =>
    """
    """
    _pn.on_subscribe(this, sub)


  be _request(sub: Subscriber[A] tag, n: U64) =>
    """
    Increment the bound on the subscription.
    """
    _pn.on_request(this, sub, n)


  be _cancel(sub: Subscriber[A] tag) =>
    _pn.on_cancel(this, sub)


class _Subscription[A: Any #share] is Subscription
  """
  Internal subscription which is type safe and passes the request and cancel to
  the managed publisher.
  Also makes the calls idempotent.
  """
  let _sub: Subscriber[A] tag
  let _pub: ManagedPublisher[A] tag
  var _canceled: Bool = false

  new create(sub: Subscriber[A] tag, pub: ManagedPublisher[A] tag) =>
    _sub = sub
    _pub = pub

  fun ref request(n: U64) =>
    if not _canceled then
      _pub._request(_sub, n)
    end

  fun ref cancel() =>
    if not _canceled then
      _pub._cancel(_sub)
      _canceled = true
    end
