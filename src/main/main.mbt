///| Import command modules

///|
/// Runtime environment enumeration
enum Runtime {
  JavaScript // JS runtime (Node.js, Bun, Deno, etc.)
  Native // Native executable
}

///|
/// Detect the runtime environment based on command line arguments
fn detect_runtime(all_args : Array[String]) -> Runtime {
  if all_args.length() > 1 &&
    all_args[1].length() >= 3 &&
    all_args[1].substring(start=all_args[1].length() - 3) == ".js" {
    JavaScript
  } else {
    Native
  }
}

///|
/// Parse command line arguments based on runtime environment
fn parse_args(all_args : Array[String]) -> Array[String] {
  match detect_runtime(all_args) {
    JavaScript =>
      // JS环境：跳过运行时和脚本路径
      if all_args.length() > 2 {
        all_args[2:].to_array()
      } else {
        []
      }
    Native =>
      // Native环境：跳过程序路径
      if all_args.length() > 1 {
        all_args[1:].to_array()
      } else {
        []
      }
  }
}

///|
/// The build system and package manager for MoonBit.
fn main {
  let all_args = @env.args()
  let args = parse_args(all_args)
  let parser = @clap.Parser::new(prog="moon", subcmds={
    // "new": @clap.SubCommand::new(help="Create a new MoonBit module"),
    // "build": @clap.SubCommand::new(help="Build the current package"),
    // "check": @clap.SubCommand::new(
    //   help="Check the current package, but don't build object files",
    // ),
    "run": @clap.SubCommand::new(help="Run a main package", args={
      "PACKAGE_OR_MBT_FILE": @clap.Arg::positional(
        nargs=@clap.One,
        help="The package or .mbt file to run",
      ),
    }),
    // "test": @clap.SubCommand::new(help="Test the current package"),
    // "clean": @clap.SubCommand::new(help="Remove the target directory"),
    // "fmt": @clap.SubCommand::new(help="Format source code"),
    // "doc": @clap.SubCommand::new(help="Generate documentation"),
    // "info": @clap.SubCommand::new(
    //   help="Generate public interface (`.mbti`) files for all packages in the module",
    // ),
    // "bench": @clap.SubCommand::new(help="Run benchmarks in the current package"),
    // "add": @clap.SubCommand::new(help="Add a dependency"),
    // "remove": @clap.SubCommand::new(help="Remove a dependency"),
    // "install": @clap.SubCommand::new(help="Install dependencies"),
    // "tree": @clap.SubCommand::new(help="Display the dependency tree"),
    // "login": @clap.SubCommand::new(help="Log in to your account"),
    // "register": @clap.SubCommand::new(
    //   help="Register an account at mooncakes.io",
    // ),
    // "publish": @clap.SubCommand::new(help="Publish the current module"),
    // "package": @clap.SubCommand::new(help="Package the current module"),
    // "update": @clap.SubCommand::new(help="Update the package registry index"),
    // "coverage": @clap.SubCommand::new(help="Code coverage utilities"),
    // "generate-build-matrix": @clap.SubCommand::new(
    //   help="Generate build matrix for benchmarking (legacy feature)",
    // ),
    // "upgrade": @clap.SubCommand::new(help="Upgrade toolchains"),
    // "shell-completion": @clap.SubCommand::new(
    //   help="Generate shell completion for bash/elvish/fish/pwsh/zsh to stdout",
    // ),
    "version": @clap.SubCommand::new(help="Print version information and exit"),
    "repl": @clap.SubCommand::new(help="Start the MoonBit REPL"),
  })
  let value = @clap.SimpleValue::new(parser.prog)
  let help_message = parser.parse(value, args) catch {
    e =>
      match e {
        // 让我们自己的逻辑处理无效命令
        InvalidSubCommandName(_) => {
          invalid_command(args[0])
          return
        }
        _ => {
          println(e)
          return
        }
      }
  }
  if help_message is Some(help) {
    println(help)
    return
  }

  // 检查是否有子命令
  if args.length() == 0 {
    // 没有子命令，默认进入 REPL
    start_repl(args)
    return
  }
  let subcmd = args[0]
  match subcmd {
    "new" => @commands.handle_new()
    "build" => @commands.handle_build()
    "check" => @commands.handle_check()
    "run" => @commands.handle_run(args)
    "test" => @commands.handle_test()
    "clean" => @commands.handle_clean()
    "fmt" => @commands.handle_fmt()
    "doc" => @commands.handle_doc()
    "info" => @commands.handle_info()
    "bench" => @commands.handle_bench()
    "add" => @commands.handle_add()
    "remove" => @commands.handle_remove()
    "install" => @commands.handle_install()
    "tree" => @commands.handle_tree()
    "login" => @commands.handle_login()
    "register" => @commands.handle_register()
    "publish" => @commands.handle_publish()
    "package" => @commands.handle_package()
    "update" => @commands.handle_update()
    "coverage" => @commands.handle_coverage()
    "generate-build-matrix" => @commands.handle_generate_build_matrix()
    "upgrade" => @commands.handle_upgrade()
    "shell-completion" => @commands.handle_shell_completion()
    "version" => @commands.handle_version(args)
    "repl" => start_repl(args)
    _ => invalid_command(subcmd)
  }
}

///|
fn invalid_command(subcmd : String) -> Unit {
  println("Unknown command: " + subcmd)
  println("Use 'hare --help' for more information.")
}
