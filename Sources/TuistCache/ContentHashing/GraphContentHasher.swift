import Checksum
import Foundation
import TuistCore
import TuistSupport
import Basic

public protocol GraphContentHashing {
    func contentHashes(for graph: Graphing) throws -> [TargetNode: String]
}

public final class GraphContentHasher: GraphContentHashing {
    private let contentHasher: ContentHashing
    private let coreDataModelsContentHasher: CoreDataModelsContentHashing
    private let sourceFilesContentHasher: SourceFilesContentHashing
    private let targetActionsContentHasher: TargetActionsContentHashing

    // MARK: - Init

    public init(
        contentHasher: ContentHashing = ContentHasher(),
        sourceFilesContentHasher: SourceFilesContentHashing = SourceFilesContentHasher(),
        targetActionsContentHasher: TargetActionsContentHashing = TargetActionsContentHasher(),
        coreDataModelsContentHasher: CoreDataModelsContentHashing = CoreDataModelsContentHasher()
    ) {
        self.contentHasher = contentHasher
        self.sourceFilesContentHasher = sourceFilesContentHasher
        self.coreDataModelsContentHasher = coreDataModelsContentHasher
        self.targetActionsContentHasher = targetActionsContentHasher
    }

    // MARK: - GraphContentHashing

    public func contentHashes(for graph: Graphing) throws -> [TargetNode: String] {
        let hashableTargets = graph.targets.filter { $0.target.product == .framework }
        let hashes = try hashableTargets.map { try hash(targetNode: $0) }
        return Dictionary(uniqueKeysWithValues: zip(hashableTargets, hashes))
    }

    // MARK: - Private

    private func hash(targetNode: TargetNode) throws -> String {
        let target = targetNode.target
        let sourcesHash = try sourceFilesContentHasher.hash(sources: target.sources)
        let resourcesHash = try hash(resources: target.resources)
        let coreDataModelHash = try coreDataModelsContentHasher.hash(coreDataModels: target.coreDataModels)
        let targetActionsHash = try targetActionsContentHasher.hash(targetActions: target.actions)
        let stringsToHash = [sourcesHash,
                             target.name,
                             target.platform.rawValue,
                             target.product.rawValue,
                             target.bundleId,
                             target.productName,
                             resourcesHash,
                             coreDataModelHash,
                             targetActionsHash]


        //TODO: hash headers, platforms, version, entitlements, info.plist, target.environment, target.filesGroup, targetNode.settings, targetNode.project, targetNode.dependencies ,targetNode.target.dependencies

        return try contentHasher.hash(stringsToHash)
    }

    private func hash(headers: Headers) throws -> String {
        let hashes = try (headers.private + headers.project + headers.project).map { path in
            try contentHasher.hash(path)
        }
        return try contentHasher.hash(hashes)
    }

    private func hash(resources: [FileElement]) throws -> String {
        let paths = resources.map { $0.path }
        let hashes = try paths.map { try contentHasher.hash($0) }
        return try contentHasher.hash(hashes)
    }
}
