//
//  LocalStorage.swift
//  Repositories
//
//  Created by Vanya Petrukha on 13.06.2018.
//  Copyright © 2018 Vanya Petrukha. All rights reserved.
//

import Foundation

protocol Storage {
    func store<T>(_ object: T, for key: String) throws where T: Codable
    func retrieve<T>(_ objectType: T.Type, for key: String) throws -> T where T: Codable
}

class LocalStorage: Storage {
    
    enum StorageError: Error {
        case storeFailed(reason: String)
        case retrieveFailed(reason: String)
    }
    
    var directoryURL: URL {
        
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Document directory unavailable")
        }
        
        return url
    }
    
    func store<T>(_ object: T, for key: String) throws where T: Codable {
        
        let storageURL = self.directoryURL.appendingPathComponent(key, isDirectory: false)
        
        let data = try JSONEncoder.default.encode(object)
        
        if FileManager.default.fileExists(atPath: storageURL.path) {
            try FileManager.default.removeItem(at: storageURL)
        }
        
        FileManager.default.createFile(atPath: storageURL.path, contents: data, attributes: nil)
    }
    
    func retrieve<T>(_ objectType: T.Type, for key: String) throws -> T where T: Codable {
        
        let storageURL = self.directoryURL.appendingPathComponent(key, isDirectory: false)
        
        guard FileManager.default.fileExists(atPath: storageURL.path) else {
            throw StorageError.retrieveFailed(reason: "File not exist at \(storageURL.path)")
        }
        
        if let data = FileManager.default.contents(atPath: storageURL.path) {
            return try JSONDecoder.default.decode(objectType, from: data)
        } else {
            throw StorageError.retrieveFailed(reason: "Data corrupted at \(storageURL.path)")
        }
    }
}
