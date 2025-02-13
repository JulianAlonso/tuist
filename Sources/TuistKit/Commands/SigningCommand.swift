import ArgumentParser
import Basic
import Foundation

struct SigningCommand: ParsableCommand {
    static var configuration: CommandConfiguration {
        CommandConfiguration(commandName: "signing",
                             abstract: "A set of commands for signing-related operations",
                             subcommands: [
                                 EncryptCommand.self,
                                 DecryptCommand.self,
                             ])
    }
}
