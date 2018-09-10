//
//  Passage.swift
//  Bus Le Pecq
//
//  Created by EMONET Corentin on 10/09/2018.
//  Copyright © 2018 EMONET Corentin. All rights reserved.
//

import Foundation

struct PassageBus {
    let delay: Int
    let line: String
    let isRT: Bool
    let createDate: Date
    
    func attente() -> String {
        let total: Int = delay - Int(-createDate.timeIntervalSinceNow)
        guard total > 0 else { return "00:00:00" }
        return heureBySeconds(total)
    }
    
    func heure() -> String {
        let date: Date = createDate.addingTimeInterval(TimeInterval(delay))
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: date)
    }
    
    private func heureBySeconds(_ total: Int) -> String {
        let heures: Int = total / 3600
        let reste: Int = total - (heures * 3600)
        let minutes: Int = reste / 60
        let secondes: Int = reste % 60
        let heuresString: String = heures < 10 ? "0\(heures)" : "\(heures)"
        let minutesString: String = minutes < 10 ? "0\(minutes)" : "\(minutes)"
        let secondesString: String = secondes < 10 ? "0\(secondes)" : "\(secondes)"
        return "\(heuresString):\(minutesString):\(secondesString)"
    }
}

struct PassageRer {
    let name: String
    let destination: String
    let infos: String
}

struct Passage {
    let bus: PassageBus?
    let rer: PassageRer?
    
    init(withBus bus: PassageBus) {
        self.bus = bus
        self.rer = nil
    }
    
    init(withRer rer: PassageRer) {
        self.bus = nil
        self.rer = rer
    }
}
