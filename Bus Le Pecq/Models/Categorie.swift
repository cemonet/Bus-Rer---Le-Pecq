//
//  Categorie.swift
//  Bus Le Pecq
//
//  Created by EMONET Corentin on 10/09/2018.
//  Copyright © 2018 EMONET Corentin. All rights reserved.
//

import Foundation

enum Categorie {
    case paris
    case cergy
    case rer
    
    var name: String {
        switch self {
        case .paris: return "Paris"
        case .cergy: return "Cergy"
        case .rer: return "RER"
        }
    }
    
    var itineraires: [Itineraire] {
        switch self {
        case .paris:
            return [
                .brossoletteAller,
                .vesinetLePecqRetour
            ]
        case .cergy:
            return [
                .saintGermainEnlayeAller,
                .cergyPrefectureRetour,
                .neuvilleUniversiteRetour
            ]
        case .rer:
            return [
                .vesinetLePecqAllerRer,
                .saintGermainEnLayeAllerRer,
                .gareDeLyonRetourRer
            ]
        }
    }
}
