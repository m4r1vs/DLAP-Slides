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

#set page(header: template.page-header("Einführung"))

- TODO: this presentation while we cite a source @DeepResidualLearning
- Trying to do some sums $sum_2^4 = 4$
- This also works as a separate equation in math mode:jfe
$
sum_2^4 = 4
$
- and now we add another bullet point

#pagebreak()
#set page(header: template.page-header("Diving Deeper"))
- This is our next slide on the next page where we show python code:
```python
def a_function(paramter):
  print(parameter)
  # this seems to work even with code highlighting
  print("nice")
```
- Showing a graph:
#align(center, image("assets/Typical_cnn.png", height: 35%))

#pagebreak()
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
1*1 + 0*1 + 0*2 + 1*0 = 1 + 0 + 0 + 0 = 1
$

#pagebreak()
- Example: Filter size 2x2, Stride 1, valid zero padding
#align(center, image("assets/ExampleCONV2.png", height: 50%))
$
0*1 + 2*1 + 1*2 + 2*0 = 0 + 2 + 2 + 0 = 4
$

#pagebreak()
- Example: Filter size 2x2, Stride 1, valid zero padding
#align(center, image("assets/ExampleCONV3.png", height: 50%))
$
0*1 + 1*1 + 0*2 + 0*0 = 0 + 1 + 0 + 0 = 1
$

#pagebreak()
- Example: Filter size 2x2, Stride 1, valid zero padding
#align(center, image("assets/ExampleCONV4.png", height: 50%))
$
1*1 + 2*1 + 1*2 + 0*0 = 1 + 2 + 2 + 0 = 5
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
- CNN architecture designed at Oxford University in 2015
#align(center, image("assets/VGG16_arch(1).png", height: 70%))

#pagebreak()
#align(center, image("assets/VGG16_arch(2).png", height: 60%))
- Filter 3x3, stride 1
- Max Pooling 2x2, stride 2
- "Same" Zero-Padding -> preserved size

#pagebreak()
TODO

#pagebreak()
#set page(header: template.page-header("Residual Network"))
#align(center, image("assets/ResNetVSPlainNtw.png", height: 120%))

#pagebreak()
TODO

#pagebreak()
#set page(header: template.page-header("Summary"))
