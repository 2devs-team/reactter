

# What is?

Reactter is a package that uses [Get](https://get.dev) as base to implement reactive behavior using some names and functionality we are familiarized from React Js. 


# Features
- useEffect
- useState
- Reactter View
- Reactter State
- Reactter Controller
- Routing Controller
- Helpers
- Exceptions
- Types

<br>

# Usage

## useState:

```dart
//You can do this:
 late Reactter<int> counter = useState('counter', 0);

//Or add callbacks to catch events  
 late Reactter<int> counter = useState(
    'counter', 0,
    willUpdate: (prevValue, _) => {
      print("Before update!"),
    },
    didUpdate: (_, nextValue) => {
      print("After update!"),
    },
  );
```

## useEffect:
> You can use multiple ids

```dart 
Widget build(BuildContext context) {
    return UseEffect<YourController>(
        id: ['counter', 'loading']
        builder: (controller) => Text(controller.counter.value.toString())
    );
}
```

## Getting started

Just import the package

```dart
import 'package:reactter/reactter.dart';
```

<br>

# WARNING: 
## **This package still in development, you can use it for testing or in small example applications, IT'S NOT RECOMMENDED TO USE IT IN PRODUCTION.**

<br>

Copyright (c) 2022 **2devs.io**