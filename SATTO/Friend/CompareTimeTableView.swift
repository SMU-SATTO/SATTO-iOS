//
//  CompareTimeTableView.swift
//  SATTO
//
//  Created by 황인성 on 4/4/24.
//

import SwiftUI

enum CompareTab {
    case overlap
    case gap
}

struct CompareTimeTableView: View {
    
    @State var showFriendSheet: Bool = false
    @State var text: String = ""
    @State var compareFriendCount = 0
    @State var showResult: Bool = true
    
    @State private var selectedPage: CompareTab = .overlap
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @ObservedObject var friendViewModel: FriendViewModel
    
    var body: some View {
        
        ScrollView {
            VStack(spacing: 0) {
                
                VStack(spacing: 0) {
                    
                    LazyVStack(alignment: .leading, spacing: 0) {
                        
                        // sb16
                        Text("이번 학기 겹치는 시간표를\n확인해 같이 수업을 들어 보세요!")
                            .font(.sb16)
                            .foregroundColor(Color.gray800)
                            .padding(.bottom, 5)
                        
                        HStack(spacing: 0) {
                            Image("info.friend")
                                .padding(.trailing, 5)
                            
                            Text("내가 팔로잉하는 친구만 확인 가능합니다.")
                                .font(.m12)
                                .foregroundColor(Color.gray500)
                                .padding(.trailing, 20)
                            if !friendViewModel.compareFriends.isEmpty {
                                Button(action: {
                                    showFriendSheet.toggle()
                                }, label: {
                                    Image(systemName: "person.badge.plus")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundStyle(Color.sattoPurple)
                                })
                            }
                        }
                        
                    }
                    .padding(.vertical, 14)
                    .padding(.leading, 30)
                    
                    
                    if friendViewModel.compareFriends.isEmpty {
                        
                        HStack(spacing: 0) {
                            
                            ProfileImageCell(inCircleSize: 65, outCircleSize: 70)
                            
                            Circle()
                            //                        .fill(Color(red: 0.26, green: 0.56, blue: 1).opacity(0.2))
                                .frame(width: 7, height: 7)
                                .padding(.trailing, 7)
                                .padding(.leading, 30)
                            Circle()
                            //                        .fill(Color(red: 0.26, green: 0.56, blue: 1).opacity(0.5))
                                .frame(width: 7, height: 7)
                                .padding(.trailing, 7)
                            Circle()
                            //                        .fill(Color(red: 0.26, green: 0.56, blue: 1))
                                .frame(width: 7, height: 7)
                                .padding(.trailing, 30)
                            
                            
                            Button(action: {
                                showFriendSheet.toggle()
                            }, label: {
                                Image(systemName: "person.badge.plus")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .foregroundStyle(Color.sattoPurple)
                            })
                        }
                        .padding(.vertical, 20)
                    }
                    else {
                        VStack(spacing: 0) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 0) {
                                    Spacer()
                                        .frame(width: 30)
                                    
                                    ForEach(friendViewModel.compareFriends, id: \.studentId) { friend in
                                        VStack(spacing: 0) {
                                            FriendProfileImageCell(inCircleSize: 65, outCircleSize: 70, friend: friend)
                                                .padding(.bottom, 10)
                                            Text("\(friend.name)")
                                                .font(.m12)
                                        }
                                        .padding(.trailing, 30)
                                    }
                                }
                                .padding(.vertical, 20)
                            }
                            Button(action: {
                                friendViewModel.postCompareTimeTable(studentIds: friendViewModel.compareFriends.map{ $0.studentId })
                                friendViewModel.postCompareTimeTableGap(studentIds: friendViewModel.compareFriends.map{ $0.studentId })
                            }, label: {
                                Text("겹치는 시간표 조회")
                            })
                        }
                    }
                }
                .background(
                    Color.info60
                )
                CompareTopTabBar(selectedPage: $selectedPage)
//                
                TabView(selection: $selectedPage) {
                    CompareTimeTableTutorial(friendViewModel: friendViewModel)
                        .tag(CompareTab.overlap)
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    CompareTimeTableTutorial2(friendViewModel: friendViewModel)
                        .tag(CompareTab.gap)
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .tabViewStyle(PageTabViewStyle())
                .frame(height: 600)
//                .background(Color.red)
                
            }
            
            
        }
        .sheet(isPresented: $showFriendSheet) {
            CompareFriendSearchView(friendViewModel: friendViewModel, showFriendSheet: $showFriendSheet)
        }
        .onAppear {
            print("마이페이지뷰 생성")
            
            // 내 정보 조회가 성공하면
            authViewModel.userInfoInquiry {
                // friend배열이 비어있으면 내 정보를 friend로 변환해서 첫번째 인덱스에 넣는다
//                if friendViewModel.friend.isEmpty {
//                    let friend = convertUserToFriend(user: authViewModel.user)
//                    friendViewModel.friend.append(friend)
//                }
                // 내 팔로워들을 follower배열과 myFollower배열에 넣는다
                friendViewModel.fetchMyFollowerList(studentId: authViewModel.user.studentId) {
                    friendViewModel.follower = friendViewModel.myFollower
                }
                // 내 팔로잉들을 following배열과 myFolloweing배열에 넣는다
                friendViewModel.fetchMyFollowingList(studentId: authViewModel.user.studentId) {
                    friendViewModel.following = friendViewModel.myFollowing
                }
            }
            // 내 시간표들을 조회한다 (강의정보 제외)
            friendViewModel.fetchMyTimetableList()
        }
        // 학기를 바꾸면 그 학기에 해당하는 시간표들의 첫번째 값을 보여준다
        .onChange(of: friendViewModel.selectedSemesterYear) { _ in
            friendViewModel.selectedTimeTableName = friendViewModel.getTimetableNamesForSemester(timeTables: friendViewModel.timeTables, semester: friendViewModel.selectedSemesterYear).first ?? "이름없음"
        }
        // 시간표 이름을 바꾸면 그 시간표의 값을 보여준다
        .onChange(of: friendViewModel.selectedTimeTableName) { _ in
            friendViewModel.fetchTimeTableInfo(timeTableId: friendViewModel.getSelectedTimetableId(timeTables: friendViewModel.timeTables))
        }
        
        Spacer()
    }
}

struct CompareFriendSearchView: View {
    
    @State var text = ""
    @State var selectedFriends: [Friend] = []
    var TextFieldPlacehold: String = "팔로잉 목록"
    
    
    @EnvironmentObject var navPathFinder: FriendNavigationPathFinder
    @ObservedObject var friendViewModel: FriendViewModel
    
    @Binding var showFriendSheet: Bool
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            VStack(spacing: 0){
                HStack(spacing: 0) {
//                    CustomBackButton()
//                        .padding(.leading, 20)
                    ClearButtonTextField(placehold: TextFieldPlacehold, text: $text)
                        .padding(.horizontal, 20)
                }
                .padding(.bottom, 10)
                .padding(.top, 20)
                
                Divider()

                ScrollView {
                    // 네트워크 없이 로컬에서 검색
                    // 이름과 학번 모두 검색 가능
                    ForEach(friendViewModel.following.filter {
                        text.isEmpty || $0.name.contains(text) || $0.studentId.contains(text)
                    }, id: \.studentId) { friend in
                        // 마이페이지든 친구페이지든 followingCell로 표시
                        CompareFriendSearchCell(friend: friend, selectedFriends: $selectedFriends, friendViewModel: friendViewModel)
                            .padding(.bottom, 15)
                            .padding(.top, 10)
                    }
                }
                
                Button(action: {
                    friendViewModel.compareFriends = selectedFriends
                    showFriendSheet = false
                }, label: {
                    Text("확인")
                        .modifier(MyButtonModifier(isDisabled: selectedFriends.isEmpty))
                })
                .disabled(selectedFriends.isEmpty)
                .padding(.horizontal, 20)
                
            }
            .navigationBarBackButtonHidden()
            .onAppear {
                // 내가 보고있는 친구의 팔로잉 조회
                friendViewModel.fetchMyTimetableList()
                friendViewModel.fetchFollowingList(studentId: friendViewModel.friend.last?.studentId ?? "studentId")
            }
            // 학기를 바꾸면 그 학기에 해당하는 시간표들의 첫번째 값을 보여준다
            .onChange(of: friendViewModel.selectedSemesterYear) { _ in
                friendViewModel.selectedTimeTableName = friendViewModel.getTimetableNamesForSemester(timeTables: friendViewModel.timeTables, semester: friendViewModel.selectedSemesterYear).first ?? "이름없음"
            }
            // 시간표 이름을 바꾸면 그 시간표의 값을 보여준다
            .onChange(of: friendViewModel.selectedTimeTableName) { _ in
                friendViewModel.fetchTimeTableInfo(timeTableId: friendViewModel.getSelectedTimetableId(timeTables: friendViewModel.timeTables))
            }
        }
    }
}

struct CompareFriendSearchCell: View {
    
    var friend: Friend
    
    @Binding var selectedFriends: [Friend]
    
    @EnvironmentObject var navPathFinder: FriendNavigationPathFinder
    @ObservedObject var friendViewModel: FriendViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            FriendProfileImageCell(inCircleSize: 60, outCircleSize: 63, friend: friend)
                .padding(.trailing, 14)
                .padding(.leading, 20)
            
//            Button(action: {
//                // 내 정보와 일치하는 친구는 친구페이지로 이동 불가
//                if friend == friendViewModel.friend.first { }
//                // friend목록에 추가하고 뷰 이동
//                else {
//                    friendViewModel.friend.append(friend)
//                    navPathFinder.addPath(route: .friend)
//                }
//                
//                friendViewModel.compareFriends.append(friend)
//            }, label: {
                VStack(alignment: .leading, spacing: 0) {
                    Text(friend.name)
                        .font(.m16)
                        .foregroundColor(Color.gray800)
                    Text(friend.studentId)
                        .font(.m12)
                        .foregroundColor(Color.gray600)
                }
//            })
            
            Spacer()
            
            if selectedFriends.contains(friend) {
                Image("Tick Square")
                    .renderingMode(.template)
                    .foregroundStyle(Color.blue)
                    .padding(.trailing, 20)
            }
            else {
                Image("Tick Square")
                    .renderingMode(.template)
                    .foregroundStyle(Color.gray)
                    .padding(.trailing, 20)
            }
        }
        .onTapGesture {
            if selectedFriends.contains(friend) {
                if let index = selectedFriends.firstIndex(of: friend) {
                    selectedFriends.remove(at: index)
                }
            }
            else {
                selectedFriends.append(friend)
            }
        }
    }
}

struct CompareFriendCell: View {
    
    var name: String
    var studentID: Int
    var isFollowing: Bool
    
    
    var body: some View {
        HStack(spacing: 0) {
            Circle()
                .frame(width: 60, height: 60)
                .background(
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 63, height: 63)
                )
                .shadow(radius: 5, x: 0, y: 5)
                .padding(.trailing, 14)
                .padding(.leading, 20)
            
            Button(action: {
                
            }, label: {
                VStack(alignment: .leading, spacing: 0) {
                    // m16
                    Text("20201499")
                        .font(.m16)
                        .foregroundColor(Color.gray800)
                    
                    // m12
                    Text("한민재")
                        .font(.m12)
                        .foregroundColor(Color.gray600)
                }
            })
            
            
            Spacer()
            
            if isFollowing {
                Text("팔로잉")
                    .font(.m12)
                    .foregroundColor(Color.blue7)
                    .padding(.vertical, 7)
                    .padding(.horizontal, 26)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue7, lineWidth: 1)
                        
                    )
                    .padding(.trailing, 20)
            }
            
            else {
                Text("팔로우")
                    .font(.m12)
                    .foregroundColor(Color.white)
                    .padding(.vertical, 7)
                    .padding(.horizontal, 26)
                    .background(
                        Rectangle()
                            .fill(Color.blue7)
                            .cornerRadius(10)
                    )
                    .padding(.trailing, 20)
                
            }
            
            
            
        }
        
    }
}


struct CompareTimeTableResultView: View {
    
//    @State var showFriendSheet: Bool = false
//    @State var text: String = ""
//    @State var compareFriendCount = 0
//    @State var showResult: Bool = true
    
    var body: some View {
        VStack(spacing: 0) {
            
            LazyVStack(alignment: .leading, spacing: 0) {
                
                // sb16
                Text("이번 학기 겹치는 시간표를\n확인해 같이 수업을 들어 보세요!")
                    .font(.sb16)
                    .foregroundColor(Color.gray800)
                    .padding(.bottom, 5)
                
            }
            .padding(.vertical, 14)
            .padding(.leading, 30)
            
            
//            HStack(spacing: 0) {
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        
                        ProfileImageCell(inCircleSize: 65, outCircleSize: 70)
                        
//                        Circle()
//                            .fill(Color(red: 0.26, green: 0.56, blue: 1).opacity(0.2))
//                            .frame(width: 7, height: 7)
//                            .padding(.trailing, 7)
//                            .padding(.leading, 30)
//
//                        Circle()
//                            .fill(Color(red: 0.26, green: 0.56, blue: 1).opacity(0.5))
//                            .frame(width: 7, height: 7)
//                            .padding(.trailing, 7)
//                        
//                        Circle()
//                            .fill(Color(red: 0.26, green: 0.56, blue: 1))
//                            .frame(width: 7, height: 7)
//                            .padding(.trailing, 30)
//                        
//                        Image(systemName: "person.badge.plus")
//                            .frame(width: 65, height: 65)
//                            .foregroundStyle(Color.sattoPurple)
                        
                        ForEach(0 ..< 10) { item in
                            ProfileImageCell(inCircleSize: 65, outCircleSize: 70)
                                .padding(.trailing, 30)
                        }
                    }
                    .padding(.vertical, 20)
                }
                
//            }
//            .padding(.bottom, 14)

            
        }
        .background(
            Color.info60
        )
        
        Spacer()
    }
}

struct CompareTimeTableTutorial: View {
    
    @ObservedObject var friendViewModel: FriendViewModel
    
    // 요일 배열
    let daysOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    // 시간 배열 (8am - 9pm)
    let hoursOfDay = Array(8...21).map { hour in
        let period = hour < 12 ? "am" : "pm"
        let hourIn12 = hour > 12 ? hour - 12 : hour
        return "\(hourIn12)\(period)"
    }
    
    
    var body: some View {
        // 시간표시
        HStack(spacing: 0) {
            VStack(spacing: 0) {
                // 요일을 표시하는 부분
                Text("")
                    .font(Font.custom("Pretendard", size: 10))
                    .opacity(0.6)
                    .frame(width: 32, height: 40)
                // 여기서부터 시간 표시
                ForEach(hoursOfDay, id: \.self) { hour in
                    Text(hour)
                        .font(Font.custom("Pretendard", size: 10))
                        .opacity(0.6)
                        .frame(width: 32, height: 40, alignment: .top)
                }
            }
            .foregroundStyle(Color.cellText)
            
            // 시간부분 뺴고 지오메트리리더
            GeometryReader { geo in
                HStack(spacing: 0) {
                    // 요일의 개수만큼
                    ForEach(daysOfWeek, id: \.self) { day in
                        VStack(spacing: 0) {
                            // 요일 표시
                            Text(day)
                                .font(.system(size: 12, weight: .semibold)) // 변경된 폰트 사용
                                .frame(width: geo.size.width/6, height: 40)
                                .frame(maxWidth: .infinity, alignment: .top)
                                .opacity(0.9)
                            // 시간 개수만큼 사각형 나열
                            ForEach(0..<hoursOfDay.count, id: \.self) { index in
                                Rectangle()
                                    .stroke(Color.cellText, lineWidth: 0.5)
                                    .frame(height: 40)
                            }
                        }
                    }
                }
                .foregroundStyle(Color.cellText)
                
                // 만약 시간표 정보의 강의의 수가 0이면 지오메트리리더 가운데 텍스트 위치시키기
                if friendViewModel.timeTableInfo?.lects.count == 0 {
                    // 일단 주석처리 ????
//                        Text("시간표 비어있습니다")
//                            .position(x: geo.size.width / 2, y: geo.size.height / 2)
                }
                // 시간표 정보의 강의가 있을때
                else{
                    // timeTableInfo가 nil이 아닐때
                    if let lectures = friendViewModel.timeTableInfo?.lects {
                        
                        var mappedLectures = makeTimeBlock(lectures: lectures, overlappingLectures: friendViewModel.overlappingLectures, compareFriends: friendViewModel.compareFriends)
                        
                        ForEach(mappedLectures, id: \.0.codeSection) { lecture, periods, firstTimes, compareFriends in
                            // periods의 개수 만큼 반복
                            ForEach(0..<periods.count, id: \.self) { index in
                                // firstTimes의 요소의 요일부분을 숫자로 변환 ex) 월3->0 화2->1
                                let dayIndex = getDayIndex(day: String(firstTimes[index].prefix(1)))
                                // firstTimes의 요소의 숫자부분을 숫자로 변환 ex) 월3->3 화2->2
                                let periodIndex = getPeriodIndex(period: String(firstTimes[index].substring(from: 1)))
                                // 매핑되어있는 학수번호를 넣으면 색이 나온다
                                let backgroundColor = friendViewModel.getColorForCodeSection(codeSection: lecture.codeSection)
                                
                                // 강의 표시하는 블럭
                                VStack(spacing: 0) {
                                    Spacer()
                                        .frame(height: 5)
                                    Text(lecture.lectName)
                                        .font(.m11)
                                        .foregroundColor(.white)
//                                    HStack(spacing: 0) {
                                        ForEach(compareFriends, id: \.studentId) { compareFriend in
                                            Text("\(compareFriend.name)")
                                                .font(.system(size: 8))
                                        }
//                                    }
                                    
                                    Spacer()
                                }
                                // 가로길이는 전체에서 요일의 개수로 나눔
                                // 세로길이는 블럭 세로길이 곱하기 periods[index]
                                .frame(width: geo.size.width/6, height: CGFloat(periods[index]) * 40)
                                .overlay(
                                    // 테두리 표시하는거 같은데 의미있나???
                                    Rectangle()
                                        .stroke(Color(red: 0.25, green: 0.25, blue: 0.24), lineWidth: 0.5)
                                )
                                // 학수번호에 맵핑되어있던 배경색
                                .background(backgroundColor)
                                // x축은 몇번쨰 요일인지 확인후 그 요일의 중앙으로 옮긴다
                                // y축은 이해가 안되게 나중에 봐야함 ????
                                .position(x: CGFloat(dayIndex) * geo.size.width/6 + geo.size.width / 12,
                                          y: CGFloat(periodIndex) * 40 + CGFloat(periods[index]) * 20 + 40)
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }

    
    func makeTimeBlock(lectures: [Lecture], overlappingLectures: [[Lecture]], compareFriends: [Friend]) -> [(Lecture, [Int], [String], [Friend])] {
        var result: [(Lecture, [Int], [String], [Friend])] = []
        
        for lecture in lectures {
            let lectTimes = lecture.lectTime.split(separator: " ").map { String($0) }
            var period = [Int]()
            var firstTimes = [String]()
            var count = 1
            var matchingFriends: [Friend] = []

            for i in 0..<lectTimes.count-1 {
                if let nextTime = nextNumberString(from: String(lectTimes[i])), nextTime == String(lectTimes[i+1]) {
                    count += 1
                } else {
                    period.append(count)
                    firstTimes.append(lectTimes[i - count + 1])
                    count = 1
                }
            }

            period.append(count)
            firstTimes.append(lectTimes[lectTimes.count - count])

            // 같은 강의를 듣는 친구들을 찾아서 matchingFriends에 추가
            for overlappingLectureIndex in 0..<overlappingLectures.count {
                let friend = compareFriends[overlappingLectureIndex]
                let lectures1 = overlappingLectures[overlappingLectureIndex]
                
                if lectures1.contains(where: { $0.codeSection == lecture.codeSection }) {
                    matchingFriends.append(friend)
                }
            }
            
            // result에 lecture와 matchingFriends를 추가
            result.append((lecture, period, firstTimes, matchingFriends))
        }
        
        return result
    }

    
    // 문자열을 받아서 옵셔널 문자열을 리턴
    func nextNumberString(from string: String) -> String? {
        // 입력받은 문자열 첫번쨰 글자
        let day = String(string.prefix(1)) // 요일 추출
        // 입력받은 문자열의 마지막 글자
        let numberString = String(string.substring(from: 1)) // 숫자 부분 추출
        // 마지막 글자를 숫자로 형변환
        guard let number = Int(numberString) else {
            // 숫자가 아니면 함수 종류 nil반환
            return nil
        }
        // 마직막 숫자에 + 1
        let nextNumber = number + 1 // 다음 숫자 계산
        // 입력받은 문자 + (입력받은 숫자 + 1)
        return "\(day)\(nextNumber)" // 요일과 다음 숫자를 결합하여 반환
    }
    
    // 요일이 몇번쨰 요일인지 정수로 반환
    func getDayIndex(day: String) -> Int {
        switch day {
        case "월": return 0
        case "화": return 1
        case "수": return 2
        case "목": return 3
        case "금": return 4
        case "토": return 5
        default: return 0
        }
    }
    
    func getPeriodIndex(period: String) -> Int {
        return (Int(period) ?? 1)
    }
}



struct CompareTimeTableTutorial2: View {
    
    @ObservedObject var friendViewModel: FriendViewModel
    
    // 요일 배열
    let daysOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    // 시간 배열 (8am - 9pm)
    let hoursOfDay = Array(8...21).map { hour in
        let period = hour < 12 ? "am" : "pm"
        let hourIn12 = hour > 12 ? hour - 12 : hour
        return "\(hourIn12)\(period)"
    }
    
    
    var body: some View {
        // 시간표시
        HStack(spacing: 0) {
            VStack(spacing: 0) {
                // 요일을 표시하는 부분
                Text("")
                    .font(Font.custom("Pretendard", size: 10))
                    .opacity(0.6)
                    .frame(width: 32, height: 40)
                // 여기서부터 시간 표시
                ForEach(hoursOfDay, id: \.self) { hour in
                    Text(hour)
                        .font(Font.custom("Pretendard", size: 10))
                        .opacity(0.6)
                        .frame(width: 32, height: 40, alignment: .top)
                }
            }
            .foregroundStyle(Color.cellText)
            
            // 시간부분 뺴고 지오메트리리더
            GeometryReader { geo in
                HStack(spacing: 0) {
                    // 요일의 개수만큼
                    ForEach(daysOfWeek, id: \.self) { day in
                        VStack(spacing: 0) {
                            // 요일 표시
                            Text(day)
                                .font(.system(size: 12, weight: .semibold)) // 변경된 폰트 사용
                                .frame(width: geo.size.width/6, height: 40)
                                .frame(maxWidth: .infinity, alignment: .top)
                                .opacity(0.9)
                            // 시간 개수만큼 사각형 나열
                            ForEach(0..<hoursOfDay.count, id: \.self) { index in
                                Rectangle()
                                    .stroke(Color.cellText, lineWidth: 0.5)
                                    .frame(height: 40)
                            }
                        }
                    }
                }
                .foregroundStyle(Color.cellText)
                
                // 만약 시간표 정보의 강의의 수가 0이면 지오메트리리더 가운데 텍스트 위치시키기
                if friendViewModel.timeTableInfo?.lects.count == 0 {
                    // 일단 주석처리 ????
//                        Text("시간표 비어있습니다")
//                            .position(x: geo.size.width / 2, y: geo.size.height / 2)
                }
                // 시간표 정보의 강의가 있을때
                else{
                    // timeTableInfo가 nil이 아닐때
                    if let lectures = friendViewModel.timeTableInfo?.lects {
                        
                        var mappedLectures = makeTimeBlock(lectures: lectures)
                        
                        ForEach(mappedLectures, id: \.0.codeSection) { lecture, periods, firstTimes in
                            // periods의 개수 만큼 반복
                            ForEach(0..<periods.count, id: \.self) { index in
                                // firstTimes의 요소의 요일부분을 숫자로 변환 ex) 월3->0 화2->1
                                let dayIndex = getDayIndex(day: String(firstTimes[index].prefix(1)))
                                // firstTimes의 요소의 숫자부분을 숫자로 변환 ex) 월3->3 화2->2
                                let periodIndex = getPeriodIndex(period: String(firstTimes[index].substring(from: 1)))
                                // 매핑되어있는 학수번호를 넣으면 색이 나온다
                                let backgroundColor = friendViewModel.getColorForCodeSection(codeSection: lecture.codeSection)
                                
                                // 강의 표시하는 블럭
                                VStack(spacing: 0) {
                                    Spacer()
                                        .frame(height: 5)
                                    Text(lecture.lectName)
                                        .font(.m11)
                                        .foregroundColor(.white)
                                    
                                    
                                    
                                    Spacer()
                                }
                                // 가로길이는 전체에서 요일의 개수로 나눔
                                // 세로길이는 블럭 세로길이 곱하기 periods[index]
                                .frame(width: geo.size.width/6, height: CGFloat(periods[index]) * 40)
                                .overlay(
                                    // 테두리 표시하는거 같은데 의미있나???
                                    Rectangle()
                                        .stroke(Color(red: 0.25, green: 0.25, blue: 0.24), lineWidth: 0.5)
                                )
                                // 학수번호에 맵핑되어있던 배경색
                                .background(Color.green.opacity(0.3))
                                // x축은 몇번쨰 요일인지 확인후 그 요일의 중앙으로 옮긴다
                                // y축은 이해가 안되게 나중에 봐야함 ????
                                .position(x: CGFloat(dayIndex) * geo.size.width/6 + geo.size.width / 12,
                                          y: CGFloat(periodIndex) * 40 + CGFloat(periods[index]) * 20 + 40)
                            }
                        }
                        
                        ForEach(friendViewModel.overlappingGapLectures.indices, id: \.self) { index in
                            let lectures1 = friendViewModel.overlappingGapLectures[index]
                            let friend = friendViewModel.compareFriends[index]
                            
                            var mappedLectures = makeTimeBlock(lectures: lectures1)
                            ForEach(mappedLectures, id: \.0.codeSection) { lecture, periods, firstTimes in
                                // periods의 개수 만큼 반복
                                ForEach(0..<periods.count, id: \.self) { index in
                                    // firstTimes의 요소의 요일부분을 숫자로 변환 ex) 월3->0 화2->1
                                    let dayIndex = getDayIndex(day: String(firstTimes[index].prefix(1)))
                                    // firstTimes의 요소의 숫자부분을 숫자로 변환 ex) 월3->3 화2->2
                                    let periodIndex = getPeriodIndex(period: String(firstTimes[index].substring(from: 1)))
                                    // 매핑되어있는 학수번호를 넣으면 색이 나온다
                                    let backgroundColor = friendViewModel.getColorForCodeSection(codeSection: lecture.codeSection)
                                    
                                    // 강의 표시하는 블럭
                                    VStack(spacing: 0) {
                                        Spacer()
                                            .frame(height: 5)
                                        Text(lecture.lectName)
                                            .font(.m11)
                                            .foregroundColor(.white)
                                        
                                        
                                        
                                        Spacer()
                                    }
                                    // 가로길이는 전체에서 요일의 개수로 나눔
                                    // 세로길이는 블럭 세로길이 곱하기 periods[index]
                                    .frame(width: geo.size.width/6, height: CGFloat(periods[index]) * 40)
                                    .overlay(
                                        // 테두리 표시하는거 같은데 의미있나???
                                        Rectangle()
                                            .stroke(Color(red: 0.25, green: 0.25, blue: 0.24), lineWidth: 0.5)
                                    )
                                    // 학수번호에 맵핑되어있던 배경색
                                    .background(Color.black.opacity(0.3))
                                    // x축은 몇번쨰 요일인지 확인후 그 요일의 중앙으로 옮긴다
                                    // y축은 이해가 안되게 나중에 봐야함 ????
                                    .position(x: CGFloat(dayIndex) * geo.size.width/6 + geo.size.width / 12,
                                              y: CGFloat(periodIndex) * 40 + CGFloat(periods[index]) * 20 + 40)
                                }
                            }
                        }
                        
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }

    
    // 강의 배열을 받으면 강의와 숫자배열, 문자배열을 리턴한다
    func makeTimeBlock(lectures: [Lecture]) -> [(Lecture, [Int], [String])] {
        // 빈 배열 상성
        var result: [(Lecture, [Int], [String])] = []
        // 강의 배열을 반복
        for lecture in lectures {
            // 강의시간을 " "기준으로 나눠서 문자배열로 저장
            let lectTimes = lecture.lectTime.split(separator: " ").map { String($0) }
            // 빈 숫자배열 생성
            var period = [Int]()
            // 빈 문자배열 생성
            var firstTimes = [String]()
            // 카운트
            var count = 1
            
            // (강의시간을 나눈 배열 - 1) 번 반복
            for i in 0..<lectTimes.count-1 {
                // nextNumberString은 입력받은 시간의 다음시간을 반환
                // 그 다음시간이 실제 강의 다음시간과 일치하면 count에 1을 더함
                if let nextTime = nextNumberString(from: String(lectTimes[i])), nextTime == String(lectTimes[i+1]) {
                    count += 1
                }
                // 일치하지 않으면
                else {
                    // 빈 숫자배열에 count를 대입
                    period.append(count)
                    // 빈 문자배열에 연속되는 시간의 첫번째 값 대입
                    firstTimes.append(lectTimes[i - count + 1])  // 연속 시간의 첫 번째 시간을 추가
                    count = 1
                }
            }
            
            // 마지막 강의 시간까지 처리
            // 시간 연속여부 추가
            period.append(count)
            // 연속된 시간의 첫번쨰 요소 추가
            firstTimes.append(lectTimes[lectTimes.count - count])
            // 리턴 타입으로 변환
            result.append((lecture, period, firstTimes))
        }
        return result
    }
    
    // 문자열을 받아서 옵셔널 문자열을 리턴
    func nextNumberString(from string: String) -> String? {
        // 입력받은 문자열 첫번쨰 글자
        let day = String(string.prefix(1)) // 요일 추출
        // 입력받은 문자열의 마지막 글자
        let numberString = String(string.substring(from: 1)) // 숫자 부분 추출
        // 마지막 글자를 숫자로 형변환
        guard let number = Int(numberString) else {
            // 숫자가 아니면 함수 종류 nil반환
            return nil
        }
        // 마직막 숫자에 + 1
        let nextNumber = number + 1 // 다음 숫자 계산
        // 입력받은 문자 + (입력받은 숫자 + 1)
        return "\(day)\(nextNumber)" // 요일과 다음 숫자를 결합하여 반환
    }
    
    // 요일이 몇번쨰 요일인지 정수로 반환
    func getDayIndex(day: String) -> Int {
        switch day {
        case "월": return 0
        case "화": return 1
        case "수": return 2
        case "목": return 3
        case "금": return 4
        case "토": return 5
        default: return 0
        }
    }
    
    func getPeriodIndex(period: String) -> Int {
        return (Int(period) ?? 1)
    }
}


struct CompareTopTabBar: View {
    
    @Binding var selectedPage: CompareTab
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("겹치는 시간표 확인")
                    .font(.b14)
                    .foregroundColor(selectedPage == .overlap ? .topTabSelected : .topTabNotSelected)
                    .onTapGesture {
                        withAnimation {
                            selectedPage = .overlap
                        }
                    }
                    .padding(.bottom, 19)
                    .background(
                        Rectangle()
                            .fill(selectedPage == .overlap ? Color.sattoPurple : Color.clear)
                            .frame(height: 3)
                            .cornerRadius(30)
                        ,alignment: .bottom
                    )
                    .padding(.trailing, 24)
                
                Text("공강 확인")
                    .font(.system(size: 14))
                    .foregroundColor(selectedPage == .gap ? .topTabSelected : .topTabNotSelected)
                    .onTapGesture {
                        withAnimation {
                            selectedPage = .gap
                        }
                    }
                    .padding(.bottom, 19)
                    .background(
                        Rectangle()
                            .fill(selectedPage == .gap ? Color.sattoPurple : Color.clear)
                            .frame(height: 3)
                            .cornerRadius(30)
                        ,alignment: .bottom
                    )
                Spacer()
            }
            .background(
                SattoDivider()
                    .padding(.bottom, 1)
                ,alignment: .bottom
            )
        }
        .padding(.horizontal, 20)
    }
}
