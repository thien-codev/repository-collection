//
//  CoreDataUserInfoStorage.swift
//  RepositoryCollection
//
//  Created by Nguyen Thien on 07/07/2024.
//

import Foundation
import CoreData

class CoreDataUserInfoStorage {
    private let coreDataStack: CoreDataStorageStack
    
    init(coreDataStack: CoreDataStorageStack) {
        self.coreDataStack = coreDataStack
    }
    
    private func fetchRequest() -> NSFetchRequest<UserInfoEntity> {
        return UserInfoEntity.fetchRequest()
    }
}

extension CoreDataUserInfoStorage: UserInfoStorage {
    func getAllUserInfos() async -> [GitHubUserModel] {
        await withCheckedContinuation { continuation in
            let fetch = self.fetchRequest()
            
            coreDataStack.performBackgroundTask { context in
                do {
                    let cacheUserInfos = try context.fetch(fetch).reversed()
                    let userInfosModel = cacheUserInfos.compactMap({ $0.toUserInfoModel })
                    continuation.resume(returning: userInfosModel)
                } catch {
                    debugPrint("\(#function) ---> error: \(error)")
                    continuation.resume(returning: [])
                }
            }
        }
    }
    
    func save(userInfo: GitHubUserModel) async {
        return await withCheckedContinuation { continuation in
            coreDataStack.performBackgroundTask { [weak self] context in
                guard let self else {
                    continuation.resume()
                    return
                }
                Task {
                    await self.deleteUserInfo(of: userInfo)
                }
                do {
                    let _ = userInfo.toEntity(in: context)
                    try context.save()
                    debugPrint("\(#function) ---> success")
                } catch {
                    debugPrint("\(#function) ---> error: \(error)")
                }
                continuation.resume()
            }
        }
    }
    
    private func deleteUserInfo(of userInfo: GitHubUserModel) async {
        coreDataStack.performBackgroundTask { context in
            let request = self.fetchRequest()
            let predicate = NSPredicate(format: "login == '\(userInfo.login)'")
            request.predicate = predicate
            
            do {
                let users = try context.fetch(request)
                users.forEach({ context.delete($0) })
                try context.save()
            } catch {
                debugPrint("\(#function) ---> error: \(error)")
            }
        }
    }
}
