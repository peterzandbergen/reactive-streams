interface ManagedPublisher[A: Any #share] is Publisher[A]
  """
  """

  be _request(s: Subscriber[A] tag, n: U64)
  """
  """

  be _cancel(s: Subscriber[A] tag)
  """
  """


actor DefaultPublisher[A: Any #share] is ManagedPublisher[A]

  let _sm: SubscriptionManager[A] iso

  new create(sm: SubscriptionManager[A] iso^) =>
    """
    sm needs to be an iso I can keep, hence the ^
    """
    _sm = sm


  be subscribe(sub: Subscriber[A]) =>
    if _sm.contains(sub) then
      sub.on_error(AlreadySubscribed)
    else
      _sm.add(sub)
      sub.on_subscribe(recover _Subscription[A](sub, this) end)
    end

  be _request(sub: Subscriber[A], n: U64) =>
    """
    Increment the bound on the subscription.
    """
    if _sm.contains(sub) then
      _sm.remove(sub)
    else
      sub.on_error(NotSubscribed)
    end

  be _cancel(sub: Subscriber[A]) =>
    if _sm.contains(sub) then
      _sm.remove(sub)
    else
      sub.on_error(NotSubscribed)
    end


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
