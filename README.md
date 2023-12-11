## PlantNet Sucre

An application that implements a [YoloV8](https://github.com/ultralytics/ultralytics "YoloV8") `Computer Vision` model for the segmentation of static and real time images of medicinal plants in the city of Sucre, Bolivia.

##### Functionality

- Identify and segment medicinal plants with your device's camera or by uploading images from the gallery.
- Obtain valuable information about the detected plants, such as their scientific name, properties, medicinal uses and how they are prepared.
- Search for medicinal plants to treat specific ailments by entering the name of the ailment and activating the camera to search for the plant in real time.
- It uses `Yolov8`, a state-of-the-art model for image segmentation, which allows you to recognize medicinal plants.

![](https://i.ibb.co/QXGh10n/Screenshot-20231129-145608.jpg)
![](https://i.ibb.co/VxCnFq2/Screenshot-20231129-145616.jpg)
![](https://i.ibb.co/f0w9kt9/Screenshot-20231129-145628.jpg)


##### Model YoloV8l-seg
- The YoloV8l-seg model, a variant of YoloV8 specialized in image segmentation, was used.
- The model was fine tuned with more than 85000 images of 7 classes of medicinal plants from Sucre, Bolivia.
- The model was validated with an independent data set, obtaining an average accuracy of 85%.
- The model was tested with static and real time images, demonstrating its ability to identify and segment medicinal plants.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
