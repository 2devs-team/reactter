
# Roadmap
We want keeping adding features for `Reactter`, those are some we have in mind order by priority:

**V2**
- **Tests**
  - Make `Reactter` easy to test.
- **Creates**
  - Have the option for create same instances from a context with different ids, usefull for lists of widgets where each widget goint to have his own state.
- **Lazy UseContext**
  - Don't initialize a context until you will need it.
- **Child widget optional for render**
  - Save a child which won't re-render when the state change.
- **ReactterComponent**
  - A StatelessWidget who going to expose a `ReactterContext` state for all the widget, without needing to write `context.of<T>()`, just `state.someProp`.
- **Equatable**
  - For remove the prop `alwaysUpdate` in state when you are working with Objects or List.

**ReactterComponents (new package)**
- Buttons (Almost ready for release)
- App Bars
- Bottom Bars
- Snackbars
- Drawers
- Floating actions
- Modals
- Inputs
<br><br>



# Contribute
If you want to contribute don't hesitate to create an issue or pull-request in **[Reactter repository](https://github.com/Leoocast/reactter).**

You can find us in twitter:
*  [@leoocast10](https://twitter.com/leoocast10)

or by email:

- Leo Castellanos <leoocast.dev@gmail.com>
- Carlos León <carleon.dev@gmail.com> 

<br>

## Copyright (c) 2022 **[2devs.io](https://2devs.io/)** 