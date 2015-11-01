require "benchmark"
require "matrix"

def faster_matrix_multiply(a, b)
  raise "Dimensions don't match" unless a.columns.size == b.rows.size
  matrix = Matrix(typeof(a[0] * b[0])).new(a.rows.size, b.columns.size)
  pos = -1
  b_columns = b.columns
  a.rows.each do |a_row|
    b_columns.each do |b_column|
      matrix[pos += 1] = typeof(a[0] * b[0]).cast((0...a_row.size).inject(0) do |memo, i|
                           memo + a_row[i] * b_column[i]
      end)
    end
  end
  matrix
end

def main()
  r = Random.new
  a = Matrix.new(1000, 1000, 0.0)
  b = Matrix.new(1000, 1000, 0.0)

  (0..999).each do |i|
    (0..999).each do |j|
      a[i,j] = r.next_float
      b[i,j] = r.next_float
    end
  end

  c = a * b
  d = faster_matrix_multiply(a, b)
  raise "Not equal!" unless c == d

  puts "New:"
  puts Benchmark.measure { faster_matrix_multiply(a, b) }
  puts "Current:"
  puts Benchmark.measure { a * b }
end
  
main()
