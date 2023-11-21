//
//  RepositoriesViewVM.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 21/11/2023.
//

import Foundation

class RepositoriesViewVM: ObservableObject {
    @Published var items: [GithubRepoModel] = []
}
