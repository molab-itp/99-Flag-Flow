// import Figlet

// @main
// struct FigletTool {
//   static func main() {
//     Figlet.say("Hello, Swift!")
//   }
// }

import Figlet
import ArgumentParser

@main
struct FigletTool: ParsableCommand {
  @Option(help: "Specify the input")
  public var input: String = "No Input"

  public func run() throws {
    print("FigletTool run")
    Figlet.say(self.input)
  }
}
