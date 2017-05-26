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
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.orientationDidChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)

       
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
    
    func orientationDidChange() {
       
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        self.view.layoutIfNeeded()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touches began")
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touches moved")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touches Ended")
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        // Don't forget to add "?" after Set<UITouch>
        print("touches cancelled")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

