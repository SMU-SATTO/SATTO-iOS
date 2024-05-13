//
//  File.swift
//  SATTO
//
//  Created by yeongjoon on 5/13/24.
//

import Foundation

class SATTOManager {
    //MARK: - singleton
    fileprivate static var sharedManager: SATTOManager?
    static var sharedInstance: SATTOManager {
        if sharedManager == nil {
            sharedManager = SATTOManager()
        }
        return sharedManager!
    }
    
    func getTimeTableListFromAuto() {
        SATTONetworking.getTimeTableListFromAuto(done: {
            let decoder = JSONDecoder()
        }, failure: {
            
        })
    }
    
    func getTimeTableListFromCustom() {
        SATTONetworking.getTimeTableListFromCustom(done: {
            
        }, failure: {
            
        })
    }
}
