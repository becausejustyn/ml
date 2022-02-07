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

## Example

Example: The local shop sells 3 types of pies.
- Apple pies cost $3 each
- Cherry pies cost $4 each
- Blueberry pies cost $2 each

And this is how many they sold in 4 days:

<center>

|           | Mon | Tue | Wed | Thurs |
|-----------|-----|-----|-----|-------|
| Apple     | 13  | 9   | 7   | 15    |
| Cherry    | 8   | 7   | 4   | 6     |
| Blueberry | 6   | 4   | 0   | 3     |

</center>

Now think about this ... the value of sales for Monday is calculated this way:
- Apple pie value + Cherry pie value + Blueberry pie value
- `$`3×13 + `$`4×8 + `$`2×6 = `$`83

So it is, in fact, the `dot product` of prices and how many were sold:

`($3, $4, $2) • (13, 8, 6) = $3×13 + $4×8 + $2×6 = $83`

We match the price to how many sold, multiply each, then sum the result.

In other words:
- `The sales for Monday were: Apple pies: $3×13=$39, Cherry pies: $4×8=$32, and Blueberry pies: $2×6=$12. Together that is $39 + $32 + $12 = $83`
- `And for Tuesday: $3×9 + $4×7 + $2×4 = $63`
- `And for Wednesday: $3×7 + $4×4 + $2×0 = $37`
- `And for Thursday: $3×15 + $4×6 + $2×3 = $75`
- So it is important to match each price to each quantity.

Now you know why we use the `dot product`.

And here is the full result in Matrix form:

$$
\begin{bmatrix}
\$3 & \$4 & \$2
\end{bmatrix}
\times
\begin{bmatrix}
13 & 9 & 7 & 15 \\ 
8 & 7 & 4 & 6 \\ 
6 & 4 & 0 & 3
\end{bmatrix}
= 
\begin{bmatrix}
\$83 & \$63 & \$37 & \$75
\end{bmatrix}
$$

|                  |                     
|------------------|
| $ \$3 \times 13 + \$4 \times 8 + \$2 \times 6 = \$83 $ | 
| $ \$3 \times 9 + \$4 \times 7 + \$2 \times 4 = \$63 $ | 
| $ \$3 \times 7 + \$4 \times 4 + \$2 \times 0 = \$37 $ | 
| $ \$3 \times 15 + \$4 \times 6 + \$2 \times 3 = \$75 $ | 

They sold $\$83$ worth of pies on Monday, $\$63$ on Tuesday, etc.

## Multiplication 

When we do multiplication:
- The number of columns of the 1st matrix must equal the number of rows of the 2nd matrix.
- And the result will have the same number of rows as the 1st matrix, and the same number of columns as the 2nd matrix.

In the example we multiplied a $1 \times 3$ matrix by a $3 \times 4$ matrix (note the $3s$ are the same), and the result was a $1 \times 4$ matrix.


>This is a warning

