import matplotlib.pyplot as plt
from matplotlib.patches import FancyArrowPatch
import numpy as np
import os

# 1. Setup Directory
output_dir = "assets"
os.makedirs(output_dir, exist_ok=True)
output_path = os.path.join(output_dir, "training_loss_graph.svg")

fig, ax = plt.subplots(figsize=(10, 5))

# 2. Generate Data
x = np.linspace(0, 10, 300)

# Red Curve (Shallow Network)
y_shallow = 0.6 * np.exp(-2 * x) + 0.35

# Blue Curve (Deep Network)
y_deep = 1.0 / (1 + np.exp(1.2 * (x - 4.5)))

# 3. Plot Curves
# Using standard colors, but keeping them distinct (Red/Blue)
ax.plot(x, y_shallow, color="#d62728", linewidth=4.0, label="Shallow Network")
ax.plot(x, y_deep, color="#1f77b4", linewidth=4.0, label="Deep Network")

# 4. Add Text Labels (Annotation style)
# Using ax.text for clean placement near the lines
ax.text(7.5, 0.42, "shallow\nnetwork", color="#d62728", fontsize=16, fontweight="bold")
ax.text(8.2, 0.05, "deep\nnetwork", color="#1f77b4", fontsize=16, fontweight="bold")

# 5. Customize Axes to look like the diagram (L-shape with arrows)
ax.set_xticks([])
ax.set_yticks([])

# Remove the standard box frame
ax.spines["top"].set_visible(False)
ax.spines["right"].set_visible(False)
ax.spines["bottom"].set_visible(False)
ax.spines["left"].set_visible(False)

# Set limits
ax.set_ylim(0, 1.1)
ax.set_xlim(0, 11)

# Draw clean geometric arrows for axes
# X-axis
ax.add_patch(
    FancyArrowPatch(
        posA=(0, 0),
        posB=(10.8, 0),
        arrowstyle="-|>",
        mutation_scale=18,
        linewidth=3.0,
        color="black",
        clip_on=False,
    )
)

# Y-axis
ax.add_patch(
    FancyArrowPatch(
        posA=(0, 0),
        posB=(0, 1.05),
        arrowstyle="-|>",
        mutation_scale=18,
        linewidth=3.0,
        color="black",
        clip_on=False,
    )
)

# 6. Add Axis Labels
ax.text(10.5, -0.08, "epochs", fontsize=18, fontweight="bold", ha="center")
ax.text(-1.0, 1.0, "loss", fontsize=18, fontweight="bold", va="center")

# 7. Save the file
plt.savefig(output_path, format="svg", bbox_inches="tight")
plt.close()

print(f"Graph saved successfully to: {output_path}")
