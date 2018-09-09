//
//  API.swift
//  Bus Le Pecq
//
//  Created by EMONET Corentin on 05/09/2018.
//  Copyright © 2018 EMONET Corentin. All rights reserved.
//

import Foundation
import Alamofire

enum Direction: String {
    case aller = "nextbus-aller"
    case retour = "nextbus-retour"
}

enum Station: String {
    case brossolette = "50012195"
    case vesinetLePecq = "50012502"
    case saintGermainEnLayeTiers = "50018116"
    case cergyPrefecture = "50008377"
    case neuvilleUniversite = "50018230"
    
    case vesinetLePecqRer = "Le+Vesinet-Le+Pecq"
    case saintGermainEnLayeRer = "Saint-Germain-en-Laye"
    case gareDeLyonRer = "Gare+de+Lyon"
}

enum Destination: String {
    case boissyMlv = "Boissy-St-Léger / Marne-la-Vallée"
    case saintGermainEnLaye = "St-Germain-en-Laye / Poissy / Cergy"
}

enum Line: String {
    case bus21 = "21"
    case bus27 = "27"
    case rerA = "A"
}

enum Transport {
    case bus
    case rer
}

enum Itineraire {
    case brossoletteAller
    case vesinetLePecqRetour
    case saintGermainEnlayeAller
    case cergyPrefectureRetour
    case neuvilleUniversiteRetour
    case vesinetLePecqAllerRer
    case saintGermainEnLayeAllerRer
    case gareDeLyonRetourRer
    
    var name: String {
        switch self {
        case .brossoletteAller: return "Aller (Brossolette)"
        case .vesinetLePecqRetour: return "Retour (Vesinet Le Pecq)"
        case .saintGermainEnlayeAller: return "Aller (Saint Germain En Laye)"
        case .cergyPrefectureRetour: return "Retour (Cergy Prefecture)"
        case .neuvilleUniversiteRetour: return "Retour (Neuville Université)"
        case .vesinetLePecqAllerRer: return "Aller (Vesinet Le Pecq)"
        case .saintGermainEnLayeAllerRer: return "Aller (Saint Germain En Laye)"
        case .gareDeLyonRetourRer: return "Retour (Gare De Lyon)"
        }
    }
    
    var transport: Transport {
        switch self {
        case .brossoletteAller: return .bus
        case .vesinetLePecqRetour: return .bus
        case .saintGermainEnlayeAller: return .bus
        case .cergyPrefectureRetour: return .bus
        case .neuvilleUniversiteRetour: return .bus
        case .vesinetLePecqAllerRer: return .rer
        case .saintGermainEnLayeAllerRer: return .rer
        case .gareDeLyonRetourRer: return .rer
        }
    }
    
    var direction: Direction? {
        switch self {
        case .brossoletteAller: return .aller
        case .vesinetLePecqRetour: return .retour
        case .saintGermainEnlayeAller: return .aller
        case .cergyPrefectureRetour: return .retour
        case .neuvilleUniversiteRetour: return .retour
        case .vesinetLePecqAllerRer: return nil
        case .saintGermainEnLayeAllerRer: return nil
        case .gareDeLyonRetourRer: return nil
        }
    }
    
    var line: Line {
        switch self {
        case .brossoletteAller: return .bus21
        case .vesinetLePecqRetour: return .bus21
        case .saintGermainEnlayeAller: return .bus27
        case .cergyPrefectureRetour: return .bus27
        case .neuvilleUniversiteRetour: return .bus27
        case .vesinetLePecqAllerRer: return .rerA
        case .saintGermainEnLayeAllerRer: return .rerA
        case .gareDeLyonRetourRer: return .rerA
        }
    }
    
    var station: Station {
        switch self {
        case .brossoletteAller: return .brossolette
        case .vesinetLePecqRetour: return .vesinetLePecq
        case .saintGermainEnlayeAller: return .saintGermainEnLayeTiers
        case .cergyPrefectureRetour: return .cergyPrefecture
        case .neuvilleUniversiteRetour: return .neuvilleUniversite
        case .vesinetLePecqAllerRer: return .vesinetLePecqRer
        case .saintGermainEnLayeAllerRer: return .saintGermainEnLayeRer
        case .gareDeLyonRetourRer: return .gareDeLyonRer
        }
    }
    
    var destination: Station? {
        switch self {
        case .brossoletteAller: return .vesinetLePecq
        case .vesinetLePecqRetour: return .brossolette
        case .saintGermainEnlayeAller: return .neuvilleUniversite
        case .cergyPrefectureRetour: return .saintGermainEnLayeTiers
        case .neuvilleUniversiteRetour: return .saintGermainEnLayeTiers
        case .vesinetLePecqAllerRer: return nil
        case .saintGermainEnLayeAllerRer: return nil
        case .gareDeLyonRetourRer: return nil
        }
    }
    
    var destinationRer: Destination? {
        switch self {
        case .brossoletteAller: return nil
        case .vesinetLePecqRetour: return nil
        case .saintGermainEnlayeAller: return nil
        case .cergyPrefectureRetour: return nil
        case .neuvilleUniversiteRetour: return nil
        case .vesinetLePecqAllerRer: return .boissyMlv
        case .saintGermainEnLayeAllerRer: return .boissyMlv
        case .gareDeLyonRetourRer: return .saintGermainEnLaye
        }
    }
}

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

final class API: NSObject {
    static let shared: API = API()
    
    func passages(for itineraire: Itineraire, completion: @escaping (Bool, [Passage]) -> Void) {
        switch itineraire.transport {
        case .bus:
            let url: String = buildBusURL(for: itineraire)
            URLCache.shared.removeAllCachedResponses()
            Alamofire.request(url).responseJSON { [weak self] response in
                guard let strongSelf = self else { return completion(false, []) }
                guard let value = response.value else { return completion(false, []) }
                guard let passages = strongSelf.passagesBus(from: value) else { return completion(false, []) }
                
                completion(true, passages.filter({ $0.bus?.line ?? "" == itineraire.line.rawValue }))
            }
        case .rer:
            fetchRer(for: itineraire, completion: completion)
        }
    }
    
    func urlBus(for itineraire: Itineraire) -> String {
        return "https://www.transdev-idf.com/schedule/\(itineraire.station.rawValue)/012/ESF/\(itineraire.line.rawValue)/\(itineraire.destination?.rawValue ?? "")"
    }
    
    private func buildBusURL(for itineraire: Itineraire) -> String {
        return "https://www.transdev-idf.com/ajax/station/\(itineraire.station.rawValue)/\(itineraire.direction?.rawValue ?? "")"
    }
    
    private func passagesBus(from response: Any) -> [Passage]? {
        guard let passagesDic = response as? [[String: Any]] else { return nil }
        
        var passages: [Passage] = []
        for passageDic in passagesDic {
            let delay: Int = passageDic["delay"] as? Int ?? 0
            let line: String = passageDic["line"] as? String ?? ""
            let source: String = passageDic["source"] as? String ?? ""
            let isRT: Bool = source == "INEO_RT"
            
            passages.append(Passage(withBus: PassageBus(delay: delay, line: line, isRT: isRT, createDate: Date())))
        }
        return passages
    }
    
    private func fetchRer(for itineraire: Itineraire, completion: @escaping (Bool, [Passage]) -> Void) {
        let line: String = itineraire.line.rawValue
        let station: String = itineraire.station.rawValue
        let url: String = "https://www.ratp.fr/horaires?network-current=rer&networks=rer&line_rer=\(line)&stop_point_rer=\(station)&type=now&op=Rechercher"
        
        URLCache.shared.removeAllCachedResponses()
        Alamofire.request(url).response { response in
            guard let data = response.data else { return completion(false, []) }
            guard let html = String(data: data, encoding: String.Encoding.utf8) else { return completion(false, []) }
            
            var directionsComponents: [String] = html.components(separatedBy: "<div class=\"network-directions\"><strong class=\"directions\">")
            guard directionsComponents.count > 1 else { return completion(false, []) }
            
            directionsComponents.removeFirst()
            
            for direction in directionsComponents {
                let directionNameComponents: [String] = direction.components(separatedBy: "</strong></div>")
                guard directionNameComponents.count > 1 else { continue }
                guard let directionName = directionNameComponents.first else { continue }
                guard directionName == itineraire.destinationRer?.rawValue ?? "" else { continue }
                
                var passagesComponents: [String] = direction.components(separatedBy: "<li class=\"body-rer\">")
                guard passagesComponents.count > 1 else { continue }
                
                passagesComponents.removeFirst()
                
                var passages: [Passage] = []
                
                for passage in passagesComponents {
                    var passageNameComponents: [String] = passage.components(separatedBy: "class=\"js-horaire-show-mission\">")
                    guard passageNameComponents.count > 1 else { continue }
                    
                    passageNameComponents.removeFirst()
                    guard let passageNameStart = passageNameComponents.first else { continue }
                    
                    let passageNameComponents2: [String] = passageNameStart.components(separatedBy: "</a>")
                    guard passageNameComponents2.count > 1 else { continue }
                    guard let passageName = passageNameComponents2.first?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) else { continue }
                    
                    var passageDestinationComponents: [String] = passage.components(separatedBy: "<span class=\"terminus-wrap\">")
                    guard passageDestinationComponents.count > 1 else { continue }
                    
                    passageDestinationComponents.removeFirst()
                    guard let passageDestinationStart = passageDestinationComponents.first else { continue }
                    
                    let passageDestinationComponents2: [String] = passageDestinationStart.components(separatedBy: "</span>")
                    guard passageDestinationComponents2.count > 1 else { continue }
                    guard let passageDestination = passageDestinationComponents2.first?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) else { continue }
                    
                    var passageHeureComponents: [String] = passage.components(separatedBy: "<span class=\"heure-wrap heure-wrap-long\">")
                    guard passageHeureComponents.count > 1 else { continue }
                    
                    passageHeureComponents.removeFirst()
                    guard let passageHeureStart = passageHeureComponents.first else { continue }
                    
                    let passageHeureComponents2: [String] = passageHeureStart.components(separatedBy: "</span>")
                    guard passageHeureComponents2.count > 1 else { continue }
                    guard let passageHeure = passageHeureComponents2.first?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) else { continue }
                    
                    passages.append(Passage(withRer: PassageRer(name: passageName, destination: passageDestination, infos: passageHeure)))
                }
                completion(true, passages)
            }
        }
    }
}
