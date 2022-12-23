arr  = ['a', 'b', 'c', 'd']

for idx in 0..10 do 
  print "#{arr[idx % arr.length]}"
end