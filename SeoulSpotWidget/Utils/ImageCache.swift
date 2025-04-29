//
//  ImageCache.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 4/24/25.
//

import Foundation
import UIKit

final class ImageCacheManager {
    static let shared = ImageCacheManager()
    
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    private init() {
        let cacheURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        cacheDirectory = cacheURL.appendingPathComponent("SeoulSpotWidgetImages")
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }
    
    // URL에서 이미지 다운로드 및 캐싱
    func downloadAndCacheImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        // 캐시 파일 경로
        let fileName = url.lastPathComponent
        let fileURL = cacheDirectory.appendingPathComponent(fileName)
        
        // 캐시된 이미지 확인
        if let cachedImage = loadImage(from: fileURL) {
            completion(cachedImage)
            return
        }
        
        // 이미지 다운로드
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            // 이미지 캐싱
            try? data.write(to: fileURL)
            completion(image)
        }.resume()
    }
    
    // 캐시된 이미지 로드
    func loadImage(from fileURL: URL) -> UIImage? {
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        return UIImage(data: data)
    }
    
    // 캐시된 이미지 반환 (URL 문자열 기반)
    func getCachedImage(for urlString: String) -> UIImage? {
        let fileName = URL(string: urlString)?.lastPathComponent ?? ""
        let fileURL = cacheDirectory.appendingPathComponent(fileName)
        return loadImage(from: fileURL)
    }
}
