///|
fn main {
  println("Welcome to MoonBit REPL v0.1.0")
  println("Type 'exit' to quit")
  let rl = @readline.new()
  let vm = @eval.MoonBitVM::new()
  fn next() {
    rl.question("> ", fn(input : String) {
      if input == "exit" {
        rl.close()
        println("Goodbye!")
        return
      }
      let result = vm.eval(input)
      println(result)
      next()
    })
  }

  next()
}
