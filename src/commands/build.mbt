///| Build-related commands module

///|
pub fn handle_new() -> Unit {
  println("moon new: Create a new MoonBit module (not implemented yet)")
}

///|
pub fn handle_build() -> Unit {
  println("moon build: Build the current package (not implemented yet)")
}

///|
pub fn handle_check() -> Unit {
  println("moon check: Check the current package (not implemented yet)")
}

///|
pub fn handle_run(args : ArrayView[String]) -> Unit {
  if args.length() == 0 {
    println("moon run: missing package or mbt file")
    return
  }
  let path = args[0]
  if (@fs.is_file(path) catch { _ => false }) {
    // 读取文件内容并执行
    let content = @fs.read_file_to_string(path) catch {
      err => {
        println("Error reading file: " + err.to_string())
        return
      }
    }
    let vm = @eval.MoonBitVM::new()
    vm.eval(content, top=true) |> ignore
    match vm.eval("main()") {
      Success(value, _) =>
        if vm.interpreter.current_pkg.find("main").is_empty() {
          println(value)
        }
      Error(err, _) => {
        let err_str = err.to_string()
        println(@chalk.chalk().color(@chalk.Red).render(err_str))
      }
    }
  } else {
    println("moon run: run package (not implemented yet)")
  }
}

///|
pub fn handle_test() -> Unit {
  println("moon test: Test the current package (not implemented yet)")
}

///|
pub fn handle_clean() -> Unit {
  println("moon clean: Remove the target directory (not implemented yet)")
}
