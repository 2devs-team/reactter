
<div align="center">
    <img src="https://raw.githubusercontent.com/Leoocast/2devs/main/public/reactter_logo.png?token=GHSAT0AAAAAABSVITVYL2PFKKCZUMWQV6KYYRVTNSQ"
        alt="Markdown Monster icon"
        style="width: 30%" />
</div>

# What is?

Reactter is a package that uses [Get](https://pub.dev/packages/get) as base to implement reactive behavior using some names and functionality we are familiarized from React Js. 

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

# Development by **2devs.io**

- Leo Castellanos <leoocast.dev@gmail.com>
- Carlos León <carleon.dev@gmail.com> 

<BR>


Copyright (c) 2022 **2devs.io**