//
//  Itineraire.swift
//  Bus Le Pecq
//
//  Created by EMONET Corentin on 10/09/2018.
//  Copyright © 2018 EMONET Corentin. All rights reserved.
//

import Foundation

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
