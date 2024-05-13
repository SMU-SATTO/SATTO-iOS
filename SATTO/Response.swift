//
//  Response.swift
//  SATTO
//
//  Created by yeongjoon on 5/13/24.
//

import Foundation

//MARK: - TimetableAutoResponse
struct TimetableAutoResponse: Codable {
    let code: Int
    let result, message: String
    let data: [Datum]
}

