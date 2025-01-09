//
//  CGSizeExtensions.swift
//  MorphingView
//
//  Created by Harlan Haskins on 1/8/25.
//

import CoreGraphics

extension CGSize {
    /// Determines the counter-scale necessary to apply to the receiver such that it becomes
    /// the target size.
    func relativeScale(
        to target: CGSize
    ) -> CGSize {
        CGSize(
            width: target.width / width,
            height: target.height / height)
    }

    /// Creates a CGAffineTransform that counter-scales the recieving layer to make it visually
    /// the same as the target size.
    func scaleTransform(to target: CGSize) -> CGAffineTransform {
        let scale = relativeScale(to: target)
        return CGAffineTransform(scaleX: scale.width, y: scale.height)
    }
}
