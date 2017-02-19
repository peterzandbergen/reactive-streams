class NoSubscription is Subscription
  """
  NoSubscription is a noop class, used to make the code easier.
  """
  fun ref request(n: U64) =>
    None

  fun ref cancel() =>
    None



actor DefaultSubscriber[A: Any #share] is Subscriber[A]
  var _sub: (NoSubscription | Subscription) = NoSubscription
  var _mod: U64 = 0
  let _modmod: U64 = 5

  // TODO: accept a notifier handling the required asynchronous calls.
  new create() =>
    None

  be on_subscribe(s: Subscription iso) =>
    _sub = consume s
    _sub.request(_modmod)

  be on_next(a: A) =>
    """
    on_next is called by the publisher when new data is available.
    """
    // Do something, like calling a SubscriberNotifier.
    _mod = (_mod + 1) % _modmod
    if _mod == 0 then
      _sub.request(_modmod)
    end

  be on_error(e: ReactiveError) =>
    """
    on_error is called in error. stop the subscription.
    """
    // Call the notify.
    _sub = NoSubscription

  be on_complete() =>
    _sub = NoSubscription

