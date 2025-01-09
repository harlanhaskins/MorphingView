//
//  MorphingView.swift
//  MorphingView
//
//  Created by Harlan Haskins on 1/8/25.
//

import UIKit

/// A container UIView that "morphs" its content between its subviews.
/// 
/// To use it, first add the set of views you intend to morph between as subviews of this view.
/// 
/// ```
/// let morphingView = MorphingView()
/// morphingView.addSubview(imageView)
/// morphingView.addSubview(textView)
/// morphingView.addSubview(shapeView)
/// ```
/// 
/// From here, you can either morph in-order from one view to another using the `morph(to:timingParameters:)`
/// method:
/// 
/// ```
/// // Morph without animation
/// morphingView.morph()
/// 
/// // Morph with an internal interruptible animation with the given timing curve
/// let springTiming = UISpringTimingParameters(duration: 0.4, bounce: 0.1)
/// morphingView.morph(timingParameters: springTiming)
/// 
/// // Morph to a specific index with an implicit UIView animation
/// UIView.animate(withDuration: 2.0) {
///     morphingView.morph(to: 2)
/// }
/// 
/// // Morph to a specific index without animating.
/// morphingView.index = 2
/// ```
public final class MorphingView: UIView {
    private var viewIndex = 0 {
        didSet {
            clampIndex()
        }
    }

    func clampIndex() {
        if viewIndex < 0 {
            viewIndex = subviews.count - 1
        }

        if viewIndex >= subviews.count {
            viewIndex = 0
        }
    }

    /// Sets the currently visible view, morphing other views out.
    /// Non-animated; you are responsible for animating the morph index if this is used.
    public var index: Int {
        get {
            viewIndex
        }
        set {
            viewIndex = newValue
            update()
        }
    }
    private var animator: UIViewPropertyAnimator?
    private var hasInitialized = false

    /// Creates a `MorphingView` with an initial set of subviews.
    public init(views: [UIView] = []) {
        super.init(frame: .zero)

        for view in views {
            addSubview(view)
        }
        update()
        hasInitialized = true
    }
    
    /// Morphs the contents of this view to the view at the specified index, or to the next index
    /// if no index is provided.
    /// - Parameters:
    ///   - newIndex: The index to morph to. If this index is out of bounds, the nearest index will be chosen.
    ///   - timingParameters: Optional animation timing parameters to animate this change with.
    ///    This uses an interruptible property animator to morph between views. If not provided, the change
    ///    is not animated; you will be responsible for animating these changes.
    public func morph(
        to newIndex: Int? = nil,
        timingParameters: (any UITimingCurveProvider)? = nil
    ) {
        viewIndex = newIndex ?? viewIndex + 1
        animator?.stopAnimation(/* withoutFinishing: */true)

        if let timingParameters {
            let animator = UIViewPropertyAnimator(duration: 0, timingParameters: timingParameters)
            animator.addAnimations {
                self.update()
            }
            animator.addCompletion { [weak self] _ in
                self?.animator = nil
            }
            animator.startAnimation()
            self.animator = animator
        } else {
            self.update()
        }
    }

    public override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        if hasInitialized {
            update()
        }
    }

    public override func willRemoveSubview(_ subview: UIView) {
        super.willRemoveSubview(subview)
        if hasInitialized {
            clampIndex()
        }
    }

    private func update() {
        if subviews.isEmpty { return }

        let current = subviews[index]
        for (idx, view) in subviews.enumerated() {
            if idx == index {
                view.alpha = 1
                view.transform = .identity
            } else {
                view.alpha = 0
                view.transform = view.bounds.size.scaleTransform(to: current.bounds.size)
            }
        }
    }

    public override func sizeToFit() {
        var size = CGSize.zero
        for view in subviews {
            let childSize = view.bounds.size
            size.width = max(size.width, childSize.width)
            size.height = max(size.height, childSize.height)
        }
        bounds.size = size
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let boundsCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        for view in subviews {
            view.center = boundsCenter
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
}
