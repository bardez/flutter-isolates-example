# isolate_example

A Flutter project that works with isolates.

## Content

- Low-level Way
  - Using [Isolate.spawn()](https://api.dart.dev/stable/2.15.1/dart-isolate/Isolate/spawn.html), SendPort and ReceivePort to manipulate data and "move between isolates"
- One-Function Way
  - Using a flutter [compute()](https://api.flutter.dev/flutter/foundation/compute-constant.html) function to create a instant isolate.

## References

- [https://docs.flutter.dev/cookbook/networking/background-parsing#4-move-this-work-to-a-separate-isolate](https://docs.flutter.dev/cookbook/networking/background-parsing#4-move-this-work-to-a-separate-isolate)
- [Tadas Petra - video](https://www.youtube.com/watch?v=TF8LwonwKhg)
- [Didier - future vs isolates](https://www.didierboelens.com/2019/01/futures-isolates-event-loop/)
