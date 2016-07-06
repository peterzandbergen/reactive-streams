interface ManagedPublisher[A: Any #share] is Publisher[A]
  """
  """

  fun get_manager(): SubscriberManager[A]

  be _request(s: Subscriber[A] tag, n: U64) =>
  """
  This behaviour is called by the _Subscription to request more data.
  """
    get_manager().on_request(s, n)

  be _cancel(s: Subscriber[A] tag) =>
  """
  This behaviour is called by the _Subscription to cancel the subscription.
  """
    get_manager().on_cancel(s)


interface SubscriberManager[A: Any #share]
  """
  This is the interface that each subscriber manager needs to implement.
  """

  fun ref on_request(s: Subscriber[A] tag, n: U64)
  """
  """

  fun ref on_cancel(s: Subscriber[A] tag)
  """
  """


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


  fun request(n: U64) =>
    if not _canceled then
      _pub._request(_sub, n)
    end


  fun ref cancel() =>
    if not _canceled then
      _pub._cancel(_sub)
      _canceled = true
    end
