//
//  Endpoint.swift
//  RepositoryCollection
//
//  Created by ndthien01 on 21/11/2023.
//

import Foundation

struct Endpoint<T: Decodable>: ReponsableRequestable {
    typealias Response = T
    
    var baseUrl: String
    var path: String
    var method: HTTPMethodType
    var headers: [String : String]?
    var headerParams: [String : String]
    var headerParamsEncodable: Encodable?
    var bodyParams: [String : String]
    var bodyParamsEncodable: Encodable?
    var bodyEncoder: BodyEncoder
    var responseDecoder: ResponseDecoder
    
    init(baseUrl: String,
         path: String,
         method: HTTPMethodType,
         headers: [String : String]? = nil,
         headerParams: [String : String] = [:],
         headerParamsEncodable: Encodable? = nil,
         bodyParams: [String : String] = [:],
         bodyParamsEncodable: Encodable? = nil,
         bodyEncoder: BodyEncoder = JSONBodyEncoder(),
         responseDecoder: ResponseDecoder = JSONResponseDecoder()) {
        self.baseUrl = baseUrl
        self.path = path
        self.method = method
        self.headers = headers
        self.headerParams = headerParams
        self.headerParamsEncodable = headerParamsEncodable
        self.bodyParams = bodyParams
        self.bodyParamsEncodable = bodyParamsEncodable
        self.bodyEncoder = bodyEncoder
        self.responseDecoder = responseDecoder
    }
}

protocol Requestable {
    var baseUrl: String { get }
    var path: String { get }
    var method: HTTPMethodType { get }
    var headers: [String: String]? { get }
    var headerParams: [String: String] { get }
    var headerParamsEncodable: Encodable? { get }
    var bodyParams: [String: String] { get }
    var bodyParamsEncodable: Encodable? { get }
    var bodyEncoder: BodyEncoder { get }
}

extension Requestable {
    
    var url: URL? {
        
        let urlString = baseUrl.appending(path)
        
        var urlComponent = URLComponents(string: urlString)
                
        let queryParams = bodyParamsEncodable?.toDictionary() ?? bodyParams
         
        let query: [URLQueryItem] = queryParams.compactMap { URLQueryItem(name: "\($0)", value: "\($1)") }
        
        urlComponent?.queryItems = query
        
        return urlComponent?.url
    }
    
    var urlRequest: URLRequest? {
        
        guard let url else { return nil }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = method.rawValue
        
        let headerParams = headerParamsEncodable?.toDictionary() ?? headerParams
        
        if !headerParams.isEmpty {
            urlRequest.httpBody = bodyEncoder.encode(headerParams)
        }
        
        urlRequest.allHTTPHeaderFields = headers
        
        return urlRequest
    }
}

protocol ReponsableRequestable: Requestable {
    associatedtype Response
    
    var responseDecoder: ResponseDecoder { get }
}

enum HTTPMethodType: String {
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}

enum BodyEncoding {
    case jsonSerializationData
    case stringEncodingAscii
}

protocol BodyEncoder {
    func encode(_ parameters: JSONDictionary) -> Data?
}

struct JSONBodyEncoder: BodyEncoder {
    func encode(_ parameters: JSONDictionary) -> Data? {
        return try? JSONSerialization.data(withJSONObject: parameters)
    }
}

struct ASCIIBodyEncoder: BodyEncoder {
    func encode(_ parameters: JSONDictionary) -> Data? {
        return parameters.queryString?.data(using: .ascii)
    }
}

protocol ResponseDecoder {
    func decode<T: Decodable>(_ data: Data) throws -> T
}

struct JSONResponseDecoder: ResponseDecoder {
    func decode<T>(_ data: Data) throws -> T where T : Decodable {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}
