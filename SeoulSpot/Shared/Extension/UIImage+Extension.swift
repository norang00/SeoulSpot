//
//  UIImage+Extension.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 4/1/25.
//
import UIKit

// 메모리 캐시 객체 (URL을 키로 하고 UIImage를 값으로 가짐)
fileprivate let imageCache = NSCache<NSURL, UIImage>()

// 연관 객체 키: UIImageView에 URL을 저장하기 위한 고유 키
private var imageURLKey: UInt8 = 0

extension UIImageView {
    
    // UIImageView에 현재 로딩 중인 URL을 연관 객체로 저장하고 불러오는 프로퍼티
    private var currentURL: URL? {
        get {
            return objc_getAssociatedObject(self, &imageURLKey) as? URL
        }
        set {
            objc_setAssociatedObject(self, &imageURLKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// URL로부터 이미지를 비동기 로딩하고, 로딩 완료 시 콜백 전달 (메모리 캐싱 포함)
    func loadImage(from url: URL?, placeholder: UIImage? = nil, completion: ((UIImage?) -> Void)? = nil) {
        // 기본으로 보여줄 플레이스홀더 이미지 설정
        self.image = placeholder
        
        // URL이 유효하지 않으면 바로 종료
        guard let url = url else {
            completion?(nil)
            return
        }
        
        // 현재 이미지뷰가 로딩 중인 URL을 저장
        self.currentURL = url
        
        // 캐시된 이미지가 있으면 바로 사용하고 종료
        if let cachedImage = imageCache.object(forKey: url as NSURL) {
            self.image = cachedImage
            completion?(cachedImage)
            return
        }

        // 비동기로 이미지 로딩 시작
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            // self가 존재하고, 데이터가 있고, UIImage로 변환 가능할 경우
            guard let self = self,
                  let data = data,
                  let image = UIImage(data: data) else {
                // 실패 시 메인 스레드에서 콜백 호출
                DispatchQueue.main.async {
                    completion?(nil)
                }
                return
            }

            // 캐시에 이미지를 저장
            imageCache.setObject(image, forKey: url as NSURL)

            // 메인 스레드에서 이미지뷰에 이미지 설정
            DispatchQueue.main.async {
                // 현재 로딩 중인 URL과 응답받은 URL이 일치할 때만 이미지 설정
                if self.currentURL == url {
                    self.image = image
                    completion?(image)
                }
                // 일치하지 않으면 (셀 재사용 등) 이미지 설정하지 않음
            }
        }.resume() // URLSession 시작
    }
}
