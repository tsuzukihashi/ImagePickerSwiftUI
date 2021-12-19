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
        let cropImage = UIImage(cgImage: cropCGImage)
        return cropImage.rotate(angle: 90)
    }

    func rotate(angle: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(.init(width: size.width, height: size.height), false, 0)

        guard let context: CGContext = UIGraphicsGetCurrentContext(), let cgImage = cgImage else { return nil }
        context.translateBy(x: size.width / 2, y: size.height / 2)
        context.scaleBy(x: 1.0, y: -1.0)

        let radian: CGFloat = (-angle) * CGFloat.pi / 180.0

        context.rotate(by: radian)
        context.draw(cgImage, in: .init(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))

        guard let rotatedImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return rotatedImage
    }
}
