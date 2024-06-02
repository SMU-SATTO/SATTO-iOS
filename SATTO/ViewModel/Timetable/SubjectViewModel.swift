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
        SubjectDetailModel(major: "전공", sbjDivcls: "ABC-03", sbjNo: "ABC", sbjName: "과목명", prof: "홍길동", time: "화2 화3 화4", credit: 3, enrollmentCapacity: 100, enrolledStudents: 115, yesterdayEnrolledData: 100, threeDaysAgoEnrolledData: 80),
        SubjectDetailModel(major: "전공", sbjDivcls: "DEF-05", sbjNo: "DEF", sbjName: "데이터베이스", prof: "춘향이", time: "월4 월5 월6", credit: 3, enrollmentCapacity: 150, enrolledStudents: 120, yesterdayEnrolledData: 20, threeDaysAgoEnrolledData: 30),
        SubjectDetailModel(major: "교양", sbjDivcls: "FAS-05", sbjNo: "DEF", sbjName: "운영체제", prof: "가나다", time: "월4 월5 월6", credit: 3, enrollmentCapacity: 150, enrolledStudents: 120, yesterdayEnrolledData: 20, threeDaysAgoEnrolledData: 30),
        SubjectDetailModel(major: "전공", sbjDivcls: "QWE-01", sbjNo: "DEF", sbjName: "English and Foundations(speaking)", prof: "프란시스 브래넌", time: "월1 월2 월3", credit: 3, enrollmentCapacity: 150, enrolledStudents: 120, yesterdayEnrolledData: 20, threeDaysAgoEnrolledData: 30),
        SubjectDetailModel(major: "교양", sbjDivcls: "ASD-02", sbjNo: "DEF", sbjName: "데이터마이닝", prof: "아자차카", time: "토4 월5 월6", credit: 3, enrollmentCapacity: 150, enrolledStudents: 120, yesterdayEnrolledData: 20, threeDaysAgoEnrolledData: 30),
        SubjectDetailModel(major: "전공", sbjDivcls: "ZXC-08", sbjNo: "DEF", sbjName: "컴퓨터수학", prof: "타파하", time: "월4 월5 월6", credit: 3, enrollmentCapacity: 150, enrolledStudents: 120, yesterdayEnrolledData: 20, threeDaysAgoEnrolledData: 30),
        SubjectDetailModel(major: "전공", sbjDivcls: "ZXC-09", sbjNo: "DEF", sbjName: "이산수학", prof: "교수명", time: "월2 월3 월4", credit: 5, enrollmentCapacity: 150, enrolledStudents: 120, yesterdayEnrolledData: 20, threeDaysAgoEnrolledData: 30),
        SubjectDetailModel(major: "전공", sbjDivcls: "ZXC-10", sbjNo: "DEF", sbjName: "소프트웨어공학", prof: "교수명2", time: "월4 월5 월6", credit: 7, enrollmentCapacity: 150, enrolledStudents: 120, yesterdayEnrolledData: 20, threeDaysAgoEnrolledData: 30)
    ]
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
