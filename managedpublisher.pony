interface ManagedPublisher[A: Any #share] is Publisher[A]
  """
  """

  be publish(d: A)
  """
  Publish data.
  """

  be send_data()
  """
  Trigger a send, should only be called from the PublisherNotify.
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

  fun ref on_subscribe(pub: DefaultPublisher[A], sub: Subscriber[A] tag): Bool
  """
  Register the new subscriber. Return true if successful.
  """

  fun ref on_request(pub: DefaultPublisher[A], sub: Subscriber[A] tag, n: U64)
  """
  Handle the subscriber's request for more data.
  """

  fun ref on_cancel(pub: DefaultPublisher[A], sub: Subscriber[A] tag)
  """
  Handle the subscriber's request for cancelation.
  """

  fun ref on_publish(pub: DefaultPublisher[A], data: A)
  """
  Accept the new data and pass it on.
  """

  fun ref on_send_data(pub: DefaultPublisher[A])
  """
  Called when data can be possibly sent.
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

  fun ref request(n: U64) =>
    if not _canceled then
      _pub._request(_sub, n)
    end

  fun ref cancel() =>
    if not _canceled then
      _pub._cancel(_sub)
      _canceled = true
    end
