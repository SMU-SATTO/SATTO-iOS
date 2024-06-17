//
//  GraduationRequirementsRadarView.swift
//  SATTO
//
//  Created by 김영준 on 3/15/24.
//

import SwiftUI
import DGCharts

struct GraduationRequirementsRadarView: UIViewRepresentable {
    let entries: [RadarChartDataEntry]
    
    func makeUIView(context: Context) -> DGCharts.RadarChartView {
        RadarChartView()
    }
    
    func updateUIView(_ uiView: DGCharts.RadarChartView, context: Context) {
        let dataSet = RadarChartDataSet(entries: entries)
        uiView.data = RadarChartData(dataSet: dataSet)
        
        uiView.webColor = NSUIColor.gray        // 세로 그물 색 변경
        uiView.innerWebColor = NSUIColor.gray   // 둥근 그물 색 변경
        uiView.webLineWidth = 1                 // 그물 두께
        uiView.innerWebLineWidth = 1            // 그물 두께
        
        uiView.xAxis.enabled = true             // 끝 그물 수치 표기 여부
        uiView.xAxis.valueFormatter = IndexAxisValueFormatter(values: ChartTransaction.creditName)
        
        uiView.yAxis.enabled = true             // 가운데 각 그물 수치 표기 여부
        uiView.yAxis.axisMinimum = 0            // yAxis 최솟값 설정
        uiView.yAxis.axisMaximum = 100          // yAxis 최댓값 설정 (그물 최댓값?)
        uiView.yAxis.drawLabelsEnabled = true   // yAxis label 그릴건지
//        uiView.yAxis.granularityEnabled = true // 간격 수치 설정할건지
        uiView.yAxis.granularity = 20        //한 칸당 20으로 설정
        uiView.yAxis.setLabelCount(6, force: true) // 간격 줄 몇개 그릴건지
        
        uiView.legend.enabled = false //범례 표기 안함
        
        formatDataSet(dataSet: dataSet)
        
        uiView.notifyDataSetChanged()
    }
    
    func formatDataSet(dataSet: RadarChartDataSet) {
        dataSet.label = "전공"
        dataSet.colors = [.blue] // 데이터 선 색 변경
        dataSet.lineWidth = 2   // 데이터 선 두께
        dataSet.drawValuesEnabled = false // 그래프 수치 표기 여부
        dataSet.drawFilledEnabled = true // 그래프 안에 채울건지 여부
        dataSet.fillColor = .blue1 // 그래프 채울 떄 색상 설정
        dataSet.drawHighlightCircleEnabled = false // 클릭했을때 포인트 점에 원 그릴건지
        dataSet.drawHorizontalHighlightIndicatorEnabled = false //클릭했을 때 가로선 뜨게할건지
        dataSet.drawVerticalHighlightIndicatorEnabled = false //클릭했을 때 세로선 뜨게할건지
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        dataSet.valueFormatter = DefaultValueFormatter(formatter: formatter)
    }
    
}

#Preview {
    GraduationRequirementsRadarView(entries: ChartTransaction.allTransactions.map { RadarChartDataEntry(value: $0.quantity) })
}
