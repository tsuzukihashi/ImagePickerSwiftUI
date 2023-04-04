# ImagePickerSwiftUI
ImagePicker for SwiftUI

# Useage

set
```.swift
import ImagePickerSwiftUI
```

```.swift
   @State var selectedImage: UIImage?
   @State var showPicker: Bool = false
```

action
```.swift
  Button {
    showPicker.toggle()
  } label: {
    Text("Show Image Picker")
  }
```

show
```.swift
  .sheet(isPresented: $showPicker) {
    ImagePickerSwiftUI(
      selectedImage: $selectedImage,
      sourceType: .camera, // or .photoLibrary
      allowsEditing: true
    )
  }
```

Add Info.plist 
```
    <key>NSCameraUsageDescription</key>
    <string>I'll use it to take pictures.</string>
```

that's all
| .camera | .photoLibrary |
| -- | -- |
|![IMG_0625](https://user-images.githubusercontent.com/19743978/145671398-9d335ee9-5089-4583-a0ad-109f76af21fc.PNG) | ![Simulator Screen Shot - iPhone 13 - 2021-12-11 at 18 18 43](https://user-images.githubusercontent.com/19743978/145671384-23db300d-d9a8-48da-9d39-ac1bd1fe10ca.png) |

