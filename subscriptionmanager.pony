use "collections"

interface SubscriptionManager[A: Any #share]
  """
  A managed publisher needs a subscription manager to handle the subscriptions.
  This allows the substitution of different behaviour, like broadcast or unicast.
  """

  fun add(sub: Subscriber[A] tag)
    """
    """

  fun remove(sub: Subscriber[A] tag)
    """
    """
  fun contains(sub: Subscriber[A] tag): Bool
    """
    """

  fun max_bound(): U64
    """
    The maximum number of requests that can be sent to the subscribers.
    """

  fun next(d: A)
    """
    Send next to all subscribers.
    """

class DefaultSubscriptionManager[A: Any #share] is SubscriptionManager[A]
  """
  Default subscription manager
  """

  // the managed subscribers..
  let _subs: SetIs[Subscriber[A]] = SetIs[Subscriber[A]]

  fun add(sub: Subscriber[A]) =>
    """
    """
    None

  fun remove(sub: Subscriber[A]) =>
    """
    """
    None

  fun contains(sub: Subscriber[A]): Bool =>
    """
    """
    false

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
