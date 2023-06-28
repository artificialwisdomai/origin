# Verify python and pytorch work

import torch
import numpy as np

x = torch.rand(5, 3)
print(x)

if torch.backends.mps.is_available():
    mps_device = torch.device("mps")
    x = torch.ones(1, device=mps_device)
    print (x)
else:
    print ("MPS device not found.")
    print(f"Is CUDA Available: {torch.cuda.is_available()}")
