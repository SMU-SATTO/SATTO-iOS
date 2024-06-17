//
//  ChartModel.swift
//  SATTO
//
//  Created by 김영준 on 3/15/24.
//

import Foundation

struct ChartTransaction {
    private var maxA = 15 //전공 심화
    let quantity: Double
    
    static var creditName = ["전공심화", "전공선택", "총 전공", "교양필수", "균형교양", "총 교양"]
    
    static var allTransactions: [ChartTransaction] {
        [
            ChartTransaction(quantity: 15 / 15 * 100), //전공 심화 이런식으로 직접 정규화 해서 값 줘야할듯
            ChartTransaction(quantity: 0), //전공 선택
            ChartTransaction(quantity: 35), //총 전공
            ChartTransaction(quantity: 45), //교양 필수
            ChartTransaction(quantity: 54), //균형 교양
            ChartTransaction(quantity: 20)  //총 교양
        ]
    }
}
