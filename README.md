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

### 데이터 처리 및 동기화

- **조건적 API 갱신 로직**  
  앱 실행 시 저장된 데이터의 존재 여부와 현재 시각(오후 9시)을 비교하여, 필요한 경우에만 API를 호출하여 데이터를 최신화합니다.  
  이를 통해 불필요한 네트워크 트래픽을 줄이고 앱 응답 성능을 향상시킵니다.

- **CoreData 기반 로컬 캐싱 및 필터링 처리**  
  약 300건의 문화행사 데이터를 CoreData에 저장하며, 필터링과 검색은 모두 로컬에서 수행되어 빠른 UX를 제공합니다.  
  사용자가 즐겨찾기한 데이터는 별도의 테이블로 관리되어 초기화 시에도 안전하게 보존됩니다.

### 지도 및 위치 기반 UI

- **지도와 리스트 간 UI 연동 제어**  
  Naver Map SDK와 UICollectionView를 연동하여 지도 조작(카메라 이동, 줌 등)과 리스트 스크롤을 상호 반응하도록 구성했습니다.  

- **CoreLocation 기반 반경 필터링 로직**  
  사용자의 현재 위치와 행사 위치 간 거리를 계산하여 10km 반경 내의 데이터만 필터링하여 제공합니다.  
  사용자가 지도를 이동할 경우, 해당 중심 좌표를 기준으로 다시 필터링됩니다.

- **마커 연동 정보 카드 구현**  
  지도 마커 클릭 시, 해당 행사 정보를 하단 카드 뷰 형태로 표시하여 사용자에게 직관적인 정보 탐색 경험을 제공합니다.

### 이미지 최적화

- **NSCache 기반 이미지 캐싱 전략**  
  이미지 로딩 시 URL을 기준으로 NSCache에 저장하여 셀 재사용 및 스크롤 시 발생할 수 있는 깜빡임을 방지합니다.  
  이미지 캐싱 로직은 URL 기반 매칭을 통해 중복 요청 없이 효율적으로 작동합니다.

## Screenshots

![image](https://github.com/user-attachments/assets/8d2bc366-6580-486f-b75c-336c1649f163)


## Installation

> [App Store](https://apps.apple.com/kr/app/%EC%84%9C%EC%9A%B8%EC%8A%A4%ED%8C%9F-seoulspot/id6744295693?l=en-GB) 
