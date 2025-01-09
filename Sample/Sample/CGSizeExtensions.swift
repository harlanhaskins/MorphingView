import CoreGraphics

extension CGSize {
    /// Determines the appropriate scale factor to apply to the receiver such that the receiver
    /// fits itself into the target size without extending outside.
    func scaleFactorToFit(_ target: CGSize) -> CGFloat {
        min(target.width / width, target.height / height)
    }

    /// Determines the appropriate scale factor to apply to the receiver such that the receiver
    /// fills the target size, possibly extending outside the target on its larger dimension.
    func scaleFactorToFill(_ target: CGSize) -> CGFloat {
        max(target.width / width, target.height / height)
    }

    /// Determines the scaled size of the receiver such that it fits itself into the target
    /// size without extending outside.
    func scaledToFit(_ target: CGSize) -> CGSize {
        let scale = scaleFactorToFit(target)
        return CGSize(width: width * scale, height: height * scale)
    }

    /// Determines the scaled size of the receiver such that it fills the target size,
    /// possibly extending outside the target on its larger dimension.
    func scaledToFill(_ target: CGSize) -> CGSize {
        let scale = scaleFactorToFill(target)
        return CGSize(width: width * scale, height: height * scale)
    }
}
