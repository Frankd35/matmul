# import numpy as np

mat1 = [[ r*16 + c for c in range(16)] for r in range(16)]
print(mat1)

mat2 = [[ 255-(r*16 + c) for c in range(16)] for r in range(16)]
print(mat2)


def matrix_multiplication(A, B):
    nrows, ncols = len(A), len(B[0])
    result = [[0] * ncols for _ in range(nrows)]

    for i in range(nrows):
        for j in range(ncols):
            for k in range(len(B)):
                result[i][j] += A[i][k] * B[k][j]

    return result

my_list = matrix_multiplication(mat1,mat2)

# for i in range(0, len(my_list), 16):  
#     row = my_list[i:i+16]  
#     print(' '.join(['{:04x}'.format(item) for item in row]))

print(my_list)


for r in range(16):
    for c in range(16):
        print("%s" % '{:x}'.format(my_list[r][c]), end=' ')
    print()