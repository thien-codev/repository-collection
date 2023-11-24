//
//  Encodable.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 22/11/2023.
//

import Foundation

extension Encodable {
    func toDictionary() -> JSONDictionary? {
        do {
            let data = try JSONEncoder().encode(self)
            let josnData = try JSONSerialization.jsonObject(with: data)
            return josnData as? JSONDictionary
        } catch {
            return nil
        }
    }
}
