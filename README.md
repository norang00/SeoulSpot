# SeoulSpot

**SeoulSpot**은 서울시 공공데이터를 활용하여 지역별·카테고리별 문화행사 정보를 제공하고, 지도 기반 주변 탐색 및 즐겨찾기 기능을 통해 사용자 맞춤형 문화생활 큐레이션을 지원하는 iOS 애플리케이션입니다.

## Features

- 서울시 공공 문화행사 데이터 기반의 큐레이션 제공  
- 사용자의 현재 위치 주변 행사 탐색 (Map 기반)  
- 카테고리, 지역, 요금, 대상 등 조건별 필터링 기능  
- 관심있는 문화행사를 즐겨찾기하여 개인 목록 관리  
- CoreData 기반의 로컬 캐시 저장 및 조건적 최신화

## Data Source

- 서울 열린데이터 광장 공공문화행사 API  
- 매일 **오후 9시**에 업데이트되는 데이터를 기준으로,  
  - 앱 실행 시 최신 데이터 여부 판단 후,  
  - 조건 만족 시에만 API 호출하여 데이터를 갱신합니다.

## Architecture

- **MVVM (Model-View-ViewModel)**: 뷰와 모델 간의 역할 분리를 통해 테스트 가능하고 유지보수가 용이한 구조 구성
- **Coordinator Pattern**: 화면 전환 및 흐름 제어를 명확히 분리하여 ViewController 간 의존도 최소화

## Tech Stack

- **Language**: Swift
- **Frameworks**: UIKit, Combine, CoreLocation, CoreData
- **Networking**: URLSession 기반 REST API 통신
- **Data Persistence**: CoreData
- **Caching**: NSCache를 이용한 이미지 캐싱 최적화
- **Map Integration**: Naver Map SDK
- **Dependency Management**: Swift Package Manager (SPM)

## 주요 기술 포인트

- **조건적 API 갱신 로직**  
  앱 실행 시, 기존 저장 데이터의 존재 여부와 현재 시각을 비교하여 네트워크 호출 여부를 결정합니다. 이를 통해 불필요한 API 호출을 방지하고 앱 응답성과 효율성을 높입니다.

- **CoreData 기반 로컬 캐싱 및 필터링 처리**  
  받아온 데이터를 CoreData에 저장하고, 필터링 및 검색 기능은 모두 로컬에서 처리함으로써 빠른 UX를 제공합니다.

- **NSCache 기반 이미지 캐싱 전략**  
  URL 별로 이미지를 NSCache에 저장하고, UIImageView 확장을 통해 중복 로딩 및 셀 재사용 시 깜빡임 문제를 해결합니다.

- **지도 + 마커 연동**  
  네이버 지도 SDK를 사용하여 현위치 기반 이벤트 마커를 표시하고, 마커 클릭 시 하단 정보 카드를 동적으로 보여주는 UI 구성

## Screenshots

![image](https://github.com/user-attachments/assets/8d2bc366-6580-486f-b75c-336c1649f163)


## Installation

> [App Store](https://apps.apple.com/kr/app/%EC%84%9C%EC%9A%B8%EC%8A%A4%ED%8C%9F-seoulspot/id6744295693?l=en-GB) 

## License

MIT License
