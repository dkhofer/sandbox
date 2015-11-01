require "benchmark"
require "complex"
require "matrix"

# Fibonacci
def fib(n)
  return n if n < 2

  return fib(n-1) + fib(n-2)
end

def qsort_kernel(a, lo, hi)
  i = lo
  j = hi
  while i < hi
    pivot = a[(lo+hi) / 2]
    while i < j
      while a[i] < pivot
        i += 1
      end
      while a[j] > pivot
        j -= 1
      end
      if i <= j
        a[i], a[j] = a[j], a[i]
        i += 1
        j -= 1
      end
    end

    if lo < j
      qsort_kernel(a, lo, j)
    end

    lo = i
    j = hi
  end

  return a
end

def mandel(z)
  maxiter = 80
  c = z
  (0..maxiter).each do |n|
    if z.abs > 2
      return n
    end
    z = z*z + c
  end

  return maxiter
end

def mandelperf
  mandel_sum = 0
  (-20..5).each do |re|
    (-10..10).each do |im|
      m = mandel(Complex.new(re.to_f / 10, im.to_f / 10))
      mandel_sum += m
    end
  end
  return mandel_sum
end

def pisum
  sum = 0.0
  (0..500).each do |i|
    sum = 0.0
    (1..10000).each do |k|
      sum += 1.0 / (k.to_f * k.to_f)
    end
  end

  return sum
end

def random_matrix(n)
  r = Random.new
  m = Matrix.new(n, n, 0.0)
  (0..n-1).each do |i|
    (0..n-1).each do |j|
      m[i,j] = r.next_float
    end
  end

  return m
end

def randmatstat(t)
  n = 5
  v = Array.new(t, 0.0)
  w = Array.new(t, 0.0)

  (0..t-1).each do |i|
    a = random_matrix(n)
    b = random_matrix(n)
    c = random_matrix(n)
    d = random_matrix(n)

    p = Matrix.new(n, 4*n, 0.0)
    (0..n-1).each do |j|
      (0..n-1).each do |k|
        p[j,k] = a[j,k]
        p[j,n+k] = b[j,k]
        p[j,2*n+k] = c[j,k]
        p[j,3*n+k] = d[j,k]
      end
    end

    q = Matrix.new(2*n, 2*n, 0.0)
    (0..n-1).each do |j|
      (0..n-1).each do |k|
        q[j,     k] = a[j,k]
        q[j,   n+k] = b[j,k]
        q[n+j,   k] = c[j,k]
        q[n+j, n+k] = d[j,k]
      end
    end

    p = p.transpose * p
    p = p * p
    p = p * p
    v[i] = typeof(0.0).cast(p.trace)

    q = q.transpose * q
    q = q * q
    q = q * q
    w[i] = typeof(0.0).cast(q.trace)
  end

  v1 = v.inject(&.+)
  v2 = v.inject { |entry, memo| memo + entry * entry }

  w1 = w.inject(&.+)
  w2 = w.inject { |entry, memo| memo + entry * entry }

  v_stat = Math.sqrt((t * (t*v2-v1*v1)) / ((t-1)*v1*v1))
  w_stat = Math.sqrt((t * (t*w2-w1*w1)) / ((t-1)*w1*w1))

  return [v_stat, w_stat]
end

def randmatmul(n)
  r = Random.new
  a = random_matrix(n)
  b = random_matrix(n)

  return a * b
end

def assert(b)
  raise "assert failed" unless b
end

def print_perf(name, time)
  puts "crystal,#{name},#{time * 1000}"
end

def main
  assert(fib(20) == 6765)

  t = Benchmark.measure { fib(20) }

  print_perf("fib", t.real)

  r = Random.new

  t = Benchmark.measure do
    1000.times do
      n = r.next_int
      s = "#{n}"
      m = s.to_i
      assert(m == n)
    end
  end

  print_perf("parse_int", t.real)

  assert(mandelperf() == 14791)
  t = Benchmark.measure { mandelperf() }
  print_perf("mandel", t.real)

  lst = (1..5000).map { r.next_float }
  t = Benchmark.measure { qsort_kernel(lst, 0, lst.size - 1) }
  print_perf("quicksort", t.real)

  assert((pisum()-1.644834071848065).abs < 1e-6)

  t = Benchmark.measure { pisum }
  print_perf("pi_sum", t.real)

  t = Benchmark.measure { randmatstat(1000) }
  print_perf("rand_mat_stat", t.real)

  t = Benchmark.measure { randmatmul(1000) }
  print_perf("rand_mat_mul", t.real)
end

main()
