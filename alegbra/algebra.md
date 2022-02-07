# Algebra

## Vectors

A vector is collection of scalars, arranged as a row or column. Our convention will be that a vector will be a lower cased letter but written in a bold type. 

Examples of column vectors could be

$$
\mathbf a = \begin{bmatrix}
2 \\ -3 \\ 4
\end{bmatrix}
\mathbf b = \begin{bmatrix}
2 \\ 8 \\ 3 \\ 4 \\ 1 \\
\end{bmatrix}
$$

$$
\mathbf c = \begin{bmatrix}
8 \\ 10 \\ 43 \\ -22
\end{bmatrix}
$$

$$
\mathbf d = \begin{bmatrix}
-1 \\ 5 \\ 2
\end{bmatrix}
$$

To denote a specific entry in the vector, we will use a subscript. For example, the second element of $d$ is $d_{2} = 5$. Notice, that we do not bold this symbol because the second element of the vector is the scalar value $5$.

## Matrix

Just as a vector is a collection of scalars, a matrix can be viewed as a collection of vectors (all of the same length). We will denote matrices with bold capitalized letters. In general, I try to use letters at the end of the alphabet for matrices. Likewise, I try to use symmetric letters to denote symmetric matrices.

For example, the following is a matrix with two rows and three columns

$$
\mathbf W = \begin{bmatrix}
1 & 2 & 3 \\ 4 & 5 & 6
\end{bmatrix}
$$

and there is no requirement that the number of rows be equal, less than, or greater than the number of columns. In denoting the size of the matrix, we first refer to the number of rows and then the number of columns. Thus $\mathbf W$ is a $2 \times 3$ matrix and it sometimes is helpful to remind ourselves by writing $\mathbf W 2 \times 3$.

To pick out a particular element of a matrix, I will again use a subscripting notation, always with the row number first and then column. Notice the notational shift to lowercase, non-bold font.

$$w_{1, 2} = 2 \text{ and } w_{2, 3} = 6$$

There are times I will wish to refer to a particular row or column of a matrix and we will use the following notation

$$
\mathbf w_{1} = \begin{bmatrix}
1 \\ 2 \\ 3
\end{bmatrix}
$$

is the first row of the matrix $\mathbf W$. The second column of matrix $\mathbf W$ is 

$$\mathbf{w} \cdot , _{2} = \begin{bmatrix}
2 \\ 5  
\end{bmatrix}$$

## Operations on Matrices

### Transpose

The simplest operation on a square matrix matrix is called transpose. It is defined as $\mathbf{M} = \mathbf{W}^{T}$ if and only if $m_{i, j} = w_{j, i}$.

$$
\mathbf{Z} = \begin{bmatrix}
1 & 6 \\ 8 & 3
\end{bmatrix}
\mathbf{Z}^{T} = \begin{bmatrix}
1 & 8 \\ 6 & 3
\end{bmatrix}
$$

$$
\mathbf{M} = \begin{bmatrix}
3 & 1 & 2 \\ 9 & 4 & 5 \\ 8 & 7 & 6
\end{bmatrix}
\mathbf{M}^{T} = \begin{bmatrix}
3 & 9 & 8 \\ 1 & 4 & 7 \\ 2 & 5 & 6
\end{bmatrix}
$$

We can think of this as swapping all elements about the main diagonal. Alternatively we could think about the transpose as making the first row become the first column, the second row become the second column, etc. In this fashion we could define the transpose of a non-square matrix.

$$
\mathbf{W} = \begin{bmatrix}
1 & 2 & 3 \\ 4 & 5 & 6
\end{bmatrix}
$$

$$
\mathbf{W}^{T} = \begin{bmatrix}
1 & 4 \\ 2 & 5 \\ 3 & 6
\end{bmatrix}
$$

### Addition and Subtraction

Addition and subtraction are performed element-wise. This means that two matrices or vectors can only be added or subtracted if their dimensions match.

$$
\begin{bmatrix}
1 \\ 2 \\ 3 \\ 4 
\end{bmatrix}
+
\begin{bmatrix}
5 \\ 6 \\ 7 \\ 8 
\end{bmatrix}
=
\begin{bmatrix}
6 \\ 8 \\ 10 \\ 12 
\end{bmatrix}
$$


### Multiplication

Multiplication is the operation that is vastly different for matrices and vectors than it is for scalars. There is a great deal of mathematical theory that suggests a useful way to define multiplication. What is presented below is referred to as the dot-product of vectors in calculus, and is referred to as the standard inner-product in linear algebra.


### Vector Multiplication

We first define multiplication for a row and column vector. For this multiplication to be defined, both vectors must be the same length. The product is the sum of the element-wise multiplications.

$$
\begin{bmatrix}
1 & 2 & 3 & 4 
\end{bmatrix}
\begin{bmatrix}
5 \\ 6 \\ 7 \\ 8
\end{bmatrix}
=
(1 \cdot 5) + (2 \cdot 6) + (3 \cdot 7) + (4 \cdot 8) = 5 + 12 + 21 + 32 = 70
$$


### Matrix Multiplication

`https://bookdown.org/dereksonderegger/571/1-matrix-manipulation.html`

Matrix multiplication is just a sequence of vector multiplications. If $\mathbf{X}$ is a $m \times n$ matrix and $\mathbf{W}$ is $n \times p$ matrix then $\mathbf{Z} = \mathbf{XW}$ is a $m \times p$ matrix where $z_{i, j} = \mathbf{x}_{i} \cdot \mathbf{w} \cdot , _{j}$ where $\mathbf{x}_{i}$, is the ith column of $\mathbf{X}$ and $\mathbf{w} \cdot , _{j}$ is the $j$th column of $\mathbf{W}$. For example, let

$$
\mathbf{X} = \begin{bmatrix}
1 & 2 & 3 & 4 \\ 5 & 6 & 7 & 8 \\ 9 & 10 & 11 & 12
\end{bmatrix}
\mathbf{W} = \begin{bmatrix}
13 & 14 \\ 15 & 16 \\ 17 & 18 \\ 19 & 20
\end{bmatrix}
$$

so $\mathbf{X}$ is $3 \times 4$ (which we remind ourselves by adding a $3 \times 4$ suscript to  $\mathbf{X}$ as $\mathbf{X}_{3 \times 4}$) and $\mathbf{W}$ is $\mathbf{W}_{4 \times 2}$. Because the inner dimensions match for this multiplication, then $\mathbf{Z}_{3 \times 2} = \mathbf{X}_{3 \times 4} \mathbf{W}_{4 \times 2}$ is defined where

$$z_{1, 1} = \mathbf{x}_{1}, \cdot \mathbf{w} \cdot , _{1}$$

$$
= (1 \cdot 13) + (2 \cdot 15) + (3 \cdot 17) + (4 \cdot 19) = 170
$$

and similarly,

$$z_{2, 1} = \mathbf{x}_{2}, \cdot \mathbf{w} \cdot , _{1}$$

$$
= (5 \cdot 13) + (6 \cdot 15) + (7 \cdot 17) + (8 \cdot 19) = 426
$$

so that

$$
\mathbf{Z} = \begin{bmatrix}
170 & 180 \\ 426 & 452 \\ 682 & 724 
\end{bmatrix}
$$

### Inverse

In regular algebra, we are often interested in solving equations such as

$$
5x = 15
$$

for $x$. To do so, we multiply each side of the equation by the inverse of $5$, which is $\frac{1}{5}$.

$$
5x = 15 \\ 
\frac{1}{5} \cdot 5 \cdot x = \frac{1}{5} \cdot 15 \\
1 \cdot x = 3 \\
x = 3
$$

For scalars, we know that the inverse of scalar $a$ is the value that when multiplied by $a$ is 1. That is we see to find $a^{-1}$ such that $aa^{-1} = 1$.

In the matrix case, I am interested in finding $\mathbf{A}^{-1}$ such that $\mathbf{A}^{-1}\mathbf{A} = \mathbf{I}$ and $\mathbf{A}\mathbf{A}^{-1} = \mathbf{I}$ For both of these multiplications to be defined, $\mathbf{A}$ must be a square matrix and so the inverse is only defined for square matrices.
  
For a $2 \times 2$ matrix

$$
\mathbf{W} = \begin{bmatrix}a & b\\
c & d
\end{bmatrix}
$$

the inverse is given by

$$
\mathbf{W}^{-1} = \frac{1}{det \mathbf{W}} \begin{bmatrix}d & -b\\
-c & a
\end{bmatrix}
$$

For example, suppose

$$
\mathbf{W} = \begin{bmatrix}
1 & 2 \\
5 & 3
\end{bmatrix}
$$

then $det \mathbf{W} = 3 - 10 = -7$ and

$$
\mathbf{W}^{-1} = \frac{1}{-7} 
\begin{bmatrix}
3 & -2 \\
-5 & 1
\end{bmatrix}
$$

$$
=
\begin{bmatrix}
- \frac{3}{7}  & \frac{2}{7}  \\
\frac{5}{7}  & - \frac{1}{7} 
\end{bmatrix}
$$

and thus

$$
\mathbf{WW}^{-1} = \begin{bmatrix}
1 & 2 \\ 5 & 3
\end{bmatrix}
\begin{bmatrix}
-\frac{3}{7} & \frac{2}{7} \\
\frac{5}{7} & - \frac{1}{7}
\end{bmatrix}
$$

$$
=
\begin{bmatrix}
-\frac{3}{7} + \frac{10}{7} & \; \frac{2}{7} - \frac{2}{7} \\
- \frac{15}{7} + - \frac{15}{7} & \; \frac{10}{7} - - \frac{3}{7}
\end{bmatrix}
$$

$$
=
\begin{bmatrix}
1 & 0 \\
0 & 1
\end{bmatrix}
= \mathbf{I}_{2}
$$

Not every square matrix has an inverse. If the determinant of the matrix (which we think of as some measure of the magnitude or size of the matrix) is zero, then the formula would require us to divide by zero. Just as we cannot find the inverse of zero (i.e. solve $0x = 1$ for $x$), a matrix with zero determinate is said to have no inverse.

