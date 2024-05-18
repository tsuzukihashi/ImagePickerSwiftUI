import SwiftUI
import PhotosUI

@available(iOS 14.0, *)
public struct PHPicker: UIViewControllerRepresentable {
  @Binding var isPresented: Bool
  @Binding var images: [UIImage]
  @Binding var videoURLs: [URL]

  var filter: PHPickerFilter?
  var selectionLimit: Int

  public init(
    filter: PHPickerFilter? = nil,
    selectionLimit: Int = 0,
    isPresented: Binding<Bool>,
    images: Binding<[UIImage]>,
    videoURLs: Binding<[URL]>
  ) {
    self.filter = filter
    self.selectionLimit = selectionLimit
    self._isPresented = isPresented
    self._images = images
    self._videoURLs = videoURLs
  }

  public func makeUIViewController(context: Context) -> PHPickerViewController {
    var configuration = PHPickerConfiguration()
    configuration.filter = filter
    configuration.selectionLimit = selectionLimit

    let picker = PHPickerViewController(configuration: configuration)
    picker.delegate = context.coordinator

    return picker
  }

  public func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
  }

  public func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  public class Coordinator: PHPickerViewControllerDelegate {
    private let parent: PHPicker

    public init(_ parent: PHPicker) {
      self.parent = parent
    }

    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
      Task {
        for result in results {
          do {
            if let image = try await loadImage(result: result) {
              parent.images.append(image)
            }
            if let videoURL = try await loadVideo(result: result) {
              parent.videoURLs.append(videoURL)
            }
          } catch {
            print(error.localizedDescription)
          }
        }

        parent.isPresented = false
      }
    }

    private func loadVideo(result: PHPickerResult) async throws -> URL? {
      try await withCheckedThrowingContinuation { continuation in
        let provider = result.itemProvider

        guard provider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) else {
          continuation.resume(returning: nil)
          return
        }

        provider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { fileURL, error in
          if let error {
            continuation.resume(throwing: error)
            return
          }
          guard let fileURL else {
            continuation.resume(returning: nil)
            return
          }

          let fileName = "\(Int(Date().timeIntervalSince1970)).\(fileURL.pathExtension)"
          let tmpUrl = URL(fileURLWithPath: NSTemporaryDirectory() + fileName)
          try? FileManager.default.copyItem(at: fileURL, to: tmpUrl)
          continuation.resume(returning: tmpUrl)
        }
      }
    }

    private func loadImage(result: PHPickerResult) async throws -> UIImage? {
      try await withCheckedThrowingContinuation { continuation in
        let provider = result.itemProvider

        guard provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) else  {
          continuation.resume(returning: nil)
          return
        }

        provider.loadObject(ofClass: UIImage.self) { image, error in
          if let error {
            continuation.resume(throwing: error)
            return
          }
          guard let image = image as? UIImage else {
            continuation.resume(returning: nil)
            return
          }
          continuation.resume(returning: image)
        }
      }
    }
  }
}
