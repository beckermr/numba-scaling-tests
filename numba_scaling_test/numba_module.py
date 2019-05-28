from numba import njit


@njit
def add_a_lot(tot, a, b, c, d, e, f, g):
    """dummy function to compile a bunch of stuff in numba"""
    ny = tot.shape[0]
    nx = tot.shape[1]

    for i in range(ny):
        for j in range(nx):
            tot[i, j] = tot[i, j] + a[i, j]

    for i in range(ny):
        for j in range(nx):
            tot[i, j] = tot[i, j] + 2*b[i, j]

    for i in range(ny):
        for j in range(nx):
            tot[i, j] = tot[i, j] + c[j, i]

    for i in range(ny):
        for j in range(nx):
            tot[i, j] = tot[i, j] + d[i, j]

    for i in range(ny):
        for j in range(nx):
            tot[i, j] = tot[i, j] - e[i, j]

    for i in range(ny):
        for j in range(nx):
            tot[i, j] = tot[i, j] - 2*f[i, j]

    for i in range(ny):
        for j in range(nx):
            tot[i, j] = tot[i, j] + g[i, j]

    return tot


def mult_a_lot(tot, a, b, c, d, e, f, g):
    """dummy function to compile a bunch of stuff in numba"""
    ny = tot.shape[0]
    nx = tot.shape[1]

    for i in range(ny):
        for j in range(nx):
            tot[i, j] = tot[i, j] * a[i, j]

    for i in range(ny):
        for j in range(nx):
            tot[i, j] = tot[i, j] * 2*b[i, j]

    for i in range(ny):
        for j in range(nx):
            tot[i, j] = tot[i, j] * c[j, i]

    for i in range(ny):
        for j in range(nx):
            tot[i, j] = tot[i, j] * d[i, j]

    for i in range(ny):
        for j in range(nx):
            tot[i, j] = tot[i, j] * e[i, j]

    for i in range(ny):
        for j in range(nx):
            tot[i, j] = tot[i, j] * 2*f[i, j]

    for i in range(ny):
        for j in range(nx):
            tot[i, j] = tot[i, j] * g[i, j]

    return tot
