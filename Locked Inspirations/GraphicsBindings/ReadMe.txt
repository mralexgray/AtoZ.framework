This is a simple graphics application that uses bindings.  It displays and allows you to edit a collection of circles, each of which may have a shadow.

There are two main features, related to each of the custom view classes.


GraphicsView displays a collection of graphic objects.  It is bound to an array controller that manages the array of graphics and the selection.


Joystick is a controller-style view.  It allows the user to set an offset and an angle, and provides bindings for the same. This is used to adjust the shadow of the current selection in the view.  Of particular interest are the facts that it handles different markers (for multiple selection and so on) and that it allows a binding option to be set to disable handling of multiple selection.

One easily-missed feature: If the current selection all share the same shadow offset but not same angle, or the same angle but not the same offset, and you hold down the Shift key while you move the mouse in the view, the shared offset or angle respectively will be maintained.
