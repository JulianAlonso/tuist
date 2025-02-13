import ArgumentParser
import Basic
import Foundation

struct CloudLogoutCommand: ParsableCommand {
    static var configuration: CommandConfiguration {
        CommandConfiguration(commandName: "logout",
                             abstract: "Removes any existing session to authenticate on the server with the URL defined in the Config.swift file")
    }

    func run() throws {
        try CloudLogoutService().logout()
    }
}
