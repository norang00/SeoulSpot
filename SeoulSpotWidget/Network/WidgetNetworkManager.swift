//
//  WidgetNetworkManager.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 4/23/25.
//

import Foundation

/* url
   http://openapi.seoul.go.kr:8088/7172637178686f6e363069565a6566/json/culturalEventInfo/1/1/%20/%20/2025-04-23
*/

/* response
 {
     "culturalEventInfo": {
         "list_total_count": 16,
         "RESULT": {
             "CODE": "INFO-000",
             "MESSAGE": "정상 처리되었습니다"
         },
         "row": [
             {
                 "CODENAME": "전시/미술",
                 "GUNAME": "영등포구",
                 "TITLE": "[서울시] 공공미술 수변갤러리 프로젝트 [선유담담] 작품 전시 개장",
                 "DATE": "2025-04-23~2027-04-22",
                 "PLACE": "선유도공원",
                 "ORG_NAME": "서울시청",
                 "USE_TRGT": "누구나",
                 "USE_FEE": "",
                 "PLAYER": "",
                 "PROGRAM": "",
                 "ETC_DESC": "",
                 "ORG_LINK": "https://news.seoul.go.kr/culture/archives/527746",
                 "MAIN_IMG": "https://culture.seoul.go.kr/cmmn/file/getImage.do?atchFileId=27750b5ea7af45f6abc200129f050cbd&thumb=Y",
                 "RGSTDATE": "2025-04-21",
                 "TICKET": "기관",
                 "STRTDATE": "2025-04-23 00:00:00.0",
                 "END_DATE": "2027-04-22 00:00:00.0",
                 "THEMECODE": "기타",
                 "LOT": "37.5423832345578",
                 "LAT": "126.901819342041",
                 "IS_FREE": "무료",
                 "HMPG_ADDR": "https://culture.seoul.go.kr/culture/culture/cultureEvent/view.do?cultcode=153315&menuNo=200009"
             }
         ]
     }
 }
 */

class WidgetNetworkManager {
    
    static let shared = WidgetNetworkManager()

    private init() { }
    
    func getTodayEvent(completion: @escaping (WidgetModel) -> ()) {
        print(#function)
        
        let today = DateFormatter.yyyyMMdd.string(from: Date())
        lazy var apiURL = "http://openapi.seoul.go.kr:8088/7172637178686f6e363069565a6566/json/culturalEventInfo/1/1/%20/%20/\(today)"
        
        guard let url = URL(string: apiURL) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let event = try? JSONDecoder().decode(CulturalEventResponse.self, from: data)
            else { return }
            
            let todayEvent = event.culturalEventInfo.row.first
            let widgetModel = WidgetModel(image: todayEvent?.mainImage ?? "",
                                          place: todayEvent?.place ?? "",
                                          title: todayEvent?.title ?? "",
                                          link: todayEvent?.orgLink ?? "")
            
            print("widget model created: ", widgetModel)

            completion(widgetModel)
        }
        .resume()
    }
}
