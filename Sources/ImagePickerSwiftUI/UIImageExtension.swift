import UIKit

public extension UIImage {
  func croppingToSquare() -> UIImage? {
    guard let cgImage = cgImage else { return nil }
    let resizeSize = min(cgImage.width, cgImage.height)
    return cropping(
      to: .init(
        x: (cgImage.width - resizeSize) / 2,
        y: (cgImage.height - resizeSize) / 2,
        width: resizeSize,
        height: resizeSize
      )
    )
  }

  func cropping(to rect: CGRect) -> UIImage? {
    let croppingRect: CGRect = imageOrientation.isLandscape ? rect.switched : rect
    guard let cgImage: CGImage = self.cgImage?.cropping(to: croppingRect) else { return nil }
    let cropped: UIImage = UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
    return cropped
  }
}

extension CGRect {
  var switched: CGRect {
    return CGRect(x: minY, y: minX, width: height, height: width)
  }
}

extension UIImage.Orientation {
  var isLandscape: Bool {
    switch self {
    case .up, .down, .upMirrored, .downMirrored:
      return false
    case .left, .right, .leftMirrored, .rightMirrored:
      return true
    @unknown default:
      fatalError()
    }
  }
}
