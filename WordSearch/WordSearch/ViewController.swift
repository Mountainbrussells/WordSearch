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
    var puzzlesArray:Array<String> = []
    var puzzleCounter = 0
    var tilesArray:[WSTileView] = []

    @IBOutlet weak var puzzleView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        serviceController.downloadGrid { (gridArray, error) -> Void in
            if (error != nil) {
                
            } else {
                self.puzzlesArray = gridArray!
                self.puzzleView.translatesAutoresizingMaskIntoConstraints = true
                self.setUpPuzzle()
            }
        }
    }
    
    func getPuzzleArrayForString(_ puzzleString:String, completion: @escaping (_ gridWidth: Int?, _ gridHeigth: Int?, _ gridLetters:Array<Array<String>>?, _ error: Error?) -> Void){
        let puzzleData = puzzleString.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        do {
            let puzzleData = try JSONSerialization.jsonObject(with: puzzleData, options: []) as! [String: AnyObject]
            var returnArray = Array<Array<String>>()
            returnArray = puzzleData["character_grid"] as! Array<Array<String>>;
            let height = returnArray.count
            let firstArray = returnArray[0]
            let width = firstArray.count
            completion(width, height, returnArray, nil)
        } catch let error {
            completion(nil, nil, nil, error)
        }
    }
    
    func setUpPuzzle() {
        getPuzzleArrayForString(puzzlesArray[0]) { (width, height, puzzleArray, error) -> Void in
            if (error != nil) {
                
            } else {
                DispatchQueue.main.async {
                    let widthOfTiles = Double(self.puzzleView.frame.size.width) / Double(width!)
                    let heightOfTiles = Double(self.puzzleView.frame.size.height) / Double(height!)
                    var xPosition = 0.0
                    var yPosition = 0.0
                    for lineArray in puzzleArray! {
                        for tileLetter in lineArray {
                            let rect = CGRect(x: xPosition, y: yPosition, width: widthOfTiles, height: heightOfTiles)
                            let tile = WSTileView(rect, withString:tileLetter)
                            tile.translatesAutoresizingMaskIntoConstraints = true
                            self.puzzleView.addSubview(tile)
                            self.tilesArray.append(tile)
                            
                            let horizontalConstraint = NSLayoutConstraint(item: tile, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.puzzleView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: CGFloat(xPosition))
                            let verticalConstraint = NSLayoutConstraint(item: tile, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.puzzleView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: CGFloat(yPosition))
                            let widthConstraint = NSLayoutConstraint(item: tile, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: CGFloat(widthOfTiles))
                            let heightConstraint = NSLayoutConstraint(item: tile, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: CGFloat(heightOfTiles))
                            
                            self.puzzleView.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
                            
                            xPosition = xPosition + widthOfTiles
                        }
                        xPosition = 0.0
                        yPosition = yPosition + heightOfTiles
                    }
                    self.puzzleView.layoutSubviews()
                }
                
                
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.highLightTiles(touches: touches)
        super.touchesBegan(touches, with: event)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.highLightTiles(touches: touches)
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touches Ended")
        // TODO: stop touches until word check handled
        // TODO: Handle word check
        
    }
    
    func highLightTiles(touches: Set<NSObject>) {
        if let touch = touches.first as? UITouch {
            for tile in tilesArray {
                let point = touch.location(in: puzzleView)
                let xPosition = tile.frame.origin.x + tile.frame.size.width * 0.25
                let yPosition = tile.frame.origin.y + tile.frame.size.height * 0.25
                let width = tile.frame.size.width / 2.0
                let height = tile.frame.size.height / 2.0
                let rect = CGRect(x: xPosition, y: yPosition, width: width, height: height)
                if (rect.contains(point)) {
                    tile.backgroundColor = UIColor.white
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

