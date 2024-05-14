//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 5/13/24.
//

import Foundation
import Moya

class SATTONetworking {
    static func getTimeTableListFromAuto(done: @escaping () -> Void, failure: @escaping () -> Void) {
        let provider = MoyaProvider<SATTOAPI>()
        provider.request(SATTOAPI.getTimeTableListFromAuto) { result in
            switch result {
            case .success(let response):
                do {
//                    let timetable = try response.map()
                    done()
                } catch {
                    failure()
                }
            case .failure(let error):
                failure()
            }
        }
    }
    
    static func getTimeTableListFromCustom(done: @escaping () -> Void, failure: @escaping () -> Void) {
        let provider = MoyaProvider<SATTOAPI>()
        provider.request(SATTOAPI.getTimeTableListFromCustom) { result in
            switch result {
            case .success(let response):
                do {
//                    let timetable = try response.map()
                    done()
                } catch {
                    failure()
                }
            case .failure(let error):
                failure()
            }
        }
    }
}
