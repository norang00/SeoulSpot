# SeoulSpot

서울시 문화행사를 지도와 함께 큐레이션 해주는 iOS 앱  
MVVM + Combine + CoreData 

	1.	SRP 원칙을 따르기 위해 Coordinator 패턴을 사용하여 화면 전환 책임을 분리했습니다.
	2.	View / ViewController / ViewModel 간의 구조 통일과 재사용성을 위해 Base Class 패턴을 도입했습니다.
	3.	객체 간 결합도를 낮추고 테스트 가능한 구조를 만들기 위해 의존성 주입(Dependency Injection)을 적용했습니다.
