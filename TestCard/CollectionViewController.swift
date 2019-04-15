//
//  CollectionViewController.swift
//  TestCard
//
//  Created by Nathaniel Putera on 22/03/19.
//  Copyright © 2019 Nathaniel Putera. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var cards: [Card] = []
    var initArray: [String] = ["aceSpades", "aceSpades","kingHeart","kingHeart","queenClubs","queenClubs","jackDiamond","jackDiamond","tenSpades","tenSpades","nineHeart","nineHeart"]
    var cardOpen: Int = 0
    var move: Int = 0
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
       
        if cards[indexPath.row].isOpen == false && cards[indexPath.row].hasPair == false {
            cards[indexPath.row].isOpen = true
            
            let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
            
            cell.imageView.image = UIImage(named: "\(cards[indexPath.row].name)")
            
            UIView.transition(with: cell.imageView, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        
            cards[indexPath.row].isOpen = true
            
            cardOpen += 1
            checkSame(cards: cards, indexPath: indexPath)
            
        } else if cards[indexPath.row].isOpen == true {
            print("dah pernah")
        }
        
        if cardOpen > 1 {
            move += 1
            headerView?.title.text = "move \(move)"
            changeBack(cards: cards)
            cardOpen = 0
        }
        
        var count = 0
        for c in cards {
            if c.hasPair == true {
                count += 1
            }
        }
        if count == 12 {
            let alert = UIAlertController(title: "Finish", message: "You have finished the game" , preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
                self.navigationController?.popToRootViewController(animated: true)
            }
            
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func changeBack(cards: [Card]) {
        let temp = collectionView.indexPathsForVisibleItems
        for e in cards.enumerated() {
            let c = e.element
            if c.isOpen == true && c.hasPair == false {
                c.isOpen = false
                if temp.compactMap({ return $0.row }).contains(e.offset) {
                    let cell = collectionView.cellForItem(at: IndexPath(item: e.offset, section: 0)) as! CollectionViewCell
                    collectionView.isUserInteractionEnabled = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1 , execute: {() -> Void in
                        cell.imageView.image = UIImage(named: "back")
                        UIView.transition(with: cell.imageView, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: { success in
                            self.collectionView.reloadData()
                        })
                        self.collectionView.isUserInteractionEnabled = true
                    })
                }
            }
        }
    }
    
    func checkSame(cards: [Card], indexPath: IndexPath) {
        
        for c in 0..<cards.count {
            if cards[indexPath.row].name == cards[c].name && c != indexPath.row && cards[c].isOpen == true {
                cards[c].hasPair = true
                cards[indexPath.row].hasPair = true
            }
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    weak var headerView: CollectionReusableView?
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath)
//        guard let reusable = header as? CollectionReusableView else {
//            return header
//        }
        headerView = header as? CollectionReusableView
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)
    }
    
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }
 

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        
    }
 */
 
    

}
