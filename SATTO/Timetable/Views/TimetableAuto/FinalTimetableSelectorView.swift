//
//  FinalTimetableSelectorView.swift
//  SATTO
//
//  Created by 김영준 on 3/6/24.
//

import SwiftUI
import PopupView

struct FinalTimetableSelectorView: View {
    @ObservedObject var viewModel: ConstraintsViewModel
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var isProgressing = false
    @State private var errorPopup = false
    @State private var isRawChecked = false
    @State private var currIndex: Int = 0
    
    @State private var timetableSelectPopup: Bool = false
    @State private var completionPopup: Bool = false
    
    @State private var registeredTimetableList: Set<Int> = []
    
    @Binding var timetableIndex: Int
    
    var body: some View {
        LazyVStack {
            if let finalTimetableList = viewModel.finalTimetableList {
                if finalTimetableList.count > 0 {
                    timetableTabView
                    FinalTimetablePageIndicator(currIndex: $currIndex, totalIndex: finalTimetableList.count)
                } else {
                    emptyTimetableView
                }
            } else {
                Text("서버 오류!")
                    .font(.sb14)
            }
        }
        .onAppear {
            isRawChecked = false
        }
        .STPopup(isPresented: $isProgressing) {
            TimetableProgressView()
        }
        .STPopup(isPresented: $timetableSelectPopup) {
            FinalSelectPopup(viewModel: viewModel, isPresented: $timetableSelectPopup, completionPopup: $completionPopup, timetableIndex: $timetableIndex, registeredTimetableList: $registeredTimetableList)
        }
    }
    
    private var emptyTimetableView: some View {
        VStack {
            if isRawChecked {
                Text("해당 전공 조합의 남는 시간에 맞는 교양 과목이 없어요..\n불가능한 시간대와 같은 제약조건을 완화해보세요.")
                    .font(.sb16)
                    .foregroundStyle(.blackWhite)
                    .multilineTextAlignment(.center)
            } else {
                Text("해당 전공 조합으로는 최적의 시간표가 존재하지 않아요..\n전체 시간표를 확인해보시겠어요?")
                    .font(.sb16)
                    .foregroundStyle(.blackWhite)
                    .multilineTextAlignment(.center)
                
                Button(action: fetchAllTimetables) {
                    HStack {
                        Text("전체 시간표 확인하기")
                        Image(systemName: "arrow.clockwise")
                    }
                    .font(.sb16)
                    .foregroundStyle(.blackWhite)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(Color.menuCardBackground)
                            .shadow(color: colorScheme == .light ? Color(red: 0.65, green: 0.65, blue: 0.65).opacity(0.65) : Color.clear, radius: 6.23, x: 0, y: 1.22)
                            .padding(EdgeInsets(top: -10, leading: -10, bottom: -10, trailing: -10))
                    )
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                }
            }
        }
    }
    
    private var timetableTabView: some View {
        Group {
            if let finalTimetableList = viewModel.finalTimetableList {
                VStack {
                    Text("\(finalTimetableList.count)개의 시간표가 만들어졌어요!")
                        .font(.sb14)
                        .multilineTextAlignment(.center)
                    Text("좌우로 스크롤하고 시간표를 클릭해 \n 원하는 시간표를 등록해요.")
                        .font(.sb16)
                        .multilineTextAlignment(.center)
                    TabView(selection: $currIndex) {
                        ForEach(finalTimetableList.indices, id: \.self) { index in
                            TimetableView(timetable: TimetableModel(id: -1, semester: "", name: "", lectures: finalTimetableList[index], isPublic: false, isRepresented: false))
                                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                                .onTapGesture {
                                    timetableIndex = index
                                    timetableSelectPopup = true
                                }
                        }
                    }
                    .frame(height: 500)
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .onAppear {
                        currIndex = 0
                        UIScrollView.appearance().isScrollEnabled = true //드래그제스처로 탭뷰 넘기는거 여기 TabView에서만 허용
                    }
                }
            } else { EmptyView() }
        }
    }
    
    private func fetchAllTimetables() {
        isProgressing = true
        Task {
            await viewModel.fetchFinalTimetableList(isRaw: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                isProgressing = false
                isRawChecked = true
            }
        }
    }
}

struct FinalSelectPopup: View {
    @ObservedObject var viewModel: ConstraintsViewModel
    
    @Binding var isPresented: Bool
    @Binding var completionPopup: Bool
    
    @Binding var timetableIndex: Int
    @Binding var registeredTimetableList: Set<Int>
    
    @State private var showingAlert = false
    @State private var timetableName = "시간표"
    
    var body: some View {
        VStack {
            if let finalTimetableList = viewModel.finalTimetableList {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 350, height: 600)
                    .foregroundStyle(Color.popupBackground)
                    .foregroundStyle(Color.red)
                    .overlay(
                        VStack(spacing: 0) {
                            TimetableView(timetable: TimetableModel(id: -1, semester: "", name: "", lectures: finalTimetableList[timetableIndex], isPublic: false, isRepresented: false))
                                .padding()
                            Text("이 시간표를 이번 학기 시간표로\n등록하시겠어요?")
                                .font(.sb16)
                                .foregroundStyle(Color.blackWhite200)
                                .multilineTextAlignment(.center)
                            acceptButton
                            declineButton
                        }
                    )
                    .alert("시간표 이름을 입력해주세요", isPresented: $showingAlert) {
                        alertContent
                    }
            }
        }
        .popup(isPresented: $completionPopup) {
            TimetableSelectCompletionPopup()
        } customize: {
            $0.type(.floater())
                .position(.bottom)
                .appearFrom(.bottom)
                .closeOnTapOutside(true)
                .closeOnTap(true)
                .dragToDismiss(true)
                .backgroundColor(.black.opacity(0.5))
                .autohideIn(3)
        }
    }
    
    private var acceptButton: some View {
        Button(action: {
            showingAlert = true
        }) {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(Color.buttonBlue)
                .padding(.horizontal, 30)
                .overlay(
                    Text("네, 등록할래요")
                        .font(.sb14)
                        .foregroundStyle(.white)
                )
                .frame(maxHeight: 40)
                .padding(.top, 10)
        }
    }
    
    private var declineButton: some View {
        Button(action: {
            isPresented = false
        }) {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(Color.clear)
                .padding(.horizontal, 30)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.buttonBlue, lineWidth: 1.5)
                        .padding(.horizontal, 30)
                        .overlay(
                            Text("아니요, 더 둘러볼래요")
                                .font(.sb14)
                                .foregroundStyle(Color.buttonBlue)
                        )
                )
                .frame(maxHeight: 40)
                .padding(.top, 10)
                .padding(.bottom, 20)
        }
    }
    
    private var alertContent: some View {
        VStack {
            TextField("시간표 이름", text: $timetableName)
                .autocorrectionDisabled()
            HStack {
                Button("취소", role: .cancel, action: {})
                Button("확인") {
                    Task {
                        await viewModel.saveTimetable(timetableIndex: timetableIndex, timetableName: timetableName)
                        registeredTimetableList.insert(timetableIndex)
                        isPresented = false
                        completionPopup = true
                    }
                }
            }
        }
    }
}

struct FinishMakingTimetablePopup: View {
    @Binding var isPresented: Bool
    
    let action: () -> Void
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.popupBackground)
                .frame(width: 300, height: 360)
                .overlay(
                    VStack(spacing: 30) {
                        Image(systemName: "light.beacon.max")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                        Text("시간표 생성을 마치고\n등록된 시간표 목록을 보러가시겠어요?")
                            .font(.sb16)
                            .lineSpacing(5)
                            .multilineTextAlignment(.center)
                        VStack {
                            Button(action: {
                                action()
                                isPresented = false
                            }) {
                                Text("시간표 목록 보러 가기")
                                    .font(.sb14)
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(Color.buttonBlue)
                            )
                            .frame(height: 40)
                            Button(action: {
                                isPresented = false
                            }) {
                                Text("시간표 등록 더하기")
                                    .font(.sb14)
                                    .foregroundStyle(Color.buttonBlue)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(.clear)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .inset(by: 2)
                                            .stroke(Color.buttonBlue, lineWidth: 1.5)
                                    )
                            )
                            .frame(height: 40)
                        }
                        .padding(.horizontal, 15)
                    }
                )
        }
    }
}

struct TimetableSelectCompletionPopup: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("시간표 등록이 완료되었습니다.")
                .font(.sb16)
                .foregroundStyle(.blackWhite)
                .multilineTextAlignment(.center)
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(Color.popupBackground)
                .padding(EdgeInsets(top: -20, leading: -20, bottom: -20, trailing: -20))
                .shadow(radius: 5)
        )
        .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
    }
}
