import UIKit

public extension UIImage {
    func croppingToSquare() -> UIImage? {
        guard let cgImage = cgImage else { return nil }
        let resizeSize = min(cgImage.width, cgImage.height)
        let cropCGImage = cgImage.cropping(
            to: .init(
                x: (cgImage.width - resizeSize) / 2,
                y: (cgImage.height - resizeSize) / 2,
                width: resizeSize,
                height: resizeSize
            )
        )

        guard let cropCGImage = cropCGImage else { return nil }
        return UIImage(cgImage: cropCGImage, scale: 0, orientation: imageOrientation)
    }
}
