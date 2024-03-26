const std = @import("std");

const input = std.io.getStdIn().reader();
const output = std.io.getStdOut().writer();

fn getYesNo(prompt: []const u8) !bool {
  var buf: [256]u8 = undefined;
  while(true) {
    try output.print("{s} (y/n) ", .{prompt});
    const read = input.readUntilDelimiter(&buf, '\n');
    if(read == error.StreamTooLong) {
      try input.skipUntilDelimiterOrEof('\n');
      continue;
    }
    const ans = std.mem.trim(u8, try read, &std.ascii.whitespace);

    if(std.ascii.eqlIgnoreCase(ans, "y")) {
      return true;
    } else if(std.ascii.eqlIgnoreCase(ans, "n")) {
      return false;
    }
  }
}

pub fn main() !void {
  try output.writeAll("Welcome to The Miraculous Game of Zgadywanko!\n");

  if(std.os.argv.len > 3) {
    return error.TooManyArguments;
  }
  const maxNum = if(1 < std.os.argv.len) try std.fmt.parseInt(u128, std.mem.span(std.os.argv[1]), 10) else 100;
  const numc = if(2 < std.os.argv.len) try std.fmt.parseInt(usize, std.mem.span(std.os.argv[2]), 10) else 1;
  if(numc < 1) {
    return error.NumcTooLow;
  }
  if(maxNum < numc) {
    return error.MaxNumTooLow;
  }

  var gpa = std.heap.GeneralPurposeAllocator(.{}){};
  var nums = std.array_hash_map.AutoArrayHashMap(@TypeOf(maxNum), void).init(gpa.allocator());
  defer nums.deinit();
  var rng = std.rand.DefaultPrng.init(@intCast(std.time.nanoTimestamp()));

  while(true) {
    try output.writeAll("Guess the ");
    if(numc == 1) {
      try output.writeAll("number");
    } else {
      try output.print("{d} numbers", .{numc});
    }
    try output.print(" from 1 to {d}.\n", .{maxNum});

    nums.clearRetainingCapacity();
    while(nums.count() < numc) {
      try nums.put(rng.random().intRangeAtMost(@TypeOf(maxNum), 1, maxNum), {});
    }

    while(true) {
      try output.writeAll("Your guess: ");
      var buf: [256]u8 = undefined;
      const read = input.readUntilDelimiter(&buf, '\n');
      if(read == error.StreamTooLong) {
        try input.skipUntilDelimiterOrEof('\n');
        continue;
      }
      const guess = std.fmt.parseInt(@TypeOf(maxNum), std.mem.trim(u8, try read, &std.ascii.whitespace), 10) catch continue;

      const didFindAny = nums.swapRemove(guess);
      if(nums.count() <= 0) {
        try output.writeAll("You've found the last number, congratulations!\n");
        break;
      } else if(didFindAny) {
        try output.writeAll("That's one of the numbers, good job!\n");
      }

      var lessc: usize = 0;
      var greaterc: usize = 0;
      for(nums.keys()) |num| {
        if(num < guess) {
          lessc += 1;
        } else {
          greaterc += 1;
        }
      }
      try output.writeAll(if(didFindAny) "Still, too " else "Too ");
      if(lessc == 1) {
        try output.writeAll("high");
      } else if(lessc > 0) {
        try output.print("high for {d}", .{lessc});
      }
      if(lessc > 0 and greaterc > 0) {
        try output.writeAll(" and too ");
      }
      if(greaterc == 1) {
        try output.writeAll("low");
      } else if(greaterc > 0) {
        try output.print("low for {d}", .{greaterc});
      }
      try output.writeAll("!\n");
    }

    if(!try getYesNo("Do you want to play again?")) break;
  }

  try output.writeAll("Thanks for playing, bye!\n");
}
