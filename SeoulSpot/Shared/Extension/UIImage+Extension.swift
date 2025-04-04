//
//  UIImage+Extension.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 4/1/25.
//

import UIKit

fileprivate let imageCache = NSCache<NSURL, UIImage>()

extension UIImageView {

    /// URL로부터 이미지를 비동기 로딩하고 로딩 완료 후 콜백 전달 (메모리 캐싱 포함)
    func loadImage(from url: URL?, placeholder: UIImage? = nil, completion: ((UIImage?) -> Void)? = nil) {
        self.image = placeholder
        
        guard let url = url else {
            completion?(nil)
            return
        }
        
        // 캐시된 이미지가 있으면 바로 사용
        if let cachedImage = imageCache.object(forKey: url as NSURL) {
            self.image = cachedImage
            completion?(cachedImage)
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  let data = data,
                  let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion?(nil)
                }
                return
            }

            // 캐시에 저장
            imageCache.setObject(image, forKey: url as NSURL)

            DispatchQueue.main.async {
                self.image = image
                completion?(image)
            }
        }.resume()
    }
}
