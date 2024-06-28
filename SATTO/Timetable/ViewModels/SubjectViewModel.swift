//
//  SubjectViewModel.swift
//  SATTO
//
//  Created by yeongjoon on 4/28/24.
//

import SwiftUI
import JHTimeTable

///서버에서 받아온 뷰모델
final class SubjectViewModel: ObservableObject {
    let repository = TimetableRepository()
    let colorSelectionManager = ColorSelectionManager()
    
    //MARK: - 배열 객체로 바꾸기
    @Published var subjectData: [SubjectModel] = [
        SubjectModel(sbjDivcls: "HAEA0008-1", sbjNo: "HAEA0008", sbjName: "컴퓨터네트워크", time: "목4 금5 금6"),
        SubjectModel(sbjDivcls: "HAEA0008-2", sbjNo: "HAEA0008", sbjName: "운영체제", time: "월1 월2 월3"),
        SubjectModel(sbjDivcls: "HAEA0008-3", sbjNo: "HAEA0008", sbjName: "소프트웨어공학", time: "월4 목3 금4")
    ]
    @Published var subjectData1 = SubjectModel(sbjDivcls: "HAEA0008-1", sbjNo: "HAEA0008", sbjName: "컴퓨터네트워크", time: "목4 금5 금6")
    @Published var subjectData2 = SubjectModel(sbjDivcls: "HAEA0008-2", sbjNo: "HAEA0008", sbjName: "운영체제", time: "월1 월2 월3")
    @Published var subjectData3 = SubjectModel(sbjDivcls: "HAEA0008-3", sbjNo: "HAEA0008", sbjName: "소프트웨어공학", time: "월4 목3 금4")
    
    //    @Published var subjectDetailDataList: [TimetableDetailModel] = []
    @Published var subjectDetailDataList: [SubjectDetailModel] = [
        SubjectDetailModel(major: "1전심", sbjDivcls: "HAEA9239-3", sbjNo: "HAEA9239", sbjName: "GPU프로그래밍", prof: "나재호", time: "화5 화6 수8", credit: 3, enrolledStudents: 115, yesterdayEnrolledData: 100, threeDaysAgoEnrolledData: 80),
        SubjectDetailModel(major: "1전심", sbjDivcls: "HAEA0005-1", sbjNo: "HAEA0005", sbjName: "디지털신호처리", prof: "강상욱", time: "수1 수2 수3", credit: 3, enrolledStudents: 120, yesterdayEnrolledData: 20, threeDaysAgoEnrolledData: 30),
    ]
    
    func fetchCurrentLectureList() {
        repository.getCurrentLectureList() { [weak self] result in
            switch result {
            case .success(let subjectDetailModels):
                DispatchQueue.main.async {
                    self?.subjectDetailDataList = subjectDetailModels
                }
            case .failure(let error):
                print("Error fetching currentLectureList: \(error)")
            }
        }
    }
}

class ColorSelectionManager {
    var selectedColors: Set<Color> = []
    
    let colors: [Color] = [.red, .blue, .green, .orange, .yellow, .purple, .pink, .cyan, .teal, .indigo]

    func randomColor() -> Color {
        var availableColors = colors.filter { !selectedColors.contains($0) }
        if availableColors.isEmpty {
            availableColors = colors
            selectedColors.removeAll()
        }
        let randomIndex = Int.random(in: 0..<availableColors.count)
        let selectedColor = availableColors[randomIndex]
        selectedColors.insert(selectedColor)
        return selectedColor
    }
}
