import ArgumentParser
import Basic
import Foundation

struct CloudSessionCommand: ParsableCommand {
    static var configuration: CommandConfiguration {
        CommandConfiguration(commandName: "session",
                             abstract: "Prints any existing session to authenticate on the server with the URL defined in the Config.swift file")
    }

    func run() throws {
        try CloudSessionService().printSession()
    }
}
