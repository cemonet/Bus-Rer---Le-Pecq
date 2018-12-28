//
//  TransportModels.swift
//  Bus Le Pecq
//
//  Created by EMONET Corentin on 10/09/2018.
//  Copyright © 2018 EMONET Corentin. All rights reserved.
//

import Foundation

enum Direction: String {
    case aller = "nextbus-aller"
    case retour = "nextbus-retour"
}

enum Station: String {
    case brossolette = "50012195"
    case vesinetLePecq = "50012502"
    case republique = "50012435"
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
