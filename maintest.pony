use "collections"
use "logger"

class NoSubscription is Subscription
  fun ref request(n: U64) =>
    None

  fun ref cancel() =>
    None

actor StringSubscriber is Subscriber[String]
  var _sub: (NoSubscription | Subscription) = NoSubscription
  let _env: Env
  var _mod: U64 = 0
  let _modmod: U64 = 4
  let _main: Main

  new create(main: Main, env: Env) =>
    _main = main
    _env = env

  be on_subscribe(s: Subscription iso) =>
    _env.out.print("on_subscribe")
    _sub = consume s
    _sub.request(_modmod)

  be on_next(a: String) =>
    _env.out.write("on_next: ")
    _env.out.print(a)
    _mod = (_mod + 1) % _modmod
    if _mod == 0 then
      _sub.request(_modmod)
      _env.out.print("sent next: " + _modmod.string())
    end

  be on_error(e: ReactiveError) =>
    _env.out.print("on_error")

  be on_complete() =>
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

  new create(env: Env) =>
    _env = env
    let notify = UnicastNotifier[String]
    _publisher = DefaultPublisher[String](consume notify)

    let sub = StringSubscriber(this, env)
    _publisher.subscribe(sub)

    _publisher.publish("Hallo")
    _env.out.print("called publish")
    let y = Yield(this)
    y.yield()

    // yield()


  be yield() =>
    _publisher.publish("Hallo")
    _env.out.print("called publish")
    _publisher.publish("Hallo")
    _env.out.print("called publish")
    _publisher.publish("Hallo")
    _env.out.print("called publish")
    _publisher.publish("Hallo")
    _env.out.print("called publish")
    _publisher.publish("Hallo")
    _env.out.print("called publish")
    _publisher.publish("Daar")
    _env.out.print("called publish")
    _publisher.publish("Daar")
    _env.out.print("called publish")
    _publisher.publish("Daar")
    _env.out.print("called publish")
    _publisher.publish("Daar")
    _env.out.print("called publish")
    _publisher.publish("Daar")
    _env.out.print("called publish")
    _publisher.publish("Daar")
    _env.out.print("called publish")


    // loop()

  be loop() =>
    loop()
