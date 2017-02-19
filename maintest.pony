use "collections"
use "ponytest"
use "reactive-streams"


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



actor Main is TestList
  new create(env: Env) =>
    PonyTest(env, this)

  new make() =>
    None

  fun tag tests(test: PonyTest) =>
    test(_TestOne)

class iso _TestOne is UnitTest
  fun name(): String => "Test one"

  fun apply(h: TestHelper) =>
    h.log("Look ma, I'm testing...", true)
    h.assert_eq[U32](1, 1)
    h.long_test(1000_000)
    h.complete(true)