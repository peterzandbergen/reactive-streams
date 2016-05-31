use "collections"
use "logger"


// actor PublisherTry[A: Any #share] is ManagedPublisher[A]
//   """
//   This try is a unicast publisher.
//   """
//   var _sub: (Subscriber[A] | None) = None
//   var _requests: U64 = 0
//   let _queue: Array[A] = Array[A]
//
//   be subscribe(sub: Subscriber[A]) =>
//     """
//     Accept the subscription if None present.
//     """
//     match _sub
//     | None =>
//       _sub = sub
//       sub.on_subscribe(recover iso _Subscription[A](sub, this) end)
//     | let sub': Subscriber[A] =>
//       if sub' is _sub then
//         sub'.on_error(AlreadySubscribed)
//       else
//         sub'.on_error(PublisherFull)
//       end
//     end
//
//   be _request(s: Subscriber[A] tag, n: U64) =>
//     match _sub
//     | let s': Subscriber[A] =>
//       if s' is s then
//         _requests = _requests + n
//         // Send items in queue.
//         while (_requests > 0) and (_queue.size() > 0) do
//           try
//             s'.on_next(_queue.pop())
//             _requests = _requests - 1
//           end
//         end
//       end
//     end
//
//   be _cancel(sub: Subscriber[A] tag) =>
//     """
//     Cleanup the subsriber and empty the queue.
//     """
//     match _sub
//     | let s': Subscriber[A] =>
//       _sub = None
//       _queue.clear()
//     end
//
//
// actor SubscriberTry[A: Any #share] is Subscriber[A]
//   var _sub: (Subscription| None) = None
//
//   // new create(env: Env) =>
//   //   _log = StringLogger()
//
//   be on_subscribe(s: Subscription iso) =>
//     match _sub
//     | let s': Subscription =>
//       // TODO: Error.
//       return
//     end
//
//     match _sub
//     | let s': Subscription =>
//       s'.request(1)
//     end
//
//   be on_next(a: A) =>
//     match _sub
//     | let s': Subscription =>
//       s'.request(1)
//     end
//
//   be on_error(e: ReactiveError) =>
//     None
//
//   be on_complete() =>
//     None
//

actor Main
  new create(env: Env) =>
    None
