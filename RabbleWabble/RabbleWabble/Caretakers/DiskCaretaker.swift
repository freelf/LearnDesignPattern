//
//  DiskCaretaker.swift
//  RabbleWabble
//
//  Created by 张东坡 on 2018/10/3.
//  Copyright © 2018年 张东坡. All rights reserved.
//

import Foundation

public final class DiskCaretaker {
    public static let decoder = JSONDecoder()
    public static let encoder = JSONEncoder()

    /// 存储可编码的数据
    public static func save<T: Codable>(_ object: T, to fileName: String) throws {
        do {
            /// 通过给定的 fileName 创建 document 路径
            let url = createDocumentURL(withFileName: fileName)
            /// 通过 encoder 把对象编码为 Ddata
            let data = try encoder.encode(object)
            /// 通过 data 的 write: 方法，把数据写进磁盘
            try data.write(to: url, options: .atomic)
        }catch(let error) {
            /// 打印错误日志并抛出错误
            print("Save failed: Object: `\(object)`, " + "Error: `\(error)`")
            throw error
        }
    }
    /// 从给定的 fileName 恢复对象
    public static func retrieve<T: Codable>(_ type: T.Type, from fileName: String) throws -> T {
        
        let url = createDocumentURL(withFileName: fileName)
        
        return try retrieve(type, from: url)
    }
    /// 从给定的 url 恢复对象
    public static func retrieve<T: Codable> (_ type: T.Type, from url: URL) throws -> T {
        do {
            /// 通过给定的 url 创建数据
            let data = try Data(contentsOf: url)
            /// 通过 decoder 把数据转化为对象
            return try decoder.decode(T.self, from: data)
            
        }catch(let error) {
            /// 打印错误日志并抛出
            print("Retrieve failed: URL: `\(url)`, Error: `\(error)`")
            throw error
        }
    }
    
    public static func createDocumentURL(withFileName fileName: String) -> URL {
        let fileManager = FileManager.default
        let url = fileManager.urls(for: .documentDirectory,
                                   in: .userDomainMask).first!
        return url.appendingPathComponent(fileName)
            .appendingPathExtension("json")
    }
}
