#import "template.typ" as template

#show: body => template.title-page(
  authors: "Group Geschke — Louis Tank, Kevin Karle and Marius Niveri",
  title: [Convolutional Layers, Max Pooling, VGG16, ResNet (Residuals, Skip Connections)],
  subtitle: [
    Project "Deep Learning for Audio Processing"\
    by
    #link("mailto: jakob.kienegger@uni-hamburg.de>")[Jakob Kienegger]
    and
    #link("mailto: martin.jaelmby@uni-hamburg.de")[Martin Jälmby]\
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
#set page(header: template.page-header("Convolutional Layers"))
- Architecture
#align(center, image("assets/CNNArchitecture.png"))

#pagebreak()
Convolutional layer
- Filter size F: Dimensions of the filter
- Stride S: The number of pixels by which the input window will move after each operation

#pagebreak()
Zero padding:
- adding P zeroes to each side of the boundaries input
#align(center, image("assets/ZeroPadding.png"))


#pagebreak()
- Convolution Operation
#align(center, image("assets/CONVformal.png", height: 50%))
- Sum of all element-wise multiplications

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
- Works with different dimensionalities
#align(center, image("assets/ConvRGB.png", height: 70%))

#pagebreak()
#set page(header: template.page-header("Max Pooling"))
- Operation done after convolution and activation
- Maximum output within rectangular neighborhood
  - Parameters: Size of window and stride
- Introduces invariance to small translations
#align(left, image("assets/MaxPooling2x2Stride2.png"))

#pagebreak()

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
  - aka. "Degredation Problem"
#figure(
  image("assets/training_loss_graph.svg", height: 60%),
  caption: [Training difficulty increases],
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
- Proposed Solution: _"Residual Block"_
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

- 18-layer and 34-layer VGG-inspired "plain" networks
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
  caption: [ImageNet Benchmark Results @DeepResidualLearning],
)
- $mono("18-plain")$ had better training accuracy than $mono("34-plain")$ confirming "Degredation Problem" \
  #sym.arrow.r.double This is not overfitting!
- $mono("18-ResNet")$ performed similar to $mono("18-plain")$
- $mono("34-ResNet")$ outperformed all other benchmark models \
  #sym.arrow.r.double "Residual Blocks" solve degredation Problem

#pagebreak()
#set page(header: template.page-header("Residual Networks: Summary"))
- Introduced "Identity Mapping" aka. "Residual Blocks"
- Tackle the Degredation Problem \
  #sym.arrow.r.double Allow deeper networks
- They don't solve overfitting \
  #sym.arrow.r.double Datasets still need to be large enough for network depth
- Generic Building block easily integrated into other architectures \
  #sym.arrow.r.double Combine with CNN, RNN, Transformers (ChatGPT), etc..
