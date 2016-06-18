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

  fun ref on_complete(pub: DefaultPublisher[A])
  """
  Send complete to the subscriber.
  """

