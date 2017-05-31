//
//  WSPuzzleController.swift
//  WordSearch
//
//  Created by BenRussell on 5/31/17.
//  Copyright © 2017 BenRussell. All rights reserved.
//

import Foundation
import UIKit

class WSPuzzleController: NSObject {
    
    var puzzlesArray: Array<String> = []
    var puzzleCounter = 0
    var tilesArray: [WSTileView] = []
    var answersArray: Array<String> = []
    var answersCount = 0
    var choosenTilesSet: Set<WSTileView> = []
    var orderNumber = 0
    var puzzleWord:String?
    var tileFontSize:CGFloat = 0.0
    var puzzleView:UIView?
    
    init(withArray array:Array<String>) {
        super.init()
        self.puzzlesArray = array
    }
    
    func getPuzzleInfoForString(_ puzzleString:String, completion: @escaping (_ gridWidth: Int?, _ gridHeigth: Int?, _ startWord: String?, _ answers: Array<String>?, _ gridLetters:Array<Array<String>>?, _ error: Error?) -> Void){
        let puzzleData = puzzleString.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        do {
            let puzzleData = try JSONSerialization.jsonObject(with: puzzleData, options: []) as! [String: AnyObject]
            // get grid
            var gridLetters = Array<Array<String>>()
            gridLetters = puzzleData["character_grid"] as! Array<Array<String>>;
            // get height
            let height = gridLetters.count
            // get width
            let firstArray = gridLetters[0]
            let width = firstArray.count
            // get startWord
            let startWord = puzzleData["word"] as! String
            // get answers
            let answerDict = puzzleData["word_locations"] as! [String: String]
            var answerArray: Array<String> = []
            for (_, word) in answerDict {
                answerArray.append(word)
            }
            self.answersCount = answersArray.count
            
            completion(width, height, startWord, answerArray, gridLetters, nil)
        } catch let error {
            completion(nil, nil, nil, nil, nil, error)
        }
    }
    
    func setUpPuzzle(puzzleNumber:Int, inView view:UIView, completion:@escaping () -> Void) {
        getPuzzleInfoForString(puzzlesArray[puzzleNumber]) { (width, height, startWord, answers, puzzleArray, error) -> Void in
            if (error != nil) {
                
            } else {
                DispatchQueue.main.async {
                    self.puzzleView = view
                    // set word
                    self.puzzleWord = startWord!
                    // set answers
                    self.answersArray = answers!
                    self.answersCount = self.answersArray.count
                    
                    // Clear puzzle
                    view.subviews.forEach({ $0.removeFromSuperview() })
                    self.tilesArray = []
                    
                    //set tiles
                    let widthOfTiles = Double(view.frame.size.width) / Double(width!)
                    let heightOfTiles = Double(view.frame.size.height) / Double(height!)
                    var xPosition = 0.0
                    var yPosition = 0.0
                    for lineArray in puzzleArray! {
                        for tileLetter in lineArray {
                            let rect = CGRect(x: xPosition, y: yPosition, width: widthOfTiles, height: heightOfTiles)
                            let tile = WSTileView(rect, withString:tileLetter)
                            tile.translatesAutoresizingMaskIntoConstraints = true
                            view.addSubview(tile)
                            self.tilesArray.append(tile)
                            
                            //                            let horizontalConstraint = NSLayoutConstraint(item: tile, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.puzzleView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: CGFloat(xPosition))
                            //                            let verticalConstraint = NSLayoutConstraint(item: tile, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.puzzleView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: CGFloat(yPosition))
                            //                            let widthConstraint = NSLayoutConstraint(item: tile, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: CGFloat(widthOfTiles))
                            //                            let heightConstraint = NSLayoutConstraint(item: tile, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: CGFloat(heightOfTiles))
                            //
                            //                            self.puzzleView.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
                            self.tileFontSize = tile.font.pointSize
                            xPosition = xPosition + widthOfTiles
                        }
                        xPosition = 0.0
                        yPosition = yPosition + heightOfTiles
                    }
                    view.layoutSubviews()
                    completion()
                }
                
                
            }
        }
    }
    
    func highLightTiles(touches: Set<NSObject>) {
        if let touch = touches.first as? UITouch {
            for tile in tilesArray {
                let point = touch.location(in: puzzleView!)
                let xPosition = tile.frame.origin.x + tile.frame.size.width * 0.25
                let yPosition = tile.frame.origin.y + tile.frame.size.height * 0.25
                let width = tile.frame.size.width / 2.0
                let height = tile.frame.size.height / 2.0
                let rect = CGRect(x: xPosition, y: yPosition, width: width, height: height)
                if (rect.contains(point)) {
                    tile.font = tile.font.withSize(tileFontSize + 20.0)
                    tile.sortNumber = orderNumber
                    orderNumber = orderNumber + 1
                    choosenTilesSet.insert(tile)
                }
            }
        }
    }
    
    func unhighlightChosenTiles() {
        for tile in self.choosenTilesSet {
            tile.font = tile.font.withSize(self.tileFontSize)
        }

    }

    func answerIsCorrect() -> Bool {
        var isCorrect = false
        // Get highlighted word
        var tileArray: Array<WSTileView> = []
        for tile in choosenTilesSet {
            tileArray.append(tile)
        }
        tileArray.sort {
            $0.sortNumber! < $1.sortNumber!
        }
        var choosenWord = ""
        for tile in tileArray {
            choosenWord.append(tile.text!)
        }
        
        // check word against examples
        for word in answersArray {
            if (choosenWord == word) {
                isCorrect = true
            }
        }
        return isCorrect
    }
    
    func resetChoosenTiles() {
        choosenTilesSet = []
    }
    
    func resetOrderNumber() {
        orderNumber = 0
    }
    
    func resetPuzzleCounter() {
        puzzleCounter = 0
    }
    
    func lowerAnswersCountByOne() {
        answersCount = answersCount - 1
    }
    
    func addOneToPuzzleCounter() {
        puzzleCounter = puzzleCounter + 1
    }
    
    
}
