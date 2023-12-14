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
<table>
<thead>
<tr>
<th>Model</th>
<th>size<br><sup>(pixels)</sup></th>
<th>mAP<sup>val<br>50-95</sup></th>
<th>Speed<br><sup>CPU ONNX<br>(ms)</sup></th>
<th>Speed<br><sup>A100 TensorRT<br>(ms)</sup></th>
<th>params<br><sup>(M)</sup></th>
<th>FLOPs<br><sup>(B)</sup></th>
</tr>
</thead>
<tbody>
<tr>
<td><a href="https://github.com/ultralytics/assets/releases/download/v0.0.0/yolov8n.pt">YOLOv8n</a></td>
<td>640</td>
<td>37.3</td>
<td>80.4</td>
<td>0.99</td>
<td>3.2</td>
<td>8.7</td>
</tr>
<tr>
<td><a href="https://github.com/ultralytics/assets/releases/download/v0.0.0/yolov8s.pt">YOLOv8s</a></td>
<td>640</td>
<td>44.9</td>
<td>128.4</td>
<td>1.20</td>
<td>11.2</td>
<td>28.6</td>
</tr>
<tr>
<td><a href="https://github.com/ultralytics/assets/releases/download/v0.0.0/yolov8m.pt">YOLOv8m</a></td>
<td>640</td>
<td>50.2</td>
<td>234.7</td>
<td>1.83</td>
<td>25.9</td>
<td>78.9</td>
</tr>
<tr>
<td><a href="https://github.com/ultralytics/assets/releases/download/v0.0.0/yolov8l.pt">YOLOv8l</a></td>
<td>640</td>
<td>52.9</td>
<td>375.2</td>
<td>2.39</td>
<td>43.7</td>
<td>165.2</td>
</tr>
<tr>
<td><a href="https://github.com/ultralytics/assets/releases/download/v0.0.0/yolov8x.pt">YOLOv8x</a></td>
<td>640</td>
<td>53.9</td>
<td>479.1</td>
<td>3.53</td>
<td>68.2</td>
<td>257.8</td>
</tr>
</tbody>
</table>

- The YoloV8l-seg model, a variant of YoloV8 specialized in image segmentation, was used.
- The model was fine tuned with more than 85000 images of 7 classes of medicinal plants from Sucre, Bolivia.
- The model was validated with an independent data set, obtaining an average accuracy of 85%.
- The model was tested with static and real time images, demonstrating its ability to identify and segment medicinal plants.

#### Results train Model

##### Results metrics
<img align="left" width=1000px height=400px alt="side_sticker" src="https://i.ibb.co/GtMBDFW/Screenshot-20231211-173646.png" />


##### Results
<img align="left" width=1000px height=250px alt="side_sticker" src="https://i.ibb.co/GFd8DGG/results.png" />


#### Confusion Matrix
<img align="left" width=500px height=450px alt="side_sticker" src="https://i.ibb.co/Y81bR61/confusion-matrix.png" />


#### Dataset
[Medicinal Plants](https://www.kaggle.com/datasets/rodrigocolque/medicinal-plants-15 "Medicinal Plants") Data in kaggle with 85000 images, YoloV8 format, to consume using its API KEY for subsequent download with the command.
`kaggle datasets download -d rodrigocolque/medicinal-plants-15`

Dataset set in Roboflow [medicinal plants](https://universe.roboflow.com/segmentacion-iwaek/medicinal_plants "medicinal plants") has 7 classes, each class with more than 1500 segmented images. 

###### Consultation with Ultralitycs for YoloV8 integration and Futter instance segmentation [issue #6890](https://github.com/ultralytics/ultralytics/issues/6890?notification_referrer_id=NT_kwDOApDDWLM4NzA4OTc0Nzk5OjQzMDQxNjI0 "issue #6890")


