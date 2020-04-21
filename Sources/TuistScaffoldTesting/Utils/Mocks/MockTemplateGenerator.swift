import Foundation
import TSCBasic
@testable import TuistCore
@testable import TuistScaffold

public final class MockTemplateGenerator: TemplateGenerating {
    public var generateStub: ((Template, AbsolutePath, [String: String]) throws -> Void)?

    public func generate(template: Template, to destinationPath: AbsolutePath, attributes: [String: String]) throws {
        try generateStub?(template, destinationPath, attributes)
    }
}
