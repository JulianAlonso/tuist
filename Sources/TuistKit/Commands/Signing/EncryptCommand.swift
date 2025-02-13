import ArgumentParser
import Basic
import Foundation

struct EncryptCommand: ParsableCommand {
    static var configuration: CommandConfiguration {
        CommandConfiguration(commandName: "encrypt",
                             abstract: "Encrypts all files in Tuist/Signing directory")
    }

    @Option(
        name: .shortAndLong,
        help: "The path to the folder containing the certificates you would like to encrypt"
    )
    var path: String?

    func run() throws {
        try EncryptService().run(path: path)
    }
}
