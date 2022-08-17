# quad_manifold

This repository contains the source code for the numerical models of Section 2 of the preprint [_Operator inference for non-intrusive model reduction with quadratic manifolds_](arXiv:2205.02304) ([arXiv:2205.02304](https://doi.org/10.48550/arXiv.2205.02304)) by Rudy Geelen, Stephen Wright and Karen Willcox.

## Abstract

This paper proposes a novel approach for learning a data-driven quadratic manifold from high-dimensional data, then employing this quadratic manifold to derive efficient physics-based reduced-order models. The key ingredient of the approach is a polynomial mapping between high-dimensional states and a low-dimensional embedding. This mapping consists of two parts: a representation in a linear subspace (computed in this work using the proper orthogonal decomposition) and a quadratic component. The approach can be viewed as a form of data-driven closure modeling, since the quadratic component introduces directions into the approximation that lie in the orthogonal complement of the linear subspace, but without introducing any additional degrees of freedom to the low-dimensional representation. Combining the quadratic manifold approximation with the operator inference method for projection-based model reduction leads to a scalable non-intrusive approach for learning reduced-order models of dynamical systems. Applying the new approach to transport-dominated systems of partial differential equations illustrates the gains in efficiency that can be achieved over approximation in a linear subspace.

## Summary
Our starting point is the linear-quadratic approximation 

$$\mathbf{s}_j = \mathbf{s}_re + \mathbf{V} \widehat{\mathbf{s}}_j + \overline{\mathbf{V}}(\widehat{\mathbf{s}}_j \otimes \widehat{\mathbf{s}}_j)$$

$$f(x) = x^2 - x^\frac{1}{\pi}$$

$$\max(S) = \max_{i:S_i \in S} S_i$$

## Citation

If you find this repository useful, please consider citing our paper:
```
@article{geelen2022quad_manifolds,
  author = {Geelen, Rudy and Wright, Stephen and Willcox, Karen},
  title = {Operator inference for non-intrusive model reduction with quadratic manifolds},
  journal = {arXiv preprint arXiv:2205.02304},
  year = {2022},
}
```

---
These codes was developed and tested in MATLAB R2020a. Please contact Rudy Geelen (rudy.geelen@austin.utexas.edu) when you have any questions or encounter issues. Stephen Wright contributed to the development of these codes.
