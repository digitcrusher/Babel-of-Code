function get_yes_no(prompt)
  while true do
    io.write(prompt, ' (y/n) ')
    local ans = string.lower(string.match(io.read(), '^%s*(.-)%s*$'))
    if ans == 'y' then
      return true
    elseif ans == 'n' then
      return false
    end
  end
end

io.write('Welcome to The Miraculous Game of Zgadywanko!\n')

assert(#arg <= 2, 'Too many arguments')
local max_num = tonumber(arg[1]) or 100
local numc = tonumber(arg[2]) or 1
assert(numc >= 1, 'The number of numbers must not be less than 1')
assert(max_num >= numc, 'The upper bound must not be less than ' .. numc)

math.randomseed(os.time())
repeat
  io.write('Guess the ', numc == 1 and 'number' or numc .. ' numbers', ' from 1 to ', max_num, '.\n')
  local nums = {}
  for _ = 1, numc do
    while true do
      local num = math.random(max_num)
      if nums[num] == nil then
        nums[num] = true
        break
      end
    end
  end

  while true do
    local guess
    repeat
      io.write('Your guess: ')
      guess = io.read('*num')
      io.read()
    until guess ~= nil

    local did_find_any = nums[guess]
    nums[guess] = nil
    if next(nums) == nil then
      io.write("You've found the last number, congratulations!\n")
      break
    elseif did_find_any then
      io.write("That's one of the numbers, good job!\n")
    end

    local lessc, greaterc = 0, 0
    for num, _ in pairs(nums) do
      if num < guess then
        lessc = lessc + 1
      else
        greaterc = greaterc + 1
      end
    end
    io.write(did_find_any and 'Still, too ' or 'Too ')
    if lessc > 0 then
      io.write(lessc == 1 and 'high' or 'high for ' .. lessc)
    end
    if lessc > 0 and greaterc > 0 then
      io.write(' and too ')
    end
    if greaterc > 0 then
      io.write(greaterc == 1 and 'low' or 'low for ' .. greaterc)
    end
    io.write('!\n')
  end

until not get_yes_no('Do you want to play again?')

io.write('Thanks for playing, bye!\n')
