## PlantNet Sucre

An application that implements a [YoloV8](https://github.com/ultralytics/ultralytics "YoloV8") `Computer Vision` model for the segmentation of static and real time images of medicinal plants in the city of Sucre, Bolivia.

##### Functionality

- Identify and segment medicinal plants with your device's camera or by uploading images from the gallery.
- Obtain valuable information about the detected plants, such as their scientific name, properties, medicinal uses and how they are prepared.
- Search for medicinal plants to treat specific ailments by entering the name of the ailment and activating the camera to search for the plant in real time.
- It uses `Yolov8`, a state-of-the-art model for image segmentation, which allows you to recognize medicinal plants.
  
<img align="left" width=270px height=600px alt="side_sticker" src="https://i.ibb.co/QXGh10n/Screenshot-20231129-145608.jpg" />
<img align="center" width=270px height=600px alt="side_sticker" src="https://i.ibb.co/VxCnFq2/Screenshot-20231129-145616.jpg" />
<img align="rigth" width=270px height=600px alt="side_sticker" src="https://i.ibb.co/f0w9kt9/Screenshot-20231129-145628.jpg" />

##### Model YoloV8l-seg
- The YoloV8l-seg model, a variant of YoloV8 specialized in image segmentation, was used.
- The model was fine tuned with more than 85000 images of 7 classes of medicinal plants from Sucre, Bolivia.
- The model was validated with an independent data set, obtaining an average accuracy of 85%.
- The model was tested with static and real time images, demonstrating its ability to identify and segment medicinal plants.

#### Dataset
[Medicinal Plants](https://www.kaggle.com/datasets/rodrigocolque/medicinal-plants-15 "Medicinal Plants") Data in kaggle with 85000 images, YoloV8 format, to consume using its API KEY for subsequent download with the command.
`kaggle datasets download -d rodrigocolque/medicinal-plants-15`

Dataset set in Roboflow [medicinal plants](https://universe.roboflow.com/segmentacion-iwaek/medicinal_plants "medicinal plants") has 7 classes, each class with more than 1500 segmented images. 

###### Consultation with Ultralitycs for YoloV8 integration and Futter instance segmentation [issue #6890](https://github.com/ultralytics/ultralytics/issues/6890?notification_referrer_id=NT_kwDOApDDWLM4NzA4OTc0Nzk5OjQzMDQxNjI0 "issue #6890")

