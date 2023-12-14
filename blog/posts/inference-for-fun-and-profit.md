---
title: Inference for fun and profit
excerpt: Generative AI is all the rage, and for good reason, but actually implementing an inference pipeline has many challenges, not the least of which is getting and serving a model to our peers.
categories:
- hands-on
- blog
published_date: 2023-12-14 21:44:45.167379 +0000
layout: default.liquid
is_draft: false
---
Generative AI is all the rage, and for good reason, but actually implementing an 
inference pipeline has many challenges, not the least of which is getting and serving
a model to our peers.

Let's build a simple inference API in a Jupyter notebook to help get us started.

```python
import transformers
import fastapi

@app
def route("/"):
    print("Hello World")
```