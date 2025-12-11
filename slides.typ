#import "template.typ" as template

#show: body => template.title-page(
  authors: "Group Geschke — Louis Tank, Kevin Karle and Marius Niveri",
  title: [Convolutional Layers, Max Pooling, VGG16, ResNet (Residuals, Skip Connections)],
  subtitle: [
    Project "Deep Learning for Audio Processing"\
    by
    #link("mailto:jakob.kienegger@uni-hamburg.de")[Jakob Kienegger]
    and
    #link("mailto:martin.jaelmby@uni-hamburg.de")[Martin Jälmby]\
  ],
  faculty: "https://www.inf.uni-hamburg.de/en/inst/ab/sp/home.html",
  body,
)

#show figure.caption: set text(0.65em)

#set page(header: template.page-header("Outline"))
- Convolutional Layers
- Max Pooling
- VGG16
- ResNet (Residuals, Skip Connections)

#pagebreak()

#text("What is a convolution?", size: 34pt, weight: "bold")

- A filter applied to a matrix
  - 2D in the context of image processing

- Usecases: blurring, sharpening, edge detection, ...
  - Depends on values in so-called Kernel-matrix

- Convolutional Layer?
  - Find optimal Kernel values through machine learning

#pagebreak()
- Example: 2D Convolution on 3x3 matrix using 2x2 Kernel:
#v(50pt)
#align(center, image("assets/CONVformal.png", width: 80%))

#pagebreak()
Convolutional layer
- Filter size F: Dimensions of the filter
- Stride S: The number of pixels by which the input window will move after each operation

#pagebreak()
- Example: Filter size 2x2, Stride 1, valid zero padding
#align(center, image("assets/ExampleCONV1.png", height: 50%))
$
  1 dot 1 + 0 dot 1 + 0 dot 2 + 1 dot 0 = 1 + 0 + 0 + 0 = 1
$

#pagebreak()
- Example: Filter size 2x2, Stride 1, valid zero padding
#align(center, image("assets/ExampleCONV2.png", height: 50%))
$
  0 dot 1 + 2 dot 1 + 1 dot 2 + 2 dot 0 = 0 + 2 + 2 + 0 = 4
$

#pagebreak()
- Example: Filter size 2x2, Stride 1, valid zero padding
#align(center, image("assets/ExampleCONV3.png", height: 50%))
$
  0 dot 1 + 1 dot 1 + 0 dot 2 + 0 dot 0 = 0 + 1 + 0 + 0 = 1
$

#pagebreak()
- Example: Filter size 2x2, Stride 1, valid zero padding
#align(center, image("assets/ExampleCONV4.png", height: 50%))
$
  1 dot 1 + 2 dot 1 + 1 dot 2 + 0 dot 0 = 1 + 2 + 2 + 0 = 5
$

#pagebreak()
Zero padding:
- Adding P zeroes to each side of the boundaries input
#align(center, image("assets/ZeroPadding.png"))

#pagebreak()
- Works with different dimensionalities
#align(center, image("assets/ConvRGB.png", height: 70%))

#pagebreak()
#set page(header: template.page-header("Convolutional Layers"))
- Architecture
#align(center, image("assets/CNNArchitecture.png"))

#pagebreak()
#set page(header: template.page-header("Max Pooling"))
- Operation done after convolution and activation
- Maximum output within rectangular neighborhood
  - Parameters: Size of window and stride
- Introduces invariance to small translations
#align(left, image("assets/MaxPooling2x2Stride2.png"))

#pagebreak()
#set page(header: template.page-header("VGG-16"))
- designed at Oxford University in 2014
#figure(
  image("assets/VGG16_arch(1).png", height: 70%),
  caption: [Architecture of VGG-16 @VarshneyVGG16],
)

#pagebreak()
#figure(
  image("assets/VGG16_arch(2).png", height: 60%),
  caption: [Architecture of VGG-16 @VarshneyVGG16],
)
- Filter 3x3, stride 1, padding "Same"
- Max Pooling 2x2, stride 2


#pagebreak()
Advantages:
- Simple, easy to understand
- Easy to implement
- Good accuracy

Disadvantages:
- High memory consumption
- Slow
- Prone to overfitting

#pagebreak()
#set page(header: template.page-header("Residual Networks: Motivation"))

- *Problem*: Training difficulty increases with depth of network
  - aka. "Degradation Problem"
#figure(
  image("assets/training_loss_graph.svg", height: 60%),
  caption: [Training difficulty increases @ResNetYTvideoIntro],
)

#pagebreak()

- Reason: Data gets "scrambled" a lot passing through the network.
  - So does gradient
#v(50pt)
#figure(
  image("assets/pre-resnet-example.svg", width: 100%),
  caption: [Deep Neural Network without Residual Block],
)

#pagebreak()
#set page(header: template.page-header("Residual Networks: Introduction"))

- 2015 Proposed Solution: _"Residual Block"_
  - Increase connection: *input* #sym.arrow.l.r *output*
#figure(
  image("assets/resnet-block.jpg", height: 50%),
  caption: [Partially Skipping layer(s) of network @DeepResidualLearning],
)

#pagebreak()

#v(20pt)
#figure(
  image("assets/post-resnet-example.svg", width: 100%),
  caption: [Deep Neural Network with Residual Block],
)

#pagebreak()
#set page(header: template.page-header("Residual Networks: Architectures"))
#text("ResNet Benchmark Architectures", size: 34pt, weight: "bold")

- 18-layer and 34-layer VGG-like "plain" networks
  - aka. $mono("18-plain")$ and $mono("34-plain")$
- Same networks but with residual blocks
  - aka. $mono("18-ResNet")$ and $mono("34-ResNet")$
- Tested i.a. with $mono("ImageNet")$ Dataset.

#pagebreak()

#figure(
  image("assets/resnet-architectures-with-plain.jpg", height: 100%),
  caption: [Benchmark Architectures @DeepResidualLearning],
)

#pagebreak()

#figure(
  image("assets/benchmark-comparison-resnet-vgg.jpg", width: 40%),
  caption: [ImageNet Benchmark Results (Top-1 Error %) @DeepResidualLearning],
)
- $mono("18-plain")$ had better training accuracy than $mono("34-plain")$ confirming "Degradation Problem" \
  #sym.arrow.r.double This is not overfitting!
- $mono("18-ResNet")$ performed similar to $mono("18-plain")$
- $mono("34-ResNet")$ outperformed all other benchmark models \
  #sym.arrow.r.double "Residual Blocks" solve degradation Problem

#pagebreak()
#set page(header: template.page-header("Residual Networks: Summary"))
- Introduced "Identity Mapping" aka. "Residual Blocks"
- Tackle the Degradation Problem \
  #sym.arrow.r.double Allow deeper networks
- They don't solve overfitting \
  #sym.arrow.r.double Datasets still need to be large enough for network depth
- Generic Building block easily integrated into other architectures \
  #sym.arrow.r.double Combine with CNN, RNN, Transformers, etc.. @AttentIsAllUNeed

#pagebreak()
#set page(header: template.page-header(
  "Residual Networks: Pytorch 2-layer Example",
))
#set text(size: 18pt)
```python

class ResidualBlock(nn.Module):
    def __init__(self, channels):
        super().__init__()
        self.conv1 = nn.Conv2d(channels, channels, kernel_size=3, padding=1)
        self.bn1 = nn.BatchNorm2d(channels)
        self.relu = nn.ReLU()
        self.conv2 = nn.Conv2d(channels, channels, kernel_size=3, padding=1)
        self.bn2 = nn.BatchNorm2d(channels)

    def forward(self, input):
        out = self.conv1(input)
        out = self.bn1(out)
        out = self.relu(out)
        out = self.conv2(out)
        out = self.bn2(out)
        out += input              # output = F(input, W) + input
        return self.relu(out)
```
