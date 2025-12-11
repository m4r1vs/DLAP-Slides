# DLAP-Slides

## Build Slides PDF

```sh
# Either use nix
nix build .#slides

# Or manually:
python ./training_loss_graph.py
typst compile ./slides.typ -f pdf
```

## Show animation

1. Activate python environment and install packages if not using direnv:
```sh
python -m venv .env
source ./.env/bin/activate # or DOS binary on Windows
pip install -U pip
pip install -e .
```

2. Run animation:
```sh
manimgl ./animation/convolution.py Main
```
