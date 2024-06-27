//
//  UserDefaultRepository.swift
//  RepositoryCollection
//
//  Created by Nguyen Thien on 27/06/2024.
//

import Foundation

public typealias Key = DefaultStorage.Key
public class DefaultsKey {}

/// Provides strongly typed values associated with the lifetime
/// of an application. Apropriate for user preferences.
/// - Warning
/// These should not be used to store sensitive information that could compromise
/// the application or the user's security and privacy.

public final class DefaultStorage {
    
    /// Represents a `Key` with an associated generic value type conforming to the - `Codable` protocol.
    ///     static let someKey = Key<ValueType>("someKey")
    public final class Key<ValueType: Codable>: DefaultsKey {
        fileprivate let _key: String
        public init(_ key: String) {
            _key = key
        }
    }
    
    private var userDefaults: UserDefaults
    
    static var shared = DefaultStorage()
    
    /// An instance of `Defaults` with the specified `UserDefaults` instance.
    private init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
    
    /// Deletes the value associated with the specified key, if any.
    public func clear<ValueType>(_ key: Key<ValueType>) {
        userDefaults.set(nil, forKey: key._key)
        userDefaults.synchronize()
    }
    
    /// Checks if there is a value associated with the specified key.
    public func has<ValueType>(_ key: Key<ValueType>) -> Bool {
        return userDefaults.value(forKey: key._key) != nil
    }
    
    /// Returns the value associated with the specified key.
    public func get<ValueType>(forKey key: Key<ValueType>) -> ValueType? {
        if isSwiftCodableType(ValueType.self) || isFoundationCodableType(ValueType.self) {
            return userDefaults.value(forKey: key._key) as? ValueType
        }
        
        guard let data = userDefaults.data(forKey: key._key) else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            let decoded = try decoder.decode(ValueType.self, from: data)
            return decoded
        } catch {
            #if DEBUG
                print(error)
            #endif
        }

        return nil
        
    }
    
    /// Sets a value associated with the specified key.
    public func set<ValueType>(_ value: ValueType?, forKey key: Key<ValueType>) {
        if value == nil {
            clear(key)
            return
        }
        
        if isSwiftCodableType(ValueType.self) || isFoundationCodableType(ValueType.self) {
            userDefaults.set(value, forKey: key._key)
            return
        }
        
        do {
            let encoder = JSONEncoder()
            let encoded = try encoder.encode(value)
            userDefaults.set(encoded, forKey: key._key)
            userDefaults.synchronize()
        } catch {
            #if DEBUG
                print(error)
            #endif
        }
    }
    
    /// Removes given bundle's persistent domain
    public func removeAll(bundle: Foundation.Bundle = Foundation.Bundle.main) {
        guard let name = bundle.bundleIdentifier else { return }
        self.userDefaults.removePersistentDomain(forName: name)
    }
    
    /// Checks if the specified type is a Codable from the Swift standard library.
    private func isSwiftCodableType<ValueType>(_ type: ValueType.Type) -> Bool {
        switch type {
        case is String.Type, is Bool.Type, is Int.Type, is Float.Type, is Double.Type:
            return true
        default:
            return false
        }
    }
    
    /// Checks if the specified type is a Codable, from the Swift's core libraries
    private func isFoundationCodableType<ValueType>(_ type: ValueType.Type) -> Bool {
        switch type {
        case is Date.Type, is Data.Type:
            return true
        default:
            return false
        }
    }
    
}

// MARK: ValueType with RawRepresentable conformance
public extension DefaultStorage {
    /// Returns the value associated with the specified key.
    func get<ValueType: RawRepresentable>(for key: Key<ValueType>) -> ValueType? where ValueType.RawValue: Codable {
        let convertedKey = Key<ValueType.RawValue>(key._key)
        if let raw = get(forKey: convertedKey) {
            return ValueType(rawValue: raw)
        }
        return nil
    }

    /// Sets a value associated with the specified key.
    func set<ValueType: RawRepresentable>(_ value: ValueType?, for key: Key<ValueType>) where ValueType.RawValue: Codable {
        if value == nil {
            clear(key)
            return
        }
        
        let convertedKey = Key<ValueType.RawValue>(key._key)
        set(value?.rawValue, forKey: convertedKey)
    }
}
