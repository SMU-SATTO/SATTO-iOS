//
//  TimetableMainView.swift
//  SATTO
//
//  Created by 김영준 on 3/6/24.
//

import SwiftUI
import PopupView
import JHTimeTable

enum TimetableRoute: Hashable {
    case timetableMake
    case timetableList
    case timetableOption
    case timetableCustom
    case timetableModify
}

struct TimetableMainView: View {
    @State var tabbarIsHidden: Bool = false
    
    @Environment(\.colorScheme) private var colorScheme
    @State var stackPath = [TimetableRoute]()
    
    @StateObject private var timetableMainViewModel = TimetableMainViewModel()
    
    @State private var selectedTab = "시간표"
    @State private var currSelectedOption = "총 이수학점"
    @State private var tempTimetableName = ""
    
    @Namespace private var namespace
    
    @State private var bottomSheetPresented = false
    
    let majorCreditGoals = 72                  /// 전공 학점 목표
    @State var majorCredit: Double = 60        /// 전공 학점
    let GECreditGoals = 60                     /// 교양 학점 목표
    @State var GECredit: Double = 33           /// 교양 학점
    @State var totalCredit: Double = 130       /// 전체 학점
    
    @State private var nameModifyAlert = false
    @State private var timetableIsPrivateAlert = false
    @State private var deleteTableAlert = false
    @State private var representAlert = false
    
    var body: some View {
        NavigationStack(path: $stackPath){
            ZStack {
                Color.backgroundDefault
                    .ignoresSafeArea(.all)
                ScrollView {
                    VStack {
                        headerView
                        tabContentView
                        Spacer()
                    }
                }
                .scrollIndicators(.hidden)
                .frame(maxHeight: .infinity)
            }
            .sheet(isPresented: $bottomSheetPresented, content: {
                ZStack {
                    UnevenRoundedRectangle(cornerRadii: .init(topLeading: 20, topTrailing: 20))
                        .foregroundStyle(Color.popupBackground)
                        .ignoresSafeArea(.all)
                    VStack(spacing: 15) {
                        HStack {
                            Button(action: {
                                nameModifyAlert = true
                                tempTimetableName = timetableMainViewModel.timetableName
                            }) {
                                HStack {
                                    Image(systemName: "pencil")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20, height: 16)
                                    Text("이름 변경")
                                        .font(.sb16)
                                }
                            }
                            .foregroundStyle(.blackWhite200)
                            Spacer()
                        }
                        HStack {
                            Button(action: {
                                representAlert = true
                            }) {
                                HStack {
                                    Image(systemName: "crown")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20, height: 16)
                                    Text("대표시간표 변경")
                                        .font(.sb16)
                                }
                            }
                            .foregroundStyle(.blackWhite200)
                            Spacer()
                        }
                        HStack {
                            Button(action: {
                                timetableIsPrivateAlert = true
                            }) {
                                HStack {
                                    Image(systemName: "lock")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20, height: 16)
                                    Text("공개 범위 변경")
                                        .font(.sb16)
                                }
                            }
                            .foregroundStyle(.blackWhite200)
                            Spacer()
                        }
                        HStack {
                            Button(action: {
                                deleteTableAlert = true
                            }) {
                                HStack {
                                    Image(systemName: "trash")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20, height: 16)
                                    Text("삭제")
                                        .font(.sb16)
                                }
                            }
                            .foregroundStyle(.blackWhite200)
                            Spacer()
                        }
                    }
                    .padding(.leading, 30)
                }
                .presentationDetents([.height(150)])
            })
            .alert("수정할 이름을 입력해주세요", isPresented: $nameModifyAlert) {
                TextField(timetableMainViewModel.timetableName, text: $timetableMainViewModel.timetableName)
                    .autocorrectionDisabled()
                HStack {
                    Button("취소", role: .cancel) {
                        timetableMainViewModel.timetableName = tempTimetableName
                    }
                    Button("확인") {
                        /// timetable 수정 - 이름 변경 API
                        timetableMainViewModel.patchTimetableName(timetableId: timetableMainViewModel.timetableId, timetableName: timetableMainViewModel.timetableName)
                    }
                }
            }
            .alert("대표시간표로 설정", isPresented: $representAlert) {
                HStack {
                    Button("대표시간표로 설정") {
                        /// 대표 시간표 변경 API
                        timetableMainViewModel.patchTimetableRepresent(timeTableId: timetableMainViewModel.timetableId, isRepresent: true)
                    }
                    Button("취소", role: .cancel, action: {})
                }
            }
            .alert("시간표 공개 범위 변경", isPresented: $timetableIsPrivateAlert) {
                HStack {
                    Button("공개") {
                        /// 공개 비공개 설정 API
                        timetableMainViewModel.patchTimetablePrivate(timeTableId: timetableMainViewModel.timetableId, isPublic: true)
                    }
                    Button("비공개") {
                        timetableMainViewModel.patchTimetablePrivate(timeTableId: timetableMainViewModel.timetableId, isPublic: false)
                    }
                    Button("취소", role: .cancel, action: {})
                }
            }
            .alert("정말로 삭제하시겠어요?", isPresented: $deleteTableAlert) {
                HStack {
                    Button("아니요", role: .cancel, action: {})
                    Button("네") {
                        /// 삭제 API - 삭제하면 대표 시간표를 메인화면에 보여줌
                        /// 대표시간표를 삭제하거나, 대표시간표가 없을 시 빈 시간표를 메인화면에 보여줌
                        timetableMainViewModel.deleteTimetable(timetableID: timetableMainViewModel.timetableId)
                    }
                }
            }
            .navigationDestination(for: TimetableRoute.self) { route in
                switch route {
                case .timetableMake:
                    TimetableMakeView(stackPath: $stackPath)
                case .timetableList:
                    TimetableListView(stackPath: $stackPath, timetableMainViewModel: timetableMainViewModel)
                case .timetableOption:
                    TimetableOptionView(stackPath: $stackPath)
                case .timetableCustom:
                    TimetableCustom(stackPath: $stackPath)
                case .timetableModify:
                    TimetableModifyView(stackPath: $stackPath, timetableMainViewModel: timetableMainViewModel, timetableId: $timetableMainViewModel.timetableId)
                }
            }
            .onChange(of: stackPath) { _ in
                if stackPath.isEmpty {
                    tabbarIsHidden = false
                }
                else {
                    tabbarIsHidden = true
                }
            }
            .toolbar(
                tabbarIsHidden ? .hidden : .visible,
                for: .tabBar
            )
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var headerView: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = min(width * 1920 / 1080, 180)
            
            Image(colorScheme == .light ? .smuBannerDay : .smuBannerNight)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: width, height: height, alignment: .bottomTrailing)
                .clipShape(UnevenRoundedRectangle(
                    bottomLeadingRadius: 20,
                    bottomTrailingRadius: 20)
                )
                .foregroundStyle(Color.banner)
                .overlay(
                    ZStack {
                        headerContent
                    }
                )
                .clipped()
        }
        .frame(height: 180)
    }
    
    private var headerContent: some View {
        VStack(alignment: .leading, spacing: 15) {
            headerTabs
            headerMessage
            createTimetableButton
        }
        .padding(.leading, 20)
    }
    
    private var headerTabs: some View {
        HStack(spacing: 20) {
            tabButton(title: "시간표", tab: "시간표")
            //MARK: - 추후 개발 예정
//            tabButton(title: "이수학점", tab: "이수학점")
            Spacer()
        }
    }
    
    private var headerMessage: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("2024년 2학기 시간표가 업로드됐어요!")
                .font(.b16)
                .shadow(color: colorScheme == .light ? .white : .black, radius: 1, x: 1, y: 1)
                .shadow(color: colorScheme == .light ? .white : .black, radius: 1, x: -1, y: -1)
            Text("지금 시간표를 만들어보세요!")
                .font(.m12)
                .foregroundStyle(Color.bannerText)
        }
    }
    
    private var createTimetableButton: some View {
        Button(action: {
            stackPath.append(TimetableRoute.timetableOption)
        }) {
            Text("시간표 만들기 ->")
                .font(.sb12)
                .foregroundStyle(.white)
                .background(
                    RoundedRectangle(cornerRadius: 7)
                        .fill(Color.buttonBlue)
                        .padding(EdgeInsets(top: -10, leading: -15, bottom: -10, trailing: -15))
                )
        }
        .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
    }
    
    private var tabContentView: some View {
        VStack {
            if selectedTab == "시간표" {
                timetableView
            } else if selectedTab == "이수학점" {
                creditsView
            }
        }
    }
    
    private var timetableView: some View {
        VStack {
            HStack {
                Text("\(timetableMainViewModel.semesterYear) \(timetableMainViewModel.timetableName)")
                    .font(.b14)
                    .padding(.leading, 30)
                    .onAppear {
                        if timetableMainViewModel.timetableId < 0 {
                            // 기본 default 시간표 호출 API
                            timetableMainViewModel.fetchUserTimetable(id: nil)
                        } else {
                            // 특정 시간표 호출 API
                            timetableMainViewModel.fetchUserTimetable(id: timetableMainViewModel.timetableId)
                        }
                    }
                    .onChange(of: timetableMainViewModel.timetableInfo) { _ in
                        timetableMainViewModel.fetchUserTimetable(id: timetableMainViewModel.timetableId)
                    }
                Spacer()
                Group {
                    if timetableMainViewModel.timetableId >= 0 {
                        Button(action: {
                            stackPath.append(TimetableRoute.timetableModify)
                        }) {
                            Image(systemName: "pencil")
                                .foregroundStyle(Color.blackWhite)
                        }
                        Button(action: {
                            bottomSheetPresented.toggle()
                        }) {
                            Image(systemName: "gearshape")
                                .foregroundStyle(Color.blackWhite)
                        }
                    }
                }
                Button(action: {
                    stackPath.append(TimetableRoute.timetableList)
                }) {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(Color.blackWhite)
                }
                .padding(.trailing, 20)
            }
            .padding(.top, 10)
            if timetableMainViewModel.timetableId == -2 {
                Text("대표시간표가 없어요.\n시간표를 생성하고, 시간표를 선택한 다음\n톱니바퀴 버튼을 눌러 대표시간표를 등록해 주세요!")
                    .font(.sb14)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            else {
                TimetableView(timetableBaseArray: timetableMainViewModel.timetableInfo)
                    .padding(.horizontal, 15)
            }
        }
    }
    
    private var creditsView: some View {
        VStack {
            HStack {
                Text("이수 학점")
                    .font(.b14)
                    .padding(.leading, 30)
                Spacer()
            }
            .padding(.top, 10)
            
            RoundedRectangle(cornerRadius: 30)
                .foregroundStyle(Color.pickerBackground)
                .frame(height: 50)
                .overlay(
                    HStack(spacing: 5) {
                        customPickerView(text: "총 이수학점", selectedOption: $currSelectedOption, namespace: namespace)
                        customPickerView(text: "전공", selectedOption: $currSelectedOption, namespace: namespace)
                        customPickerView(text: "교양필수", selectedOption: $currSelectedOption, namespace: namespace)
                        customPickerView(text: "교양", selectedOption: $currSelectedOption, namespace: namespace)
                    }
                        .padding(.horizontal, 5)
                        .animation(.spring(), value: currSelectedOption)
                )
                .padding(.horizontal, 20)
            
            if currSelectedOption == "총 이수학점" {
                pieChart
                    .padding(.top, 5)
                HStack {
                    Text("졸업까지 필요한 학점")
                        .font(.b14)
                        .padding(.leading, 30)
                    Spacer()
                }
                .padding(.top, 10)
                
                RadarChartView(data: [
                    (name: "전공선택", value: 60),
                    (name: "전공심화", value: 70),
                    (name: "교양", value: 50),
                    (name: "기초교양", value: 90),
                    (name: "상명핵심역량교양", value: 85),
                    (name: "균형교양", value: 75)
                ])
                .padding(.horizontal, 60)
                .padding(.vertical, -20)
                
                Text("졸업까지 18학점이 남았어요!")
                    .font(.sb14)
            }
            if currSelectedOption == "전공" {
                pieChart
                    .padding(.top, 5)
            }
        }
    }
    
    @ViewBuilder
    private func customPickerView(text: String, selectedOption: Binding<String>, namespace: Namespace.ID) -> some View {
        GeometryReader { geometry in
            ZStack {
                if selectedOption.wrappedValue == text {
                    RoundedRectangle(cornerRadius: 30)
                        .foregroundStyle(Color.pickerSelected)
                        .frame(height: 35)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        .matchedGeometryEffect(id: "selected", in: namespace)
                }
                
                Text(text)
                    .font(selectedOption.wrappedValue == text ? .sb14 : .m14)
                    .foregroundStyle(selectedOption.wrappedValue == text ? Color.pickerTextSelected : Color.pickerTextUnselected)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
            .contentShape(RoundedRectangle(cornerRadius: 30))
            .onTapGesture {
                selectedOption.wrappedValue = text
            }
        }
    }
    
    private var pieChart: some View {
        HStack {
            PieChartView(slices: [
                (majorCredit, Color.pieBlue),
                (GECredit, Color.pieGreen),
                (totalCredit - majorCredit - GECredit, Color.pieWhite)
            ], centerText: "SampleText\n \(Int(majorCredit + GECredit)) / \(Int(totalCredit))")
            .frame(width: 150)
            
            VStack {
                HStack {
                    Circle()
                        .fill(Color.pieBlue)
                        .frame(width: 12, height: 12)
                    Text("전공 \(Int(majorCredit)) / \(majorCreditGoals)")
                        .font(.m14)
                }
                HStack {
                    Circle()
                        .fill(Color.pieGreen)
                        .frame(width: 12, height: 12)
                    Text("교양 \(Int(GECredit)) / \(GECreditGoals)")
                        .font(.m14)
                }
            }
        }
    }
    
    @ViewBuilder
    private func tabButton(title: String, tab: String) -> some View {
        Button(action: {
            selectedTab = tab
        }) {
            Text(title)
                .font(selectedTab == tab ? .sb16 : .sb14)
                .foregroundStyle(selectedTab == tab ? Color.pickerTextSelected : Color.pickerTextUnselected)
        }
    }
}

struct PieChartView: View {
    @State var slices: [(Double, Color)]
    var centerText: String = "sample text"
    
    var body: some View {
        Canvas { context, size in
            let donut = Path { p in
                p.addEllipse(in: CGRect(origin: .zero, size: size))
                p.addEllipse(in: CGRect(x: size.width * 0.1, y: size.height * 0.1, width: size.width * 0.8, height: size.height * 0.8))
            }
            context.clip(to: donut, style: .init(eoFill: true))
            
            let total = slices.reduce(0) { $0 + $1.0 }
            context.translateBy(x: size.width * 0.5, y: size.height * 0.5)
            var pieContext = context
            pieContext.rotate(by: .degrees(-90))
            let radius = min(size.width, size.height) * 0.48
            var startAngle = Angle.zero
            for (value, color) in slices {
                let angle = Angle(degrees: 360 * (value / total))
                let endAngle = startAngle + angle
                let path = Path { p in
                    p.move(to: .zero)
                    p.addArc(center: .zero, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
                    p.closeSubpath()
                }
                pieContext.fill(path, with: .color(color))
                
                startAngle = endAngle
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .overlay(
            Text(centerText)
                .font(.m14)
                .multilineTextAlignment(.center)
        )
    }
}

#Preview {
    TimetableMainView()
        .preferredColorScheme(.light)
}
