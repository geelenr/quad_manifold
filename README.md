# quad_manifold

This repository contains the source code for the numerical models from Section 2 of the preprint *Operator inference for non-intrusive model reduction with quadratic manifolds* ([arXiv:2205.02304](https://doi.org/10.48550/arXiv.2205.02304)) by Rudy Geelen, Stephen Wright and Karen Willcox.

## Abstract

This paper proposes a novel approach for learning a data-driven quadratic manifold from high-dimensional data, then employing this quadratic manifold to derive efficient physics-based reduced-order models. The key ingredient of the approach is a polynomial mapping between high-dimensional states and a low-dimensional embedding. This mapping consists of two parts: a representation in a linear subspace (computed in this work using the proper orthogonal decomposition) and a quadratic component. The approach can be viewed as a form of data-driven closure modeling, since the quadratic component introduces directions into the approximation that lie in the orthogonal complement of the linear subspace, but without introducing any additional degrees of freedom to the low-dimensional representation. Combining the quadratic manifold approximation with the operator inference method for projection-based model reduction leads to a scalable non-intrusive approach for learning reduced-order models of dynamical systems. Applying the new approach to transport-dominated systems of partial differential equations illustrates the gains in efficiency that can be achieved over approximation in a linear subspace.

## Repository

Our starting point is the quadratic approximation 

$$ \mathbf{s}\_j \approx \mathbf{s}_\text{ref} + \mathbf{V} \widehat{\mathbf{s}}_j + \overline{\mathbf{V}}(\widehat{\mathbf{s}}_j \otimes \widehat{\mathbf{s}}_j),
$$

where $\mathbf{s}_j$ is the $j$-th high-dimensional state, $\widehat{\mathbf{s}}_j$ denotes its reduced state representation, $(\mathbf{V},\overline{\mathbf{V}})$ are the basis matrices representing the linear and quadratic components of the solution-manifold, and $\otimes$ denotes the Kronecker product. In the following it is assumed that $\mathbf{V}$ and $\widehat{\mathbf{s}}_j$ are computed using the well-known proper orthogonal decomposition (POD), and the operator $\overline{\mathbf{V}}$ is computed from the misfit of the linear dimensionality reduction with basis $\mathbf{V}$ as follows:

$$ 
\overline{\mathbf{V}} = \underset{\overline{\mathbf{V}}}{\operatorname{argmin}} \sum_{j=1}^k \left\| \left\| \mathbf{s}\_j - \mathbf{s}_\text{ref} - \mathbf{V} \widehat{\mathbf{s}}_j - \overline{\mathbf{V}} ( \widehat{\mathbf{s}}_j  \otimes \widehat{\mathbf{s}}_j ) \right\| \right\|_2^2 \in \mathbb{R}^{n \times r^2}
$$

The following set of codes can be used in the numerical treatment of this approximation:

- [`trajectory_3d.m`](./trajectory_3d.m) provides the basis for a simple implementation of the above approximation. It reproduces the numerical experiments from Section 2.4 and compares a conventional linear dimensionality reduction (using POD) with the proposed data-driven quadratic manifold approach. The following figures are generated when all columns are selected:
<figure>
  <p align="center">
    <img src="https://raw.githubusercontent.com/geelenr/quad_manifold/master/fig1.jpg" alt="" height=300/> 
    <img src="https://raw.githubusercontent.com/geelenr/quad_manifold/master/fig2.jpg" alt="" height=300/> 
  </p>
  <p align = "center">Comparison of the linear (left) and quadratic (right) manifold approaches for a three-dimensional trajectory.</p>
</figure>

- [`columns.m`](./columns.m) is an outer loop script that encloses the column selection problem. The column selection algorithm is generally speaking not applied for a single value of the regularization parameter $\lambda$ but rather a range of distinct values (in decreasing order). Note that the number of columns selected tends to increase as lambda is decreased. 

- [`column_selection.m`](./column_selection.m) considers a basic proximal-gradient algorithm for solving the sum of $\ell_2$ regularized problem, which is essentially the SpaRSA algorithm described by Wright and co-workers [here](https://doi.org/10.1109/TSP.2009.2016892). The sum of $\ell_2$ regularizer induces sparsity in a similar way to the $\ell_1$ norm of a vector, except that instead of producing element-wise sparsity, it induces sparsity by groups.

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
These codes were developed and tested in MATLAB R2020a. Please contact Rudy Geelen (rudy.geelen@austin.utexas.edu) if you have any questions or encounter issues. Stephen Wright contributed to the development of these codes.
