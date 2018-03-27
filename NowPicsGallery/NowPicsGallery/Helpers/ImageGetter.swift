//
//  ImageGetter.swift
//  SimpleImageDownloaderExample
//
//  Created by Andrew Carter on 10/1/17.
//  Copyright © 2017 Andrew Carter. All rights reserved.
//
// This class was made in conjunction with developer Andrew Carter from Willow Tree Apps Charlottesville.

import Foundation
import UIKit

enum Result<T> {
    case ok(T)
    case error(Error)
}

class ImageGetter {
    
    enum ImageGetterError: Error {
        case unknown
    }
    
    typealias CompletionHandler = (Result<UIImage>) -> Void
    
    private struct Task {
        let sessionTask: URLSessionTask
        let listeners: [CompletionHandler]
        let diskCachePath: String
        let inMemoryCacheName: NSString
    }
    
    private let imageGetterQueue = DispatchQueue(label: "com.ImageGetter.imageGetterQueue")
    private let session = URLSession(configuration: .default)
    private var tasks: [URL: Task] = [:]
    private let cache = NSCache<NSString, UIImage>()
    private static var cacheDirectory: String {
        return (NSTemporaryDirectory() as NSString).appendingPathComponent("\(String(describing: ImageGetter.self))/")
    }
    
    init() {
        createCacheDirectory()
    }
    
    private func createCacheDirectory() {
        do {
            try FileManager.default.createDirectory(atPath: ImageGetter.cacheDirectory, withIntermediateDirectories: true, attributes: [:])
        } catch {
            fatalError("Failed to create storage cache directory")
        }
    }
    
    func getImage(from url: URL, completion: @escaping CompletionHandler) {
        print("Image at \(url) requested")
        imageGetterQueue.async { [weak self] in
            print("Getting image on image getter queue...")
            self?._getImage(from: url, completion: completion)
        }
    }
    
    private func _getImage(from url: URL, completion: @escaping CompletionHandler) {
        let urlString = url.absoluteString
        let cacheFileName = urlString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? String(urlString.hash)
        let diskCachePath = (ImageGetter.cacheDirectory as NSString).appendingPathComponent(cacheFileName)
        let inMemoryCacheName = cacheFileName as NSString
        
        if let cachedImage = cache.object(forKey: inMemoryCacheName) {
            completion(.ok(cachedImage))
        } else if let image = UIImage(contentsOfFile: diskCachePath) {
            cache.setObject(image, forKey: inMemoryCacheName)
            completion(.ok(image))
        } else if let existingTask = tasks[url] {
            let newTask = Task(sessionTask: existingTask.sessionTask,
                               listeners: existingTask.listeners + [completion],
                               diskCachePath: diskCachePath,
                               inMemoryCacheName: inMemoryCacheName)
            tasks[url] = newTask
        } else {
            let sessionTask = session.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
                guard let strongSelf = self else {
                    return
                    
                }
                strongSelf.handleSessionTaskCompletion(url: url, data: data, response: response, error: error)
            })
            tasks[url] = Task(sessionTask: sessionTask,
                              listeners: [completion],
                              diskCachePath: diskCachePath,
                              inMemoryCacheName: inMemoryCacheName)
            sessionTask.resume()
        }
    }
    
    private func handleSessionTaskCompletion(url: URL, data: Data?, response: URLResponse?, error: Error?) {
        imageGetterQueue.async { [weak self] in
            guard let strongSelf = self,
                let task = strongSelf.tasks[url] else {
                    return
            }
            
            strongSelf.tasks[url] = nil
            
            let result: Result<UIImage>
            if let error = error {
                    result = .error(error)
            } else if let data = data,
                let image = UIImage(data: data) {
                strongSelf.cache.setObject(image, forKey: task.inMemoryCacheName)
                try? UIImageJPEGRepresentation(image, 1.0)?.write(to: URL(fileURLWithPath: task.diskCachePath), options: [])
                    result = .ok(image)
            } else {
                result = .error(ImageGetterError.unknown)
            }
            task.listeners.forEach { $0(result) }
        }
    }
    
}

