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