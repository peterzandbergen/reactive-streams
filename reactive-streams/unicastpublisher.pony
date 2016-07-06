class Unicast[A: Any #share] is SubscriberManager[A]

  fun on_request(s: Subscriber[A] tag, n: U64) =>
  """
  """
  None

  fun on_cancel(s: Subscriber[A] tag) =>
  """
  """
  None