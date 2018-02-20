class LinearSystem
  attr_accessor :a, :y

  def initialize(matrix, right_handside)
    @a = matrix
    @y = right_hand_side
  end

  # Given an equation system Ax = y
  # assumption A is N x N matrix, N=4
  # where x the unknown
  # and x, y are both N x 1 vectors.
  # Apply LU-Decomposition on A, then we
  # get [L,U] = lu(A), i.e.
  # A = LU
  # Thus, we can reformulate our system
  # as: (LU)x = y
  # which gives us a system of equation systems [SeS]:
  # 1. || Lc = y || Foreward subst
  # 2. || Ux = x || Backward subst
  # which allows us to solve for the vector x
  # Our goal: Compute A^-1 of our given A
  # by using this trick from above:
  # Let I denote the 4x4 identiy matrix
  # and [e1, e2, e3, e4] its column vectors
  # foreach e_k do
  #   set x = e_k and solve then [SeS]
  #   x is then k-th column of A-^1
  def solve
    e1 = Vector4f.new(1.0, 0.0, 0.0, 0.0)
    l_mat = get_l_matrix
    u_mat = get_u_matrix
    # foreward_substitution
    # backward_substitution
  end

  # get lu-decomposition matrices
  # Any matrix A can be decomposed into
  # A = P*L*U
  # [P,L,U] = lu(A)
  # where
  # P is a 4x4 permutation matrix
  # L is a 4x4 lower triangular matrix
  # U is a 4x4 upper triangular matrix
  def lu
    [get_p_matrix, get_l_matrix, get_u_matrix]
  end

  private

  def lu_decomp
    lu = s_copy
    piv = []

    (1..4).each do |idx|
      piv << idx
    end
    pivsign = 1;

    #double[]
    lu_row_i = [];

    # double[] new double[m];
    lu_col_j = []

    (1..4).each do |j|
      # Make a copy of the j-th column to localize references.
      # i-th element of j-th column of LU is ith index in array LUcolj
      lu_col_j = []
      (1..4).each do |i|
        lu_col_j << lu.at(i,j);
      end

      # Apply previous transformations.
      (1..4).each do |i|

        # LUrowi = LU[i];
        row_i_lu = lu.row(i)
        lu_row_i = []
        lu_row_i << row_i_lu.x
        lu_row_i << row_i_lu.y
        lu_row_i << row_i_lu.z
        lu_row_i << row_i_lu.w

        # Most of the time is spent in the following dot product.
        kmax = [i, j].min
        s = 0.0;
        (1..kmax).each do |k|
          s += lu_row_i[k-1] * lu_col_j[k-1];
        end
        lu_row_i[j-1] = lu_col_j[i-1] -= s;
      end

      # Find pivot and exchange if necessary.
      p = j
      ((j+1)..4).each do |i|
        p = i if(lu_col_j[i-1].abs > lu_col_j[p-1].abs)
      end
      # binding.pry
      if (p != j)
        (1..4).each do |k|
          t = lu.at(p,k)
          lu.setElementAt(p,k, lu.at(j,k))
          lu.setElementAt(j,k, t)
        end
        k = piv[p-1]
        piv[p-1] = piv[j-1]
        piv[j-1] = k
        pivsign = -pivsign
      end

      # Compute multipliers.
      if(j < 4 && lu.at(j,j) != 0.0)
        ((j+1)..4).each do |i|
          lu_ii = lu.at(j,j)
          lu_ij = lu.at(i,j)
          normalized_val = lu_ij.to_f / lu_ii.to_f
          lu.setElementAt(i, j, normalized_val)
        end
      end
    end
    [lu,piv]
  end

  # Lower triangular matrix L resulting by
  # lu decomposition: A = L*R
  def get_l_matrix
    l = Matrix4f.new(nil, nil, nil, nil)
    lu = lu_decomp[0]
    (1..4).each do |i|
      (1..4).each do |j|
        if (i > j)
          l.setElementAt(i, j, lu.at(i,j))
        elsif (i==j)
          l.setElementAt(i, j, 1.0)
        else
          l.setElementAt(i, j, 0.0)
        end
      end
    end
    l
  end

  # Upper triangular matrix U resulting by
  # lu decomposition: A = L*R
  def get_u_matrix
    u = Matrix4f.new(nil, nil, nil, nil)
    lu = lu_decomp[0]
    (1..4).each do |i|
      (1..4).each do |j|
        if (i <= j)
          u.setElementAt(i, j, lu.at(i,j))
        else
          u.setElementAt(i, j, 0.0)
        end
      end
    end
    u
  end

  def get_p_matrix
    rows = []
    lu_decomp_permutation_vec.each do |pidx|
      row = nil
      case pidx
      when 1
        row = Vector4f.new(1.0, 0.0, 0.0, 0.0)
      when 2
        row = Vector4f.new(0.0, 1.0, 0.0, 0.0)
      when 3
        row = Vector4f.new(0.0, 0.0, 1.0, 0.0)
      when 4
        row = Vector4f.new(0.0, 0.0, 0.0, 1.0)
      else
        puts "error, index greater than 4 or smaller than 1"
      end
      rows << row
    end
    Matrix4f.new(rows[0], rows[1], rows[2], rows[3])
  end

  def lu_decomp_permutation_vec
    piv = lu_decomp[1]
    p = []
    (1..4).each do |i|
      p << piv[i-1];
    end
    p
  end

  def foreward_substitution(b, l)
    y = Matrix4f.new(nil, nil, nil, nil)
    (1..4).each do |j|
      val = sb.at(1,j)l.to_f / l.at(1,1).to_f;
      y.set_at(1,j, val)
      (2..4).each do |i|
        sum = 0.0
        (1..(i-1)).each do |k|
          sum += l.at(i,k)*y.at(k,j)
        end
        val = (b.at(i,j) - sum).to_f/l.at(i,i)
        y.set_at(i,j, val)
      end
    end
    y
  end

  def backward_substitution(y,u)
    x = Matrix4f.new(nil, nil, nil, nil)
    (1..4).each do |j|
      val = y.at(4,j)l.to_f / u.at(4,4).to_f;
      x.set_at(4,j, val)
      (1..3).each do |p|
        i = (4-p)
        sum = 0.0
        ((i+1)..4).each do |k|
          sum += u.at(i,k)*x.at(k,j)
        end
        val = (y.at(i,j) - sum).to_f/u.at(i,i)
        x.set_at(i,j, val)
      end
    end
    x
  end
end
