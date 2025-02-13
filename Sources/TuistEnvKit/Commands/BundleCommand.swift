import ArgumentParser
import Basic
import Foundation

struct BundleCommand: ParsableCommand {
    static var configuration: CommandConfiguration {
        CommandConfiguration(commandName: "bundle",
                             abstract: "Bundles the version specified in the .tuist-version file into the .tuist-bin directory")
    }

    func run() throws {
        try BundleService().run()
    }
}
