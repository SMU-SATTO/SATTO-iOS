//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 6/18/24.
//

import SwiftUI
import Charts

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

struct RadarChartView: View {
    let data: [(name: String, value: Double)]
    
    var body: some View {
        GeometryReader { geometry in
            let rect = geometry.frame(in: .local)
            let cx = rect.midX
            let cy = rect.midY
            let heightMaxValue = rect.height / 2 * 0.7
            let step = 5
            let radianStep = Double.pi * 2 / Double(data.count)
            
            ZStack {
                ForEach(0..<step, id: \.self) { index in
                    let radius = heightMaxValue * CGFloat(index + 1) / CGFloat(step)
                    Path { path in
                        for i in 0..<data.count {
                            let angle = radianStep * Double(i)
                            let x = cx + radius * cos(angle)
                            let y = cy + radius * sin(angle)
                            if i == 0 {
                                path.move(to: CGPoint(x: x, y: y))
                            } else {
                                path.addLine(to: CGPoint(x: x, y: y))
                            }
                        }
                        path.closeSubpath()
                    }
                    .stroke(Color.radarBackground, lineWidth: 1)
                    
                    //                    Text("\(20 * (index + 1))")
                    //                        .font(.system(size: 8))
                    //                        .position(x: cx + radius + 10, y: cy)
                }
                
                ForEach(0..<data.count, id: \.self) { i in
                    let angle = radianStep * Double(i)
                    let x = cx + heightMaxValue * cos(angle)
                    let y = cy + heightMaxValue * sin(angle)
                    Path { path in
                        path.move(to: CGPoint(x: cx, y: cy))
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                    .stroke(Color.radarBackground, lineWidth: 1)
                    
                    Text(data[i].name)
                        .font(.m10)
                        .position(x: cx + (heightMaxValue * 1.2) * cos(angle), y: cy + (heightMaxValue * 1.15) * sin(angle))
                }
                
                Path { path in
                    for (i, entry) in data.enumerated() {
                        let angle = radianStep * Double(i)
                        let radius = heightMaxValue * CGFloat(entry.value) / 100.0
                        let x = cx + radius * cos(angle)
                        let y = cy + radius * sin(angle)
                        if i == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                    path.closeSubpath()
                }
                .fill(LinearGradient(
                    gradient: Gradient(
                        stops: [
                            Gradient.Stop(color: Color.radarContent.opacity(0.3), location: 0.00),
                            Gradient.Stop(color: Color.radarContent.opacity(0), location: 1.00),
                        ]
                    ),
                    startPoint: UnitPoint(x: 0.5, y: 0),
                    endPoint: UnitPoint(x: 0.5, y: 1.11)
                ))
                
                Path { path in
                    for (i, entry) in data.enumerated() {
                        let angle = radianStep * Double(i)
                        let radius = heightMaxValue * CGFloat(entry.value) / 100.0
                        let x = cx + radius * cos(angle)
                        let y = cy + radius * sin(angle)
                        if i == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                    path.closeSubpath()
                }
                .stroke(Color.radarStroke, lineWidth: 2)
                
                
                ForEach(0..<data.count, id: \.self) { i in
                    let data = data[i]
                    let angle = radianStep * Double(i)
                    let radius = heightMaxValue * CGFloat(data.value) / 100.0
                    let x = cx + radius * cos(angle)
                    let y = cy + radius * sin(angle)
                    Circle()
                        .fill(Color.radarStroke)
                        .frame(width: 5, height: 5)
                        .position(x: x, y: y)
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

struct LectureChartView: View {
    let lectureChartData: [ValuePerLectureCategory]
    
    var todayEnrolledData: Int
    var yesterdayEnrolledData: Int
    var threeDaysAgoEnrolledData: Int
    
    init(todayEnrolledData: Int, yesterdayEnrolledData: Int, threeDaysAgoEnrolledData: Int) {
        self.todayEnrolledData = todayEnrolledData
        self.yesterdayEnrolledData = yesterdayEnrolledData
        self.threeDaysAgoEnrolledData = threeDaysAgoEnrolledData
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        
        let currentDate = Date()
        lectureChartData = [
            .init(category: "2 days ago", value: threeDaysAgoEnrolledData, date: dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: -2, to: currentDate)!)),
            .init(category: "Yesterday", value: yesterdayEnrolledData, date: dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!)),
            .init(category: "Today", value: todayEnrolledData, date: dateFormatter.string(from: currentDate))
        ]
    }
    
    var body: some View {
        VStack {
            Chart(lectureChartData, id: \.category) { item in
                BarMark(
                    x: .value("Date", item.date),
                    y: .value("Value", item.value)
                )
                .cornerRadius(5)
            }
            .foregroundStyle(Color(red: 0.9, green: 0.91, blue: 1))
            .frame(width: 200, height: 160)
        }
    }
}

#Preview {
    VStack {
        RadarChartView(data: [
            (name: "전공선택", value: 60),
            (name: "전공심화", value: 70),
            (name: "교양", value: 50),
            (name: "기초교양", value: 90),
            (name: "상명핵심역량교양", value: 85),
            (name: "균형교양", value: 75)
        ])
        LectureChartView(todayEnrolledData: 50, yesterdayEnrolledData: 40, threeDaysAgoEnrolledData: 30)
    }
    .preferredColorScheme(.dark)
}
