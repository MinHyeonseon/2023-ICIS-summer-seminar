function R = par_R(x, y)
    inv_Rp = 1 / x + 1 / y;
    R = 1 / inv_Rp;
end