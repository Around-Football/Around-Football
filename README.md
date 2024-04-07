# Around Football (어라운드 풋볼)⚽️
우리 동네 풋살, 축구 용병은 어라운드 풋볼과 함께! <br>
필터 기능을 통해 내게 맞는 적합한 경기를 추천받아 빠르게 신청이 가능하며, 간편하게 용병을 구할 수도 있습니다. <br>
위치 기반으로 사용자들이 보다 쉽게 가까운 경기장을 찾을 수 있으며, 용병 필수 정보와 모집 현황을 직관적으로 제공하여 빠른 용병 매칭이 가능합니다. <br>
실시간 채팅 기능을 통해 주최자와 신청자 간의 빠른 문의도 가능합니다. <br>
<br>

## 📱스크린샷
<img src="https://github.com/Around-Football/Around-Football/assets/106993057/b0401b0d-d5eb-4225-ab06-eaa77556f5ca" width="800"></img>


## 🔗 Links
### [📱 AppStore](https://추가하기)
### [💻 GitHub](https://github.com/Around-Football/Around-Football)
<br>

## 📌 주요 기능
- 예정된 풋살 경기와 용병 모집 공고를 올리고 용병 모집
- 지역, 매치 유형, 성별, 날짜 필터링 검색 제공
- KakaoMap을 기반으로 주변 매칭 검색 가능
- 채팅을 통해 주최자와 실시간 대화 가능
- Apple, Google, Kakao 3가지 SocialLogin을 통한 빠른 회원가입
- 관심 글, 신청 글, 작성 글 등 한 눈에 모아서 관리 가능
<br>

## 기술 스택
- UIKit, MVVM-C, Input-Output, Singleton, CodeBasedUI
- RxSwift, RxAlamofire, RxDataSource
- Firebase Store, Auth, Storage, Analytics, Crashlytics
- Kingfisher, SnapKit
<br>

## 📱시연 영상
영상 첨부
<br>

## 💻 앱 개발 환경

- 최소 지원 버전: iOS 15.0+
- Xcode Version 15.0.0
- iPhone 15 Pro, iPhone 15 Pro Max, iPhone SE3등 전 기종 호환 가능
<br>

## 💡 기술 소개

### MVVM
- 사용자 입력 및 뷰의 로직과 비즈니스에 관련된 로직을 분리하기 위해 MVVM을 도입
- Input, Output 패턴을 활용해 데이터의 흐름을 전달받을 값과, 전달할 값을 명확하게 나누고 관리
<br>

### Coordinator 패턴
- 회원가입과 Login, 채팅 Alert시 DeepLink 등 복잡한 화면이동을 관리하기 위해 뷰 컨트롤러와 화면 전환 로직을 분리
- Coordinator 생성, ViewModel 생성, ViewController 생성하는 패턴으로 의존성 주입
- ViewController의 Input이 ViewModel의 Coordinator로 전달하여 화면 전환
<br>

### RxSwift
- 음악 앱의 특성상 네트워크 요청이 많고, 비동기적으로 작동하기 때문에 비동기 처리와 Thread 관리가 중요
- RxSwift를 활용해 앱 내의 일관성 있는 비동기 처리와 Traits를 활용하여 Thread 관리
<br>

### Firebase
- 사용자 인증, 게시글 작성, 사용자 정보 저장, 실시간 채팅 등의 기능 구현을 위해 별도의 서버 구현없이 빠르게 Firebase를 활용해 구현
- Analytics, Crashlytics를 활용해 실시간 앱 상태 관리와 Crash를 관리하고 Bug Fix
<br>

## ✅ 트러블 슈팅

### 트러블 슈팅 1
<div markdown="1">
SwiftUi에서 구현했던 Custom Calander를 UIKit Project에 적용하기 위해<br>
UIHostingController를 활용하고, 선택한 날짜를 RxSwift의 combineLatest를 활용해 가공해서 사용했습니다.
<br>

```swift
//HCalendarView (SwiftUI)
ScrollView(.horizontal, showsIndicators: false) {
    HStack(spacing: 8) {
        let components = (0...14) .map {
            calendar.date(byAdding: .day, value: $0, to: startDate) ?? Date()
        }
        
        ForEach(components, id: \.self) { date in
            if calendar.component(.day, from: date) == 1 {
                VStack {
                    Text("\(calendar.component(.month, from: date))월")
                        .font(Font(AFFont.titleCard ?? UIFont()))
                        .padding(.bottom, 4)
                }
                .frame(width: 50, height: 65)
                .background(Color(uiColor: AFColor.primary))
                .cornerRadius(30)
            }
            //...
            .onTapGesture {
                let dateString = setDateToString(input: date)
                if observableViewModel.selectedDateSet.contains(dateString) {
                    observableViewModel.selectedDateSet.remove(dateString)
                } else {
                    observableViewModel.selectedDateSet.insert(dateString)
                }
                viewModel.selectedDateSubject.accept(observableViewModel.selectedDateSet)
            }
        }
    }
}

//HomeViewController
private func bindUI() {
  Observable.combineLatest(
            output.recruitList,
            oneLIneCalender.rootView.viewModel.selectedDateSubject.asObservable()
        )
        .map { [weak self] (recruits, selectedDateSet) in
            if !selectedDateSet.isEmpty {
                self?.resetButton.isSelected = false
                return recruits.filter { recruit in
                    selectedDateSet.contains(recruit.matchDateString)
                }
            }
            return recruits
        }
        .map { recruits in
            recruits.sorted { first, second in
                first.matchDate.dateValue() > second.matchDate.dateValue()
            }
        }
        //...
}
```
</div>
<br>

### 트러블 슈팅 2
<div markdown="1">
내용
<br>

```swift

```
</div>
<br>

### 트러블 슈팅 3
<div markdown="1">
내용
<br>

```swift

```
</div>
<br>

### 트러블 슈팅 4
<div markdown="1">
내용
<br>

```swift

```
</div>
<br>
