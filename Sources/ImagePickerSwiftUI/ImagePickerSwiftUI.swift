import SwiftUI

@available(iOS 13.0, *)
public struct ImagePickerSwiftUI: UIViewControllerRepresentable {
  @Environment(\.presentationMode) private var presentationMode
  @Binding var selectedImage: UIImage?

  var sourceType: UIImagePickerController.SourceType
  var allowsEditing: Bool
  var key: UIImagePickerController.InfoKey
  var croppingToSquare: Bool = false

  public init(
    selectedImage: Binding<UIImage?>,
    sourceType: UIImagePickerController.SourceType,
    allowsEditing: Bool,
    key: UIImagePickerController.InfoKey = .originalImage,
    croppingToSquare: Bool = false
  ) {
    self._selectedImage = selectedImage
    self.sourceType = sourceType
    self.allowsEditing = allowsEditing
    self.key = key
    self.croppingToSquare = croppingToSquare
  }

  public func makeUIViewController(context: Context) -> UIImagePickerController {
    let imagePicker = UIImagePickerController()
    imagePicker.allowsEditing = allowsEditing
    imagePicker.sourceType = sourceType
    imagePicker.delegate = context.coordinator

    return imagePicker
  }

  public func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {

  }

  public func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  final public class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var parent: ImagePickerSwiftUI

    init(_ parent: ImagePickerSwiftUI) {
      self.parent = parent
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

      if parent.allowsEditing {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
          parent.selectedImage = image
        }
      } else {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
          parent.selectedImage = parent.croppingToSquare ? image.croppingToSquare() : image
        }
      }

      parent.presentationMode.wrappedValue.dismiss()
    }
  }
}
