use "collections"
use "logger"


class NoSubscription is Subscription
  """
  NoSubscription is a noop class, used to make the code easier.
  """
  fun ref request(n: U64) =>
    None

  fun ref cancel() =>
    None

actor StringSubscriber is Subscriber[String]
  var _sub: (NoSubscription | Subscription) = NoSubscription
  let _env: Env
  var _mod: U64 = 0
  let _modmod: U64 = 5
  let _main: Main

  new create(main: Main, env: Env) =>
    _main = main
    _env = env

  be on_subscribe(s: Subscription iso) =>
    _env.out.print("on_subscribe")
    _sub = consume s
    _sub.request(_modmod)

  be on_next(a: String) =>
    """
    on_next is called by the publisher when new data is available.
    """
    _env.out.print("on_next: " + a)
    // Send a request for new data each _mod times.
    _mod = (_mod + 1) % _modmod
    if _mod == 0 then
      _sub.request(_modmod)
      _env.out.print("sent next: " + _modmod.string())
    end

  be on_error(e: ReactiveError) =>
    """
    on_error is called in error. stop the subscription.
    """
    _sub = NoSubscription
    _env.out.print("on_error")

  be on_complete() =>
    _sub = NoSubscription
    _env.out.print("on_complete")

actor Yield
  let _main: Main

  new create(main: Main) =>
    _main = main

  be yield() =>
    _main.yield()


actor Main
  let _env: Env
  let _publisher: DefaultPublisher[String]
  var _n: U64 = 0

  new create(env: Env) =>
    _env = env
    let notify = UnicastNotifier[String]
    _publisher = DefaultPublisher[String](consume notify)

    let sub = StringSubscriber(this, env)
    _publisher.subscribe(sub)

    _publish("Hallo")
    let y = Yield(this)
    y.yield()

    // yield()


  be yield() =>
    _publish("Hallo")
    _publish("Hallo")
    _publish("Hallo")
    _publish("Hallo")
    _publish("Hallo")
    _publish("Hallo")
    _publish("Hallo")
    _publish("Hallo")
    _publish("Hallo")
    _publish("Hallo")
    _publish("Hallo")
    _publish("Hallo")
    _publish("Hallo")
    _publish("Hallo")
    _publish("Hallo")
    _publish("Hallo")
    _publish("Hallo")
    _publish("Hallo")
    _publish("Hallo")
    _publish("Hallo")
    _publish("Hallo")
    _publisher.complete()
    _env.out.print("called complete")



  fun ref _publish(s: String) =>
    let n = (_n = _n + 1)
    _publisher.publish(n.string() + ": " + s)
    _env.out.print("called publish: " + n.string())


