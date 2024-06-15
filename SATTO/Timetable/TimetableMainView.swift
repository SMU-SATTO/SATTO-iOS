//
//  TimetableMainView.swift
//  SATTO
//
//  Created by 김영준 on 3/6/24.
//

import SwiftUI
import PopupView
import DGCharts
import JHTimeTable

struct TimetableMainView: View {
    @Binding var stackPath: [Route]
    
    @State private var selectedTab = "시간표"
    @State private var currSelectedOption = "총 이수학점"
    
    @Namespace private var namespace
    
    @State var username = "홍길동"
    
    let majorCreditGoals = 72                  //전공 학점 목표
    @State var majorCredit: Double = 60        //전공 학점
    let GECreditGoals = 60                     //교양 학점 목표
    @State var GECredit: Double = 33           //교양 학점
    @State var totalCredit: Double = 130       //전체 학점
    
    var body: some View {
        ZStack {
            Color.backgroundDefault
                .ignoresSafeArea(.all)
            ScrollView {
                ZStack {
                    VStack {
                        headerView
                        tabContentView
                        Spacer()
                    }
                }
            }
        }
    }
    
    private var headerView: some View {
        UnevenRoundedRectangle(bottomLeadingRadius: 20, bottomTrailingRadius: 20)
            .foregroundStyle(Color.banner)
            .frame(height: 160)
            .overlay(
                ZStack {
                    headerContent
                    headerImage
                }
            )
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
            tabButton(title: "이수학점", tab: "이수학점")
            Spacer()
        }
    }
    
    private var headerMessage: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("2024년 2학기 시간표가 업로드됐어요!")
                .font(.b16)
            Text("\(username)님을 위한 시간표를 만들어 드릴게요.")
                .font(.m12)
                .foregroundStyle(Color.bannerText)
        }
    }
    
    private var createTimetableButton: some View {
        Button(action: {
            stackPath.append(Route.timetableOption)
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
    
    private var headerImage: some View {
        GeometryReader { geometry in
            HStack {
                Spacer()
                Image("")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width * 0.35)
                    .frame(height: geometry.size.height * 1.0)
                    .padding(.trailing, 5)
            }
        }
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
                Text("\(username)님의 이번 학기 시간표")
                    .font(.b14)
                    .padding(.leading, 30)
                Spacer()
                Button(action: {
                    stackPath.append(Route.timetableMenu)
                }) {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(Color.blackWhite)
                }
                .padding(.trailing, 20)
            }
            .padding(.top, 10)
            
            TimetableView(timetableBaseArray: [])
            .padding(.horizontal, 15)
        }
    }
    
    private var creditsView: some View {
        VStack {
            HStack {
                Text("\(username)님의 이수 학점")
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
                
                GraduationRequirementsRadarView(entries: ChartTransaction.allTransactions.map { RadarChartDataEntry(value: $0.quantity) })
                    .frame(width: 300, height: 300)
                
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
    TimetableMainView(stackPath: .constant([.timetableMake]))
        .preferredColorScheme(.dark)
}


