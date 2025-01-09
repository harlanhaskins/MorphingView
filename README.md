# MorphingView

UIKit and SwiftUI views for morphing between views, similar to the morph in iOS's
drag-and-drop, context menu, and zoom transition.

## Installation

MorphingView can be added to your project using Swift Package Manager. For more
information on using SwiftPM in Xcode, see [Apple's guide](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app)

If you're using package dependencies directly, you can add this as one of your dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/harlanhaskins/MorphingView.git", from: "0.0.1")
]
```

## Usage

See the sample app for a working example.

https://github.com/user-attachments/assets/4fa4ca59-52ae-4271-b968-efd1bcd7b806

### SwiftUI

Create a MorphView with a list of child views that are each tagged with an appropriate tag. To choose
the currently displayed view, pass the ID corresponding to one of the children to the `id:` parameter.

```swift
enum MorphContent {
    case image, text, complexView
}

struct MyMorphingView: View {
    @State var selectedViewID: MorphContent = .image

    var body: some View {
        MorphView(id: selectedViewID) {
            Image(...)
                .tag(MorphContent.image)
            Text("...")
                .tag(MorphContent.text)
            ComplexView(...)
                .tag(MorphContent.complexView)
        }
    }
}
```

You can animate these changes either by wrapping the change in a `withAnimation` block or by adding
```
.animation(yourAnimation, value: selectedViewID)
```

to the view hierarchy.

### UIKit

First, add the set of views you intend to morph between as subviews of this view.

```swift
let morphingView = MorphingView()
morphingView.addSubview(imageView)
morphingView.addSubview(textView)
morphingView.addSubview(shapeView)
```

From here, you can either morph in-order from one view to another using the `morph(to:timingParameters:)`
method, or set the `.index` property directly.

```swift
// Morph without animation
morphingView.morph()

// Morph with an internal interruptible animation with the given timing curve
let springTiming = UISpringTimingParameters(duration: 0.4, bounce: 0.1)
morphingView.morph(timingParameters: springTiming)

// Morph to a specific index with an implicit UIView animation
UIView.animate(withDuration: 2.0) {
    morphingView.morph(to: 2) // equivalent to `morphingView.index = 2`
}

// Morph to a specific index without animating.
morphingView.index = 2
```

## Author

Harlan Haskins ([harlan@harlanhaskins.com](mailto:harlan@harlanhaskins.com))
