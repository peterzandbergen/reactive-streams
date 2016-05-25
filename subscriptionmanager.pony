use "collections"

interface SubscriptionManager[A: Any #share]
  """
  A managed publisher needs a subscription manager to handle the subscriptions.
  This allows the substitution of different behaviour, like broadcast or unicast.
  """

  fun ref add(sub: Subscriber[A] tag)
    """
    """

  fun ref remove(sub: Subscriber[A] tag)
    """
    """
  fun box contains(sub: Subscriber[A] tag): Bool
    """
    """

  fun val max_bound(): U64
    """
    The maximum number of requests that can be sent to the subscribers.
    """

  fun ref next(d: A)
    """
    Send next to all subscribers.
    """

class SingleSubscriptionManager[A: Any #share] is SubscriptionManager[A]
  """
  Default subscription manager
  """

  // the managed subscribers..
  var _sub: (Subscriber[A] tag | None) = None
  var _count: U64 = 0

  fun ref add(sub: Subscriber[A] tag) =>
    """
    """
    match _sub
    | None => _sub = sub
    end

  fun ref remove(sub: Subscriber[A]) =>
    """
    """
    _sub = None

  fun box contains(sub: Subscriber[A]): Bool =>
    """
    """
    not (_sub is None)

  fun max_bound(): U64 =>
    """
    The maximum number of requests that can be sent to the subscribers.
    TODO: this is not correct.
    """
    _count

  fun ref next(d: A) =>
    """
    Send next to all subscribers.
    """
    _count = _count + 1

class DefaultSubscriptionManager[A: Any #share] is SubscriptionManager[A]
  """
  Default subscription manager
  """

  // the managed subscribers..
  let _subs: SetIs[Subscriber[A] tag] = SetIs[Subscriber[A]]

  fun ref add(sub: Subscriber[A] tag) =>
    """
    """
    _subs.set(sub)

  fun ref remove(sub: Subscriber[A]) =>
    """
    """
    _subs.unset(sub)

  fun box contains(sub: Subscriber[A]): Bool =>
    """
    """
    _subs.contains(sub)

  fun max_bound(): U64 =>
    """
    The maximum number of requests that can be sent to the subscribers.
    """
    0

  fun next(d: A) =>
    """
    Send next to all subscribers.
    """
    None
