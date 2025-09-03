///|
/// REPL functionality for MoonBit
///
/// This module contains the interactive REPL implementation

///|
/// Start the MoonBit REPL
pub fn start_repl() -> Unit {
  println("Welcome to Hare.mbt REPL \{@config.Version}")
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
        let result = match vm.eval(new_input) {
          Success(value, _) => value.to_string()
          Error(err, _) => {
            let err_str = err.to_string()
            @chalk.chalk().color(@chalk.Red).render(err_str)
          }
        }
        println(result)
        next_with_input("", 0)
      }
    })
  }

  next_with_input("", 0)
}

///|
/// 计算字符串中未闭合的括号数量（包括大括号和小括号）
///
/// 参数：
/// - `input`：要计算的字符串
///
/// 返回值：
/// - 未闭合的括号数量
fn count_unclosed_braces(input : String) -> Int {
  let mut brace_counter = 0
  let mut paren_counter = 0
  let mut bracket_counter = 0
  let mut in_string = false
  let mut escape_next = false
  for i = 0; i < input.length(); i = i + 1 {
    let char = input[i]
    if escape_next {
      escape_next = false
      continue
    }
    if char == '\\' {
      escape_next = true
      continue
    }
    if char == '"' {
      in_string = !in_string
      continue
    }
    if !in_string {
      match char {
        '{' => brace_counter = brace_counter + 1
        '}' => brace_counter = brace_counter - 1
        '(' => paren_counter = paren_counter + 1
        ')' => paren_counter = paren_counter - 1
        '[' => bracket_counter = bracket_counter + 1
        ']' => bracket_counter = bracket_counter - 1
        _ => ()
      }
    }
  }
  // 返回未闭合的括号总数
  brace_counter + paren_counter + bracket_counter
}
