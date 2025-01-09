//
//  MorphView.swift
//  MorphingView
//
//  Created by Harlan Haskins on 1/8/25.
//

import SwiftUI

/// A SwiftUI container view that morphs its contents between one of a set of child Views.
///
/// To use it, add a list of child views that are each tagged with an appropriate tag. To choose
/// the currently displayed view, pass the ID corresponding to one of the children to the `id:` parameter.
///
/// ```
/// enum MorphContent {
///     case image, text, complexView
/// }
///
/// MorphView(id: selectedViewID) {
///     Image(...)
///         .tag(MorphContent.image)
///     Text("...")
///         .tag(MorphContent.text)
///     ComplexView(...)
///         .tag(MorphContent.complexView)
/// }
/// ```
///
/// You can animate these changes either by wrapping the change in a `withAnimation` block or by adding
/// ```
/// .animation(yourAnimation, value: selectedViewID)
/// ```
/// to the view hierarchy.
@available(iOS 18.0, macCatalyst 18.0, *)
public struct MorphView<ID: Hashable, Content: View>: View {
    var id: ID
    var content: Content
    @State var childSizes = [ID: CGSize]()

    public init(
        id: ID,
        @ViewBuilder content: () -> Content
    ) {
        self.id = id
        self.content = content()
    }

    public var body: some View {
        ZStack {
            let selectedSize = childSizes[id] ?? .zero
            ForEach(subviews: content) { subview in
                let tag = subview.containerValues.tag(for: ID.self)
                    .unwrap("MorphView child views must have tags of type \(_typeName(ID.self, qualified: false))")
                let size = childSizes[tag, default: .zero]
                subview
                    .zIndex(tag == id ? 1 : 0)
                    .opacity(tag == id ? 1 : 0)
                    .onGeometryChange(for: CGSize.self) { proxy in
                        proxy.size
                    } action: { size in
                        childSizes[tag] = size
                    }
                    .scaleEffect(
                        size.relativeScale(to: selectedSize)
                    )
            }
        }
    }
}

extension Optional {
    @_transparent
    func unwrap(_ message: String) -> Wrapped {
        guard let value = self else {
            fatalError(message)
        }
        return value
    }
}
