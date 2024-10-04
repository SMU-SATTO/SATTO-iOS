//
//  TimetableMainView.swift
//  SATTO
//
//  Created by 김영준 on 3/6/24.
//

import SwiftUI
import PopupView

enum TimetableRoute: Hashable {
    case timetableMake
    case timetableList
    case timetableOption
    case timetableCustom
    case timetableModify
}

struct TimetableMainView: View {
    @State var tabbarIsHidden: Bool = false
    
    @State var stackPath = [TimetableRoute]()
    
    @ObservedObject var timetableMainViewModel: TimetableMainViewModel
    @ObservedObject var lectureSheetViewModel: LectureSheetViewModel
    @ObservedObject var constraintsViewModel: ConstraintsViewModel
    
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
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        NavigationStack(path: $stackPath){
            ZStack {
                Color.backgroundDefault
                    .ignoresSafeArea(.all)
                VStack {
                    headerView
                    timetableView
                    Spacer()
                }
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
                                tempTimetableName = timetableMainViewModel.currentTimetable?.name ?? ""
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
                TextField(timetableMainViewModel.currentTimetable?.name ?? "", text: $tempTimetableName)
                    .autocorrectionDisabled()
                HStack {
                    Button("취소", role: .cancel) {

                    }
                    Button("확인") {
                        Task {
                            guard let timetableId = timetableMainViewModel.currentTimetable?.id else { return }
                            await timetableMainViewModel.patchTimetableName(
                                timetableId: timetableId,
                                timetableName: tempTimetableName
                            )
                        }
                    }
                }
            }
            .alert("대표시간표로 설정", isPresented: $representAlert) {
                HStack {
                    Button("대표시간표로 설정") {
                        Task {
                            guard let timetableId = timetableMainViewModel.currentTimetable?.id else { return }
                            await timetableMainViewModel.patchTimetableRepresent(timetableId: timetableId, isRepresent: true)
                        }
                    }
                    Button("취소", role: .cancel, action: {})
                }
            }
            .alert("시간표 공개 범위 변경", isPresented: $timetableIsPrivateAlert) {
                HStack {
                    Button("공개") {
                        Task {
                            guard let timetableId = timetableMainViewModel.currentTimetable?.id else { return }
                            await timetableMainViewModel.patchTimetablePrivate(timetableId: timetableId, isPublic: true)
                        }
                    }
                    Button("비공개") {
                        Task {
                            guard let timetableId = timetableMainViewModel.currentTimetable?.id else { return }
                            await timetableMainViewModel.patchTimetablePrivate(timetableId: timetableId, isPublic: false)
                        }
                    }
                    Button("취소", role: .cancel, action: {})
                }
            }
            .alert("정말로 삭제하시겠어요?", isPresented: $deleteTableAlert) {
                HStack {
                    Button("아니요", role: .cancel, action: {})
                    Button("네") {
                        Task {
                            guard let timetableId = timetableMainViewModel.currentTimetable?.id else { return }
                            await timetableMainViewModel.deleteTimetable(timetableId: timetableId)
                        }
                    }
                }
            }
            .navigationDestination(for: TimetableRoute.self) { route in
                switch route {
                case .timetableMake:
                    TimetableMakeView(stackPath: $stackPath, constraintsViewModel: constraintsViewModel, lectureSheetViewModel: lectureSheetViewModel)
                case .timetableList:
                    TimetableListView(stackPath: $stackPath, timetableMainViewModel: timetableMainViewModel)
                case .timetableOption:
                    TimetableOptionView(stackPath: $stackPath, constraintsViewModel: constraintsViewModel)
                case .timetableCustom:
                    TimetableCustom(stackPath: $stackPath, constraintsViewModel: constraintsViewModel, lectureSheetViewModel: lectureSheetViewModel)
                case .timetableModify:
                    TimetableModifyView(stackPath: $stackPath, lectureSheetViewModel: lectureSheetViewModel, timetableMainViewModel: timetableMainViewModel)
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
            headerMessage
            createTimetableButton
        }
        .padding(.leading, 20)
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
    
    private var timetableView: some View {
        VStack {
            HStack {
                if let currentTimetable = timetableMainViewModel.currentTimetable {
                    Text("\(currentTimetable.semester) \(currentTimetable.name)")
                        .font(.b14)
                        .padding(.leading, 30)
                }
                Spacer()
                Group {
                    if let _ = timetableMainViewModel.currentTimetable {
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
            .task {
                if timetableMainViewModel.currentTimetable?.id == nil  {
                    await timetableMainViewModel.fetchRepresentTimetable()
                }
            }
            .padding(.top, 10)
            if let currentTimetable = timetableMainViewModel.currentTimetable {
                TimetableView(timetable: currentTimetable)
                    .padding(.horizontal, 15)
            }
            else {
                Text("대표시간표가 없어요.\n시간표를 생성하고, 시간표를 선택한 다음\n톱니바퀴 버튼을 눌러 대표시간표를 등록해 주세요!")
                    .font(.sb14)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
    }
}
//
//#Preview {
//    TimetableMainView()
//        .preferredColorScheme(.light)
//}
