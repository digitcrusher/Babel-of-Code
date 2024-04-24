require 'set'

def get_yes_no(prompt)
  print "#{prompt} (y/n) "
  case $stdin.readline.strip.downcase
    when 'y' then true
    when 'n' then false
    else get_yes_no prompt
  end
end

puts 'Welcome to The Miraculous Game of Zgadywanko!'

raise 'Too many arguments' if $*.length > 2
max_num = $*[0]&.to_i || 100
numc = $*[1]&.to_i || 1
raise 'The number of numbers must not be less than 1' if numc < 1
raise "The upper bound must not be less than #{numc}" if max_num < numc

while true
  puts 'Guess the ' + (numc == 1 ? 'number' : "#{numc} numbers") + " from 1 to #{max_num}."
  nums = Enumerator.produce { rand(1 .. max_num) }.lazy.uniq.take(numc).to_set

  while true
    begin
      print 'Your guess: '
      guess = Integer $stdin.readline.strip
    rescue ArgumentError
      retry
    end

    did_find_any = nums.delete?(guess)
    if nums.empty?
      puts "You've found the last number, congratulations!"
      break
    end
    puts "That's one of the numbers, good job!" if did_find_any

    lessc = nums.count { |x| x < guess }
    greaterc = nums.length - lessc
    print(did_find_any ? 'Still, too ' : 'Too ')
    print(lessc == 1 ? 'high' : "high for #{lessc}") if lessc > 0
    print ' and too ' if lessc > 0 and greaterc > 0
    print(greaterc == 1 ? 'low' : "low for #{greaterc}") if greaterc > 0
    puts '!'
  end

  break unless get_yes_no 'Do you want to play again?'
end

puts 'Thanks for playing, bye!'
