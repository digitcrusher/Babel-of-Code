# Babel of Code

## My thoughts

*Lua-likes.* I only took a look at original languages that cleanly compile to Lua without dragging their own runtime or standard library along, and there are only two mainstream options fitting the description. [Fennel](https://fennel-lang.org/) is simply Lua with a Lisp syntax and not much of an ergonomic improvement over Lua… Unlike [YueScript](https://yuescript.org/) - a fork of the dormant MoonScript - which actually has features (eg. array comprehension) that make Lua easier to write in, although the syntax may be a bit too sugary in some places. Of course, those are not the only possibilties available to you since there do exist Lua transpilers for a plethora of other established programming languages, including but not limited to: C#, Idris, JavaScript, Oberon, Python, Ruby, Rust, Standard ML. For a full list go check out [this awesome repository](https://github.com/hengestone/lua-languages).

*JVM-based.* Java is Java, [Kotlin](https://kotlinlang.org/) is a better Java, and [Scala](https://scala-lang.org/) is an even better Java that combines FP, OOP and beautiful programming language design, which make the coding experience really sweet… If you're willing to put up with the seconds-long builds. *Don't worry, Scala. You're still my favorite.* Scala also tries to provide its own standard library in place of Java's, which makes it feel like a completely different language, but sadly there still are times where you can't escape the occasional Java goo. If you're getting overwhelmed by all those big words, then you should try Kotlin instead, which is a distillation of Scala. [Clojure](https://clojure.org/) is a Lisp for the JVM. [Groovy](http://groovy-lang.org/) is the real "Java-Script" and not much more sadly. Its documentation is also rather poor. There's also [Gosu](https://gosu-lang.github.io/) but there's even less concrete information about it than Groovy available on the Interwebs, it's not in [SDKMAN!](https://sdkman.io/), its latest binary release (from 2019) did not run on my computer and the sources failed to compile as well.

*Minimalistic.* That is minimalistic as C is minimalistic. [Zig](https://ziglang.org/) with its zero zero-cost abstraction policy appears to be a true replacement for venerable C and, if I ever had to write something in C, I would write it in Zig. [Go](https://go.dev/) is akin to hammering nails with a rubber hammer. Dropping most of the everyday syntax sugar and abandoning generics at the start in favor of dynamic typing are probably the main shortcomings. It's quite a controversial language and I, personally, don't like it, so I'll let the code speak for itself. [Odin](https://odin-lang.org/) is Go without automatic memory management, which makes it even worse than Go, but on the other hand it has builtin matrix math and implicit parameters.

*Lisps.* Lisp and its parentheses upon parentheses maybe be a bit intimidating to the seasoned programmer but fear not. This unified representation of code and data allows for one of the most powerful macro facilities in the world, which are so powerful in fact that they allow [Scheme](https://www.scheme.org/) to be built in Scheme just from a mere `lambda`, `if` and `set!`. Scheme makes the mainstream "minimalistic" languages look complicated or lacking in comparison. But Scheme is not the only Lisp. [Racket](https://racket-lang.org/) is Scheme with batteries included, which is nice but not really usable as an embeddable scripting language anymore. Some like Lisp's syntax so much that they port it to other platforms (see [Clojure](https://clojure.org/) for Java or [Fennel](https://fennel-lang.org/) for Lua). I glossed over [Common Lisp](https://lisp-lang.org/) since it looks to be the C++ of Lisps, ie. legacy and bloated.

Lisps: Dylan
functional: OCaml, Standard ML, Alice ML, Roc, Idris, Clean, ATS, Curry
logic: Prolog, Mercury, Gödel
array: APL, J, BQN, Octave, R
scripting: Raku, Ruby, Rexx, Tcl
Oz, Erlang, Dart, Elixir, Opa, Gleam
Fortran, Pascal, Ada, Eiffel, Sather
Smalltalks: Smalltalk, Self, Squeak
Objective C, Swift
JavaScripts: PureScript, Elm, CoffeeScript, Gren
C# platform: C#, F#, Visual Basic .NET
concurrent: Chapel, Occam
systems: Carbon, Crystal, D, Haxe, Julia, Lobster, Nim, Rust
minimalistic: Vale
embeddable: Wren, Gravity, AngelScript, Squirrel
SNOBOL, Snowball, Icon, Unicon
Rebol, Red, Boron
ParaSail
proof assistants: F*, Lean
bizarre: Factor, Forth, UCBLogo

Zgadywanko
- lazy collection operations
- error handling and throwing
- pipelined string operations
- command-line arguments
- interactive terminal I/O
- arbitrary-precision integers
- random number generation
- pattern matching/switch expressions
- ternary operator/if expressions
