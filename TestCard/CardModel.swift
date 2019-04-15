//
//  CardModel.swift
//  TestCard
//
//  Created by Nathaniel Putera on 22/03/19.
//  Copyright © 2019 Nathaniel Putera. All rights reserved.
//

import Foundation
import UIKit

enum CardType: CaseIterable {
    case aceSpades
    case kingHeart
    case queenClubs
    case jackDiamond
    case tenSpades
    case nineHeart
    
    var imageName: String {
        switch self {
        case .aceSpades: return "aceSpades"
        case .kingHeart: return "kingHeart"
        case .queenClubs: return "queenClubs"
        case .jackDiamond: return "jackDiamond"
        case .tenSpades: return "tenSpades"
        case .nineHeart: return "nineHeart"
        }
    }
    
    var image: UIImage? {
        return UIImage(named: imageName)
    }
}

class Card {
    let type: CardType
    var name: String = ""
    var isOpen: Bool = false
    var hasPair: Bool = false
    
//    func aa() {
//        let type: CardType = .kingHeart
//        type.image
//        CardType.allCases 
//    }
    
    var currentImageName: String {
        return isOpen ? type.imageName : "back"
    }
    
    init(type: CardType) {
        self.type = type
        name = type.imageName
    }
   
}
