import Basic
import Foundation
import SPMUtility
import TuistLoader
import TuistSupport
import XCTest

@testable import TuistKit
@testable import TuistLoaderTesting
@testable import TuistSupportTesting

final class DumpCommandTests: TuistUnitTestCase {
    var errorHandler: MockErrorHandler!
    var subject: DumpCommand!
    var parser: ArgumentParser!
    var manifestLoading: ManifestLoading!
    var versionsFetcher: MockVersionsFetcher!

    override func setUp() {
        super.setUp()
        errorHandler = MockErrorHandler()
        parser = ArgumentParser.test()
        manifestLoading = ManifestLoader()
        versionsFetcher = MockVersionsFetcher()
        subject = DumpCommand(manifestLoader: manifestLoading,
                              versionsFetcher: versionsFetcher,
                              parser: parser)
    }

    override func tearDown() {
        errorHandler = nil
        parser = nil
        manifestLoading = nil
        subject = nil
        versionsFetcher = nil
        super.tearDown()
    }

    func test_name() {
        XCTAssertEqual(DumpCommand.command, "dump")
    }

    func test_overview() {
        XCTAssertEqual(DumpCommand.overview, "Outputs the project manifest as a JSON")
    }

    func test_run_throws_when_file_doesnt_exist() throws {
        let tmpDir = try TemporaryDirectory(removeTreeOnDeinit: true)
        let result = try parser.parse([DumpCommand.command, "-p", tmpDir.path.pathString])
        XCTAssertThrowsSpecific(try subject.run(with: result),
                                ManifestLoaderError.manifestNotFound(.project, tmpDir.path))
    }

    func test_run_throws_when_the_manifest_loading_fails() throws {
        let tmpDir = try TemporaryDirectory(removeTreeOnDeinit: true)
        try "invalid config".write(toFile: tmpDir.path.appending(component: "Project.swift").pathString,
                                   atomically: true,
                                   encoding: .utf8)
        let result = try parser.parse([DumpCommand.command, "-p", tmpDir.path.pathString])
        XCTAssertThrowsError(try subject.run(with: result))
    }
}
