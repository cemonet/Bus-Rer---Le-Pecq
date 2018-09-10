//
//  API.swift
//  Bus Le Pecq
//
//  Created by EMONET Corentin on 05/09/2018.
//  Copyright © 2018 EMONET Corentin. All rights reserved.
//

import Foundation
import Alamofire

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
