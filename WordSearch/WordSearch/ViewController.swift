//
//  ViewController.swift
//  WordSearch
//
//  Created by BenRussell on 5/25/17.
//  Copyright © 2017 BenRussell. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let serviceController = WSServiceController()
    var puzzleController:WSPuzzleController?
    var puzzlesArray: Array<String> = []
    var puzzleCounter = 0
    var tilesArray: [WSTileView] = []
    var answersArray: Array<String> = []
    var answersCount = 0
    var choosenTilesSet: Set<WSTileView> = []
    var orderNumber = 0
    let puzzleColor = UIColor(colorLiteralRed: 120.0/255.0, green: 200.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    var tileFontSize:CGFloat = 0.0
    

    @IBOutlet weak var alertViewLabel: UILabel!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var puzzleView: UIView!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var numberOfAnswersLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertView.isHidden = true
        alertView.alpha = 0.0
        alertView.layer.cornerRadius = 10.0
        alertView.clipsToBounds = true
        puzzleView.backgroundColor = self.puzzleColor
        puzzleView.layer.cornerRadius = 10
        puzzleView.clipsToBounds = true

        serviceController.downloadGrid { (gridArray, error) -> Void in
            if (error != nil) {
                
            } else {
                self.puzzleController = WSPuzzleController(withArray:gridArray!)
                self.puzzleView.translatesAutoresizingMaskIntoConstraints = true
                self.puzzleController?.setUpPuzzle(puzzleNumber: 0, inView: self.puzzleView!, completion: { () -> Void in
                    DispatchQueue.main.async {
                        self.numberOfAnswersLabel.text = String(describing: self.puzzleController!.answersCount)
                        self.wordLabel.text = self.puzzleController?.puzzleWord
                    }})
            }
        }
    }
    
//    func getPuzzleArrayForString(_ puzzleString:String, completion: @escaping (_ gridWidth: Int?, _ gridHeigth: Int?, _ startWord: String?, _ answers: Array<String>?, _ gridLetters:Array<Array<String>>?, _ error: Error?) -> Void){
//        let puzzleData = puzzleString.data(using: String.Encoding.utf8, allowLossyConversion: false)!
//        do {
//            let puzzleData = try JSONSerialization.jsonObject(with: puzzleData, options: []) as! [String: AnyObject]
//            // get grid
//            var gridLetters = Array<Array<String>>()
//            gridLetters = puzzleData["character_grid"] as! Array<Array<String>>;
//            // get height
//            let height = gridLetters.count
//            // get width
//            let firstArray = gridLetters[0]
//            let width = firstArray.count
//            // get startWord
//            let startWord = puzzleData["word"] as! String
//            // get answers
//            let answerDict = puzzleData["word_locations"] as! [String: String]
//            var answerArray: Array<String> = []
//            for (locations, word) in answerDict {
//                answerArray.append(word)
//            }
//            self.answersCount = answersArray.count
//            
//            completion(width, height, startWord, answerArray, gridLetters, nil)
//        } catch let error {
//            completion(nil, nil, nil, nil, nil, error)
//        }
//    }
//    
//    func setUpPuzzle(_ puzzleNumber:Int) {
//        getPuzzleArrayForString(puzzlesArray[puzzleNumber]) { (width, height, startWord, answers, puzzleArray, error) -> Void in
//            if (error != nil) {
//                
//            } else {
//                DispatchQueue.main.async {
//                    // set word
//                    self.wordLabel.text = startWord!
//                    // set answers
//                    self.answersArray = answers!
//                    self.answersCount = self.answersArray.count
//                    self.numberOfAnswersLabel.text = String(self.answersCount)
//                    
//                    // Clear puzzle 
//                    self.puzzleView.subviews.forEach({ $0.removeFromSuperview() })
//                    self.tilesArray = []
//                    
//                    //set tiles
//                    let widthOfTiles = Double(self.puzzleView.frame.size.width) / Double(width!)
//                    let heightOfTiles = Double(self.puzzleView.frame.size.height) / Double(height!)
//                    var xPosition = 0.0
//                    var yPosition = 0.0
//                    for lineArray in puzzleArray! {
//                        for tileLetter in lineArray {
//                            let rect = CGRect(x: xPosition, y: yPosition, width: widthOfTiles, height: heightOfTiles)
//                            let tile = WSTileView(rect, withString:tileLetter)
//                            tile.translatesAutoresizingMaskIntoConstraints = true
//                            self.puzzleView.addSubview(tile)
//                            self.tilesArray.append(tile)
//                            
////                            let horizontalConstraint = NSLayoutConstraint(item: tile, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.puzzleView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: CGFloat(xPosition))
////                            let verticalConstraint = NSLayoutConstraint(item: tile, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.puzzleView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: CGFloat(yPosition))
////                            let widthConstraint = NSLayoutConstraint(item: tile, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: CGFloat(widthOfTiles))
////                            let heightConstraint = NSLayoutConstraint(item: tile, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: CGFloat(heightOfTiles))
////                            
////                            self.puzzleView.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
//                            self.tileFontSize = tile.font.pointSize
//                            xPosition = xPosition + widthOfTiles
//                        }
//                        xPosition = 0.0
//                        yPosition = yPosition + heightOfTiles
//                    }
//                    self.puzzleView.layoutSubviews()
//                }
//                
//                
//            }
//        }
//    }
//    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.puzzleController?.highLightTiles(touches: touches)
        super.touchesBegan(touches, with: event)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.puzzleController?.highLightTiles(touches: touches)
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touches Ended")
        // TODO: stop touches until word check handled
        view.isUserInteractionEnabled = false
        // TODO: Handle word check
        checkAnswer()
    }
//
//    func highLightTiles(touches: Set<NSObject>) {
//        if let touch = touches.first as? UITouch {
//            for tile in tilesArray {
//                let point = touch.location(in: puzzleView)
//                let xPosition = tile.frame.origin.x + tile.frame.size.width * 0.25
//                let yPosition = tile.frame.origin.y + tile.frame.size.height * 0.25
//                let width = tile.frame.size.width / 2.0
//                let height = tile.frame.size.height / 2.0
//                let rect = CGRect(x: xPosition, y: yPosition, width: width, height: height)
//                if (rect.contains(point)) {
//                    tile.font = tile.font.withSize(tileFontSize + 20.0)
//                    tile.sortNumber = orderNumber
//                    orderNumber = orderNumber + 1
//                    choosenTilesSet.insert(tile)
//                }
//            }
//        }
//    }
    
    func checkAnswer() {
//        var isCorrect = false
//        // Get highlighted word
//        var tileArray: Array<WSTileView> = []
//        for tile in choosenTilesSet {
//            tileArray.append(tile)
//        }
//        tileArray.sort {
//            $0.sortNumber! < $1.sortNumber!
//        }
//        var choosenWord = ""
//        for tile in tileArray {
//            choosenWord.append(tile.text!)
//        }
//        
//        // check word against examples
//        for word in answersArray {
//            if (choosenWord == word) {
//                isCorrect = true
//            }
//        }
        
        if (puzzleController?.answerIsCorrect())! {
            puzzleController?.lowerAnswersCountByOne()
            self.numberOfAnswersLabel.text = String(describing: puzzleController!.answersCount)
            
            puzzleController?.resetOrderNumber()
            if puzzleController?.answersCount == 0 {
                puzzleController?.addOneToPuzzleCounter()
                // check if there are more puzzles
                if (puzzleController?.puzzleCounter)! + 1 > (puzzleController?.puzzlesArray.count)! {
                    lastPuzzleAlert()
                } else {
                    nextPuzzleAlert()
                }
            } else {
                correctAlert()
            }
            

        } else {
            print("Aswer Is False")
            orderNumber = 0
            wrongAlert()
        }
    
    }
    
    func correctAlert() {
        alertViewLabel.text = "That's right!"
        alertView.isHidden = false
        UIView.animate(withDuration: 1.0, animations: { 
            self.alertView.alpha = 1.0
        }) { (true) in
            UIView.animate(withDuration: 1.0, delay: 0.5, options: .curveEaseIn, animations: { 
                self.alertView.alpha = 0.0
            }, completion: { (true) in
                // Empty choosen tiles
                self.puzzleController?.resetChoosenTiles()
                self.view.isUserInteractionEnabled = true
            })
        }
        
    }
    
    func nextPuzzleAlert() {
        alertViewLabel.text = "Correct, \n Next word!"
        alertView.isHidden = false
        UIView.animate(withDuration: 1.0, animations: {
            self.alertView.alpha = 1.0
        }) { (true) in
            UIView.animate(withDuration: 1.0, delay: 0.5, options: .curveEaseIn, animations: {
                self.alertView.alpha = 0.0
            }, completion: { (true) in
                DispatchQueue.main.async {
                    self.alertView.isHidden = true
                }
                self.puzzleController?.resetChoosenTiles()
                self.puzzleController?.setUpPuzzle(puzzleNumber: (self.puzzleController?.puzzleCounter)!, inView: self.puzzleView, completion: { () -> Void in
                    DispatchQueue.main.async {
                        self.numberOfAnswersLabel.text = String(describing: self.puzzleController!.answersCount)
                        self.wordLabel.text = self.puzzleController?.puzzleWord
                        self.view.isUserInteractionEnabled = true
                    }
                })
            })
        }
        
    }
    
    func lastPuzzleAlert() {
        let alert = UIAlertController(title: "All done!", message: "Awesome!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Start Over", style: UIAlertActionStyle.default, handler: { action in
            self.puzzleController?.resetPuzzleCounter()
            self.puzzleController?.resetChoosenTiles()
            self.puzzleController?.setUpPuzzle(puzzleNumber: (self.puzzleController?.puzzleCounter)!, inView: self.puzzleView, completion: { () -> Void in
                DispatchQueue.main.async {
                    self.numberOfAnswersLabel.text = String(describing: self.puzzleController!.answersCount)
                    self.wordLabel.text = self.puzzleController?.puzzleWord
                    self.view.isUserInteractionEnabled = true
                }
            })
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func wrongAlert() {
        alertViewLabel.text = "Try again"
        alertView.isHidden = false
        UIView.animate(withDuration: 1.0, animations: {
            self.alertView.alpha = 1.0
        }) { (true) in
            UIView.animate(withDuration: 1.0, delay: 0.5, options: .curveEaseIn, animations: {
                self.alertView.alpha = 0.0
            }, completion: { (true) in
                self.puzzleController?.unhighlightChosenTiles()
                // Empty choosen tiles
                self.puzzleController?.resetChoosenTiles()
                self.puzzleController?.resetOrderNumber()
                self.view.isUserInteractionEnabled = true
            })
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

