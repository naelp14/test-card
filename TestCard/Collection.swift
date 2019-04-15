//
//  Collection.swift
//  TestCard
//
//  Created by Nathaniel Putera on 26/03/19.
//  Copyright © 2019 Nathaniel Putera. All rights reserved.
//

import Foundation
import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var cards: [Card] = []
    var initArray: [String] = ["aceSpades", "aceSpades","kingHeart","kingHeart","queenClubs","queenClubs","jackDiamond","jackDiamond","tenSpades","tenSpades","nineHeart","nineHeart"]
    var cardOpen: Int = 0
    var showingBack: Bool = false
    var frontImageView: UIImageView! = UIImageView(image: UIImage(named: "white"))
    var backImageView: UIImageView! = UIImageView(image: UIImage(named: "back"))
    let backCardImage = UIImage(named: "back")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initArray.shuffle()
        
        var temp: CardType
        
        for i in 0 ..< initArray.count {
            switch initArray[i] {
            case "aceSpades": temp = .aceSpades
            case "kingHeart": temp = .kingHeart
            case "queenClubs": temp = .queenClubs
            case "jackDiamond": temp = .jackDiamond
            case "tenSpades": temp = .tenSpades
            case "nineHeart": temp = .nineHeart
            default: temp = .aceSpades
            }
            
            let card = Card(type: temp)
            card.index = [0, i]
            cards.append(card)
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 12
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        let card = cards[indexPath.row]
        if card.isOpen {
            cell.imageView.image = card.type.image
        } else {
            cell.imageView.image = backCardImage
            
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.row) --- \(cards[indexPath.row].index?.row)")
        if cardOpen > 1 {
            changeBack(cards: cards)
            cardOpen = 0
        }
        
        if cards[indexPath.row].isOpen == false && cards[indexPath.row].hasPair == false {
            cards[indexPath.row].isOpen = true
            
            let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell
            
            cell?.imageView.image = UIImage(named: "\(cards[indexPath.row].name)")
            
            if let cell = cell{
                UIView.transition(with: cell.imageView, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            }
            cards[indexPath.row].isOpen = true
            
            cardOpen += 1
            checkSame(cards: cards, indexPath: indexPath)
            
        } else if cards[indexPath.row].isOpen == true {
            print("dah pernah")
        }
    }
    
    func changeBack(cards: [Card]) {
        let temp = collectionView.indexPathsForVisibleItems
        for c in cards {
            if c.isOpen == true && c.hasPair == false {
                c.isOpen = false
                let cell = collectionView.cellForItem(at: c.index!) as! CollectionViewCell
                cell.imageView.image = UIImage(named: "back")
                UIView.transition(with: cell.imageView, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            }
        }
    }
    
    func checkSame(cards: [Card], indexPath: IndexPath) {
        
        for c in cards {
            if cards[indexPath.row].name == c.name && cards[indexPath.row].index != c.index && c.isOpen == true {
                c.hasPair = true
                cards[indexPath.row].hasPair = true
            }
        }
    }
        
}
