//
//  FriendView.swift
//  SATTO
//
//  Created by 황인성 on 3/25/24.
//

import SwiftUI

enum FriendRoute: Hashable {
    case search
    case followerSearch
    case followingSearch
    case friend
}

final class FriendNavigationPathFinder: ObservableObject {
    static let shared = FriendNavigationPathFinder()
    private init() { }
    
    @Published var path: [FriendRoute] = []
    
    func addPath(route: FriendRoute) {
        path.append(route)
    }
    
    func popToRoot() {
        path = .init()
    }
}



struct MyPageView: View {
    
    @EnvironmentObject var navPathFinder: FriendNavigationPathFinder
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @StateObject var friendViewModel = FriendViewModel()
    
    var body: some View {
        NavigationStack(path: $navPathFinder.path) {
            ZStack {
                VStack(spacing: 0) {
                    Color(red: 0.92, green: 0.93, blue: 0.94)
                        .ignoresSafeArea(.all)
                    
                    Color.white
                        .ignoresSafeArea(.all)
                }
                
                ScrollView {
                    VStack(spacing: 0) {
                        Spacer()
                            .frame(height: 60)
                        
                        ZStack(alignment: .top) {
                            Rectangle()
                                .fill(Color.white)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .clipShape(
                                    .rect(
                                        topLeadingRadius: 60,
                                        topTrailingRadius: 60
                                    )
                                )
                            
                            VStack(spacing: 0) {
                                HStack(spacing: 0) {
                                    Button(action: {
                                        navPathFinder.addPath(route: .followerSearch)
                                    }, label: {
                                        VStack(spacing: 0) {
                                            Text("\(friendViewModel.follower.count)")
                                                .foregroundColor(Color.gray800)
                                            
                                            Text("팔로워")
                                                .foregroundColor(Color.gray500)
                                        }
                                        .font(.sb16)
                                    })
                                    
                                    Spacer()
                                    
                                    ProfileImageCell(inCircleSize: 100, outCircleSize: 105)
                                        .shadow(radius: 15, x: 0, y: 10)
                                        .padding(.top, -72)
                                        .zIndex(1)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        navPathFinder.addPath(route: .followingSearch)
                                    }, label: {
                                        VStack(spacing: 0) {
                                            Text("\(friendViewModel.following.count)")
                                                .foregroundColor(Color.gray800)
                                            
                                            Text("팔로잉")
                                                .foregroundColor(Color.gray500)
                                        }
                                        .font(.sb16)
                                    })
                                }
                                .padding(.top, 22)
                                .padding(.bottom, 14)
                                .padding(.horizontal, 51)
                                
                                Text("\(authViewModel.user?.name ?? "name") \(authViewModel.user?.studentId ?? "studentId")")
                                    .font(.sb16)
                                    .foregroundColor(Color.gray800)
                                    .padding(.bottom, 5)
                                
                                Text("\(authViewModel.user?.department ?? "department")")
                                    .font(.m14)
                                    .foregroundColor(Color.gray600)
                                    .padding(.bottom, 23)
                                
                                HStack(spacing: 0) {
                                    checkGraduation
                                        .padding(.trailing, 53)
  
                                    modifyTimetable
                                }
                                .padding(.bottom, 37)
                                
                                Text("selectedSemesterYear: \(friendViewModel.selectedSemesterYear)")
                                Text("selectedTimeTableName: \(friendViewModel.selectedTimeTableName)")
                                Text("필터링된 시간표id: \(friendViewModel.getSelectedTimetableId(timeTables: friendViewModel.timeTables))")
                                
                                if friendViewModel.timeTables.isEmpty {
                                    Text("시간표가 없습니다")
                                }
                                else {
                                    HStack(spacing: 0) {
                                        Picker("Select Semester Year", selection: $friendViewModel.selectedSemesterYear) {
                                            
                                            ForEach(friendViewModel.getSemestersFromTimetables(timeTables: friendViewModel.timeTables), id: \.self) { semester in
                                                Text(friendViewModel.formatSemesterString(semester: semester))
                                                    .tag(semester)
                                            }
                                        }
                                        
                                        Picker("Select Time Table", selection: $friendViewModel.selectedTimeTableName) {
                                            ForEach(friendViewModel.getTimetableNamesForSemester(timeTables: friendViewModel.timeTables, semester: friendViewModel.selectedSemesterYear), id: \.self) { name in
                                                Text(name).tag(name)
                                            }
                                        }
                                        Spacer()
                                    }
                                    .padding(.horizontal, 20)
                                    .tint(Color.black)
                                }

                                TimeTableTutorial(friendViewModel: friendViewModel)
                                
                            }
                        }
                    }
                    .onAppear {
                        print("마이페이지뷰 생성")
                        
                        authViewModel.userInfoInquiry {
                            friendViewModel.fetchFollowerList(studentId: authViewModel.user?.studentId ?? "asd")
                            friendViewModel.fetchFollowingList(studentId: authViewModel.user?.studentId ?? "asd")
                            
                        }
                        friendViewModel.fetchMyTimetableList()
                        print("선택학기 추가")
                    }
                    .onChange(of: friendViewModel.selectedSemesterYear) { _ in
                        friendViewModel.selectedTimeTableName = friendViewModel.getTimetableNamesForSemester(timeTables: friendViewModel.timeTables, semester: friendViewModel.selectedSemesterYear).first ?? "이름없음"
                    }
                    .onChange(of: friendViewModel.selectedTimeTableName) { _ in
                        friendViewModel.fetchTimeTableInfo(timeTableId: friendViewModel.getSelectedTimetableId(timeTables: friendViewModel.timeTables))
                    }
                    .navigationBarBackButtonHidden()
                    .navigationDestination(for: FriendRoute.self) { route in
                        switch route {
                        case .search:
                            SearchView(friendViewModel: friendViewModel, TextFieldPlacehold: "친구의 학번을 입력해 주세요")
                        case .followerSearch:
                            FollwerSearchView(friendViewModel: friendViewModel, TextFieldPlacehold: "팔로워 목록")
                        case .followingSearch:
                            FollwingSearchView(friendViewModel: friendViewModel, TextFieldPlacehold: "팔로잉 목록")
                        case .friend:
                            FriendView(friendViewModel: friendViewModel)
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            HStack(spacing: 0) {
                                CustomNavigationTitle(title: "내프로필")
                            }
                            .frame(maxWidth: .infinity)
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            HStack(spacing: 0) {
                                Button(action: {
                                    navPathFinder.addPath(route: .search)
                                }, label: {
                                    Image("searchIcon")
                                })
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    
                }
            }
            
        }
    }
    
    var checkGraduation: some View {
        Text("졸업요건 확인")
            .font(.m12)
            .foregroundColor(Color.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(
                Rectangle()
                    .fill(Color(red: 0.4, green: 0.31, blue: 1.0))
                    .cornerRadius(10)
            )
    }
    
    var modifyTimetable: some View {
        Text("시간표 과목수정")
            .font(.m12)
            .foregroundColor(Color(red: 0.4, green: 0.31, blue: 1.0))
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(red: 0.4, green: 0.31, blue: 1.0), lineWidth: 1)
                
            )
    }

}


struct FriendView: View {
    
    @EnvironmentObject var navPathFinder: FriendNavigationPathFinder
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @ObservedObject var friendViewModel: FriendViewModel
    
    var body: some View {
        ZStack {
            
            VStack(spacing: 0) {
                Color(red: 0.92, green: 0.93, blue: 0.94)
                    .ignoresSafeArea(.all)
                
                Color.white
            }
            
            ScrollView {
                VStack(spacing: 0) {
                    
                    Spacer().frame(height: 60)
                    
                    
                    
                    ZStack(alignment: .top) {
                        Rectangle()
                            .fill(Color.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .clipShape(
                                .rect(
                                    topLeadingRadius: 60,
                                    topTrailingRadius: 60
                                )
                            )
                        
                        
                        VStack(spacing: 0) {
                            HStack(spacing: 0) {
                                
                                Button(action: {
                                    navPathFinder.addPath(route: .followerSearch)
                                }, label: {
                                    VStack(spacing: 0) {
                                        Text("\(friendViewModel.follower.count)")
                                            .foregroundColor(Color.gray800)
                                        
                                        Text("팔로워")
                                            .foregroundColor(Color.gray500)
                                    }
                                    .font(.sb16)
                                })
                                
                                Spacer()
                                
                                ProfileImageCell(inCircleSize: 100, outCircleSize: 105)
                                    .shadow(radius: 15, x: 0, y: 10)
                                    .padding(.top, -72)
                                    .zIndex(1)
                                
                                Spacer()
                                
                                Button(action: {
                                    navPathFinder.addPath(route: .followingSearch)
                                }, label: {
                                    VStack(spacing: 0) {
                                        Text("\(friendViewModel.following.count)")
                                            .foregroundColor(Color.gray800)
                                        
                                        Text("팔로잉")
                                            .foregroundColor(Color.gray500)
                                    }
                                    .font(.sb16)
                                })
                            }
                            .padding(.top, 22)
                            .padding(.bottom, 14)
                            .padding(.horizontal, 51)
                            
                            
                            Text("\(friendViewModel.friend?.name ?? "name") \(friendViewModel.friend?.studentId ?? "studentId")")
                                .font(.sb16)
                                .foregroundColor(Color.gray800)
                                .padding(.bottom, 5)
                            
                            Text("\(friendViewModel.friend?.department ?? "department")")
                                .font(.m14)
                                .foregroundColor(Color.gray600)
                                .padding(.bottom, 23)
                            
                            HStack(spacing: 0) {
                                followState
                                    .padding(.trailing, 53)
                                
                                overlappingTimetable
                            }
                            .padding(.bottom, 37)
                            
                            Button(action: {
                                friendViewModel.fetchFollowerList(studentId: friendViewModel.friend?.studentId ?? "asd")
                            }, label: {
                                Text("팔로워 조회")
                            })
                            Button(action: {
                                friendViewModel.fetchFollowingList(studentId: friendViewModel.friend?.studentId ?? "asd")
                            }, label: {
                                Text("팔로잉 조회")
                            })
                            Button(action: {
                                friendViewModel.fetchFriendTimetableList(studentId: "201910914")
                            }, label: {
                                Text("시간표 조회")
                            })
                            Button(action: {
                                friendViewModel.fetchMyTimetableList()
                            }, label: {
                                Text("내시간표 조회")
                            })
                        }
                    }
                }
                .navigationBarBackButtonHidden()
            }
        }
        .onAppear {
            print("프랜드뷰 생성")
            friendViewModel.fetchMyTimetableList()
            friendViewModel.fetchFollowerList(studentId: friendViewModel.friend?.studentId ?? "asd")
            friendViewModel.fetchFollowingList(studentId: friendViewModel.friend?.studentId ?? "asd")
            
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack(spacing: 0) {
                    CustomBackButton()
                    CustomNavigationTitle(title: "내프로필")
                }
                .frame(maxWidth: .infinity)
            }
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 0) {
                    Button(action: {
                        navPathFinder.addPath(route: .search)
                    }, label: {
                        Image("searchIcon")
                    })
                }
                .frame(maxWidth: .infinity)
            }
        }
        
    }
    
    var followState: some View {
        Text("팔로우")
            .font(.m12)
            .foregroundColor(Color.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(
                Rectangle()
                    .fill(Color(red: 0.4, green: 0.31, blue: 1.0))
                    .cornerRadius(10)
            )
    }
    
    var overlappingTimetable: some View {
        Text("겹치는 시간표 확인")
            .font(.m12)
            .foregroundColor(Color(red: 0.4, green: 0.31, blue: 1.0))
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(red: 0.4, green: 0.31, blue: 1.0), lineWidth: 1)
                
            )
    }
}









#Preview {
    MyPageView()
        .environmentObject(FriendNavigationPathFinder.shared)
}


struct LectureTable: View {
    var body: some View {
        
        
        ScrollView(showsIndicators: true) {
            ZStack(alignment: .top) {
                
                
                Text("\u{200B}")
                    .font(.m11)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color(red: 0.89, green: 0.91, blue: 1.00)
                        .clipShape(
                            .rect(
                                topLeadingRadius: 10,
                                topTrailingRadius: 10
                            )
                        ))
                
                
                HStack(spacing: 0) {
                    VStack(spacing: 0) {
                        Text("학수번호-분반")
                            .padding(.vertical, 8)
                        ForEach(0..<100){_ in
                            Text("HAAC0012-1")
                                .padding(.vertical, 8)
                        }
                    }
                    .padding(.leading, 18)
                    
                    
                    Spacer()
                    VStack(spacing: 0) {
                        Text("학년")
                            .padding(.vertical, 8)
                        ForEach(0..<100){_ in
                            Text("3")
                                .padding(.vertical, 8)
                        }
                    }
                    Spacer()
                    VStack(spacing: 0) {
                        Text("교과목명")
                            .padding(.vertical, 8)
                        ForEach(0..<100){_ in
                            Text("경제학의이해")
                                .padding(.vertical, 8)
                        }
                    }
                    Spacer()
                    VStack(spacing: 0) {
                        Text("이수구분")
                            .padding(.vertical, 8)
                        ForEach(0..<100){_ in
                            Text("1전심")
                                .padding(.vertical, 8)
                        }
                    }
                    Spacer()
                    VStack(spacing: 0) {
                        Text("학점")
                            .padding(.vertical, 8)
                            .padding(.trailing, 29)
                        
                        ForEach(0..<100){_ in
                            HStack(spacing: 0) {
                                Text("3")
                                    .padding(.vertical, 8)
                                    .padding(.trailing, 15)
                                
                                Image(systemName: "plus.circle.dashed")
                                    .frame(width: 14, height: 14)
                                
                            }
                        }
                    }
                }
                .font(.m11)
            }
        }
    }
}

struct TimeTableTutorial: View {
    // 요일 배열
    let daysOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    // 시간 배열 (8am - 9pm)
    let hoursOfDay = Array(8...21).map { hour in
        let period = hour < 12 ? "am" : "pm"
        let hourIn12 = hour > 12 ? hour - 12 : hour
        return "\(hourIn12)\(period)"
    }
    
    @ObservedObject var friendViewModel: FriendViewModel
    
    var body: some View {
        //        ScrollView {
        HStack(spacing: 0) {
            VStack(spacing: 0) {
                Text("")
                    .font(Font.custom("Pretendard", size: 10))
                    .foregroundColor(Color(red: 0.19, green: 0.17, blue: 0.21))
                    .opacity(0.6)
                    .frame(width: 32, height: 40)
                
                ForEach(hoursOfDay, id: \.self) { hour in
                    Text(hour)
                        .font(Font.custom("Pretendard", size: 10))
                        .foregroundColor(Color(red: 0.19, green: 0.17, blue: 0.21))
                        .opacity(0.6)
                        .frame(width: 32, height: 40, alignment: .top)
                    
                }
            }
            
            GeometryReader { geo in
                HStack(spacing: 0) {
                    ForEach(daysOfWeek, id: \.self) { day in
                        VStack(spacing: 0) {
                            Text(day)
                                .font(.system(size: 12, weight: .semibold)) // 변경된 폰트 사용
                                .frame(width: geo.size.width/6, height: 40)
                                .foregroundColor(Color(red: 0.27, green: 0.3, blue: 0.33))
                                .frame(maxWidth: .infinity, alignment: .top)
                                .opacity(0.9)
                            
                            ForEach(0..<hoursOfDay.count, id: \.self) { index in
                                Rectangle()
                                    .stroke(Color(red: 0.25, green: 0.25, blue: 0.24), lineWidth: 0.5)
                                    .frame(height: 40)
                            }
                        }
                    }
                }
                
                if friendViewModel.timeTableInfo?.lects.count == 0 {
                    VStack {
                        Text("시간표 비어있음")
                            .position(x: geo.size.width / 2, y: geo.size.height / 2)
                        
                        Button(action: {
                            print(friendViewModel.timeTableInfo?.lects.count)
                        }, label: {
                            Text("과목개수")
                        })
                    }
                    
                }
                else{
                    if let lectures = friendViewModel.timeTableInfo?.lects {
                        
                        ForEach(lectures, id: \.codeSection) { lecture in
                            ForEach(makeTimeBlock(lectures: [lecture]), id: \.0.codeSection) { lecture, periods, firstTimes in
                                ForEach(0..<periods.count, id: \.self) { index in
                                    let dayIndex = getDayIndex(day: String(firstTimes[index].prefix(1)))
                                    let periodIndex = getPeriodIndex(period: String(firstTimes[index].suffix(1)))
                                    let backgroundColor = friendViewModel.getColorForCodeSection(codeSection: lecture.codeSection)
                                    
                                    VStack(spacing: 0) {
                                        Spacer()
                                            .frame(height: 5)
                                        Text(lecture.lectName)
                                            .font(.m11)
                                            .foregroundColor(.white)
//                                        Text("\(lecture.professor)")
//                                            .font(.system(size: 8))
//                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                    }
                                    .frame(width: geo.size.width/6, height: CGFloat(periods[index]) * 40)
                                    .overlay(
                                        Rectangle()
                                            .stroke(Color(red: 0.25, green: 0.25, blue: 0.24), lineWidth: 0.5)
                                    )
                                    .background(backgroundColor)
//                                    .background(Color.blue)
                                    .position(x: CGFloat(dayIndex) * geo.size.width/6 + geo.size.width / 12,
                                              y: CGFloat(periodIndex) * 40 + CGFloat(periods[index]) * 20 + 40)
                                    
                                }
                            }
                        }
                    } else {
                        Text("No lectures found")
                            .foregroundColor(.black)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        //        }
//        .onAppear {
//            assignColors()
//        }
    }
    
//    func assignColors() {
//        var assignedColors: [String: Color] = [:]
//        var colorIndex = 0
//        
//        if let lectures = friendViewModel.detailTimetable?.lects {
//            
//            for lecture in lectures {
//                if assignedColors[lecture.codeSection] == nil {
//                    assignedColors[lecture.codeSection] = friendViewModel.colors[colorIndex % friendViewModel.colors.count]
//                    colorIndex += 1
//                }
//            }
//        }
////        print(assignedColors)
//        friendViewModel.colorMapping = assignedColors
//    }
    
    func makeTimeBlock(lectures: [Lecture]) -> [(Lecture, [Int], [String])] {
        var result: [(Lecture, [Int], [String])] = []
        
        for lecture in lectures {
            let lectTimes = lecture.lectTime.split(separator: " ").map { String($0) }
            var period = [Int]()
            var firstTimes = [String]()
            var count = 1
            
            for i in 0..<lectTimes.count-1 {
                if let nextTime = nextNumberString(from: String(lectTimes[i])), nextTime == String(lectTimes[i+1]) {
                    count += 1
                } else {
                    period.append(count)
                    firstTimes.append(lectTimes[i - count + 1])  // 연속 시간의 첫 번째 시간을 추가
                    count = 1
                }
            }
            
            // 마지막 강의 시간 블록 처리
            period.append(count)
            firstTimes.append(lectTimes[lectTimes.count - count])
            
            result.append((lecture, period, firstTimes))
        }
        
//        print(result)
        return result
    }

    
    func nextNumberString(from string: String) -> String? {
        let day = String(string.prefix(1)) // 요일 추출
        let numberString = String(string.suffix(1)) // 숫자 부분 추출
        
        guard let number = Int(numberString) else {
            return nil
        }
        
        let nextNumber = number + 1 // 다음 숫자 계산
        return "\(day)\(nextNumber)" // 요일과 다음 숫자를 결합하여 반환
    }
    
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
    
//    func getColorForCodeSection(codeSection: String) -> Color {
//        return friendViewModel.colorMapping[codeSection] ?? .clear
//    }
}

//#Preview {
//    TimeTableTutorial()
//}

