# Basic Stuff

## Dot Product

$$
a \cdot b = \sum_{i = 1}^{n} a_{i}b_{i}
$$

$a$ = $1st$ vector  
$b$ = $2nd$ vector  
$n$ = dimension of the vector space  
$a_{i}$ = component of vector $a$  
$b_{i}$ = component of vector $b$  

$$
\begin{bmatrix}
6 & 4 & 24 \\
1 & -9 & 8
\end{bmatrix}
$$

`\begin{pmatrix}` for brackets.

To show how many rows and columns a matrix has we often write `rows` $\times$ `columns`.

To multiply a matrix by a single number is easy:

$$
2 \times \begin{bmatrix} 4 & 0 \\ 1 & -9 \end{bmatrix} = \begin{bmatrix} 8 & 0 \\ 2 & -18 \end{bmatrix}
$$

These are the calculations:

<center>

|                  |                     |
|------------------|---------------------|
| $2 \times 4 = 8$ | $2 \times 0 = 0$    |
| $2 \times 1 = 2$ | $2 \times -9 = -18$ |

</center>

We call the number (`2` in this case) a *scalar*, so this is called `scalar multiplication`.

***

## Multiplying a Matrix by Another Matrix

But to multiply a matrix by another matrix we need to do the `dot product` of rows and columns.  

The `Dot Product` is where we multiply matching members, then sum up:

$$
\begin{bmatrix}
1 & 2 & 3 \\
4 & 5 & 6
\end{bmatrix}
\times 
\begin{bmatrix}
7 & 8 \\
9 & 10 \\
11 & 12
\end{bmatrix}
= \begin{bmatrix}
 &  \\
 & 
\end{bmatrix}
$$

<center>

|                  |                     
|------------------|
| $(1, 2, 3) \cdot (7, 9, 11) = 1 \times 7 + 2 \times 9 + 3 \times 11 = 58$ | 
| $(1, 2, 3) \cdot (8, 10, 12) = 1 \times 8 + 2 \times 10 + 3 \times 12 = 64$ | 
| $(4, 5, 6) \cdot (7, 9, 11) = 4 \times 7 + 5 \times 9 + 6 \times 11 = 139$ | 
| $(4, 5, 6) \cdot (8, 10, 12) = 4 \times 8 + 5 \times 10 + 6 \times 12 = 154$ | 

</center>

$$
\begin{bmatrix}
1 & 2 & 3 \\
4 & 5 & 6
\end{bmatrix}
\times 
\begin{bmatrix}
7 & 8 \\
9 & 10 \\
11 & 12
\end{bmatrix}
= \begin{bmatrix}
58 & 64 \\
139 & 154
\end{bmatrix}
$$

***