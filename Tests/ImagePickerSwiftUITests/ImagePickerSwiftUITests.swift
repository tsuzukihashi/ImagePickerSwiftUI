import XCTest

@testable import ImagePickerSwiftUI

@available(iOS 13.0, *)
@available(tvOS 13.0, *)
@available(watchOS 6.0, *)
@available(OSX 10.15, *)
final class ImagePickerSwiftUITests: XCTestCase {
  var subject: ImagePickerSwiftUI!
  var selectedImage: UIImage!
  
  override func setUp() {
    selectedImage = UIImage(systemName: "star")
    subject = .init(
      selectedImage: .constant(selectedImage),
      sourceType: .photoLibrary,
      allowsEditing: false
    )
  }
  
  func test_init() {
    XCTAssertEqual(subject.sourceType, .photoLibrary)
  }
}
