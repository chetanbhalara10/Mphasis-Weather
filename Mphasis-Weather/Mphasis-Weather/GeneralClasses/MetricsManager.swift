//
//  MetricsManager.swift
//  Mphasis-Weather
//
//  Created by CHB on 8/12/24.
//

import Foundation

class MetricsManager {
    
    func emitMatrics(matricName: String, time: Double) {
        let time = time * 1_000
        print("\n \(matricName): \(String(format: "%.2f", time)) milliseconds.")
    }
}
