# Motivation
- Thank you Louis
- There's another problem we have to talk about with deeper networks like VGGs for example
- As the depth increases, they get increasingly harder to train
- Visualized here
- The loss in a simple not-so-deep network decreases fast but it doesn't have as much potential as a deeper counterpart
- Sometimes the deeper network is never able to reach its potential and the loss doesn't even decrease much
- This phenomenon is commonly known as the degradation problem and is not caused by overfitting which as Lois mentioned is another but distinct problem with larger and deeper networks

> next slide

- The reason for this degradation problem is that as the data passes through the layers on the forward pass, it gets scrambled more and more
- It takes a lot of time for the deeper layers to get structured data from earlier layers that have anything to do with the structure of the input data
- The same applies to the gradient during back propagation
- So what do we do about this?

> next slide

- 10 years ago a group of researchers proposed a solution to the degradation problem they call "Residual Networks" or short "ResNets". ResNets are a class of neural networks that make use of "Residual Blocks".
- To remind ourselfs: The goal is to increase the mathemtical connection between the input data's structure and the network's output.
- Residual Blocks do this by partially mapping the identity (input to the first layer of the block) to the output of the block.
- This is also called Shortcut connection, since the data skips processing and is added to the output without transformation preserving its structure.
- The addition of identity and layer output is usually a simple vector addition
    - This requires that input and output have the same shape!
- Sometimes concatition is used but this severely increases parameter size and changes the output shape

> next slide

- Visualizing in prior example
- Shortcut connection in blue

> next slide

- But does this actually work? And how good is it?
- To test their theory about residual blocks solving the degradation problem, the authors constructed multiple networks with and without their modifications.
- We'll look at four models
- a medium and a large VGG-like "plain" network
- And the same networks but with 8 and 16 Residual Blocks respectively
- The networks were tested on multiple datasets on image classification tasks
- We'll look at the results from ImageNet but they were very similar across datasets

> next slide

- Here you can see the models but it's a bit small so maybe take a look at the PDF if you're interested

> next slide

- Okay, so onto the results
- Looking at the first column, we observe that the smaller plain network actually had better accuracy than the larger network.
- This applies to both training and validation accuracy. Overfitting is not the issue so we're dealing with the degradation problem.
- The medium ResNet performed very similar to the plain counterpart showing that adding Residual blocks does not decrease model performance
- Now with the larger networks it gets interesting.
- Contrary to the plain networks, the larger ResNet performed much better than the smaller one and degradation is not an issue
- This confirms the theory and shows that adding residual blocks helps mitigating this specific problem

> next slide

- So to summarize:
    - I introduced you to the degradation problem which arises as networks get deeper
    - Adding Residual Blocks is a method to tackle this problem
    - Overfitting is distinct and not solved by ResNets
    - Datasets need to be large enough for the depth of the network
    - Residual Blocks are great since they are easily integrated into other architectures and widely used today

> next slide

- Small code example if we have time
