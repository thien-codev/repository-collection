//
//  CoreDataGithubRepoStorage.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 23/11/2023.
//

import Foundation
import CoreData

final class CoreDataGithubRepoStorage {
    
    private let coreDataStack: CoreDataStorageStack
    
    init(coreDataStack: CoreDataStorageStack) {
        self.coreDataStack = coreDataStack
    }
    
    private func fetchRequest() -> NSFetchRequest<UserEntity> {
        return UserEntity.fetchRequest()
    }
    
    private func deleteRepos(of userID: String) async {
        coreDataStack.performBackgroundTask { context in
            let request = self.fetchRequest()
            let predicate = NSPredicate(format: "userID == '\(userID)'")
            request.predicate = predicate
            
            do {
                let users = try context.fetch(request)
                users.forEach({ context.delete($0) })
            } catch {
                debugPrint("\(#function) ---> error: \(error)")
            }
        }
    }
}

extension CoreDataGithubRepoStorage: GithubRepoStorage {
    
    func getRepos(of userID: String) async -> [GithubRepoModel] {
        await withCheckedContinuation { continuation in
            let request = fetchRequest()
            let predicate = NSPredicate(format: "userID == '\(userID)'")
            request.predicate = predicate
            
            coreDataStack.performBackgroundTask { context in
                do {
                    if let cacheUser = try context.fetch(request).last,
                    let repositories = cacheUser.repositories as? Set<RepositoryEntity> {
                        continuation.resume(returning: Array(repositories).compactMap({ $0.toGithubRepoModel }))
                    } else {
                        continuation.resume(returning: [])
                    }
                } catch {
                    debugPrint("\(#function) ---> error: \(error)")
                    continuation.resume(returning: [])
                }
            }
        }
    }
    
    func save(_ repos: [GithubRepoModel], with userID: String) async {
        return await withCheckedContinuation { continuation in
            coreDataStack.performBackgroundTask { [weak self] context in
                guard let self, !repos.isEmpty else {
                    continuation.resume()
                    return
                }
                Task {
                    await self.deleteRepos(of: userID)
                }
                do {
                    let _ = repos.toEntity(in: context, userID: userID)
                    try context.save()
                    debugPrint("\(#function) ---> success")
                } catch {
                    debugPrint("\(#function) ---> error: \(error)")
                }
                continuation.resume()
            }
        }
    }
}
