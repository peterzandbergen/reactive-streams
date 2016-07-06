actor DefaultPublisher[A: Any #share]
  let manager: SubscriberManager[A]

  new create(mgr: SubscriberManager[A] iso) =>
    manager = consume mgr

  fun ref get_manager(): SubscriberManager[A] ref =>
    manager


actor Main

  new create(env: Env) =>
    // Create a publixher.
    // let pub = Mana

    None