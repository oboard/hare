///|
fn main {
  println("Welcome to MoonBit REPL v0.2.0")
  println("Type 'exit' to quit")
  let rl = @readline.new()
  let vm = @eval.MoonBitVM::new()
  fn next_with_input(accumulated_input : String, brace_counter : Int) {
    let prompt = if brace_counter > 0 { "| " } else { "> " }
    rl.question(prompt, fn(input : String) {
      if input == "exit" && brace_counter == 0 {
        rl.close()
        println("Goodbye!")
        return
      }
      let new_input = if accumulated_input == "" {
        input
      } else {
        accumulated_input + "\n" + input
      }
      let new_counter = count_unclosed_braces(new_input)
      if new_counter > 0 {
        // 还有未闭合的括号，继续输入
        next_with_input(new_input, new_counter)
      } else {
        // 括号已平衡，执行代码
        let result = (vm.eval(new_input) catch {
          err => {
            println(err)
            return
          }
        }).to_string()
        println(result)
        next_with_input("", 0)
      }
    })
  }

  next_with_input("", 0)
}

///|
// 计算字符串中未闭合的括号数量（包括大括号和小括号）
fn count_unclosed_braces(input : String) -> Int {
  let mut brace_counter = 0
  let mut paren_counter = 0
  for i = 0; i < input.length(); i = i + 1 {
    let char = input[i]
    if char == '{' {
      brace_counter = brace_counter + 1
    } else if char == '}' {
      brace_counter = brace_counter - 1
    } else if char == '(' {
      paren_counter = paren_counter + 1
    } else if char == ')' {
      paren_counter = paren_counter - 1
    }
  }
  // 返回未闭合的括号总数
  brace_counter + paren_counter
}
