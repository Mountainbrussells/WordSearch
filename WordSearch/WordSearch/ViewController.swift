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
    let puzzleColor = UIColor(colorLiteralRed: 120.0/255.0, green: 200.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    

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
                self.puzzleController = WSPuzzleController(puzzles:gridArray!)
                self.puzzleView.translatesAutoresizingMaskIntoConstraints = true
                self.puzzleController?.setUpPuzzle(puzzleNumber: 0, inView: self.puzzleView!, completion: { () -> Void in
                    DispatchQueue.main.async {
                        self.numberOfAnswersLabel.text = String(describing: self.puzzleController!.answersCount)
                        self.wordLabel.text = self.puzzleController?.puzzleWord
                    }})
            }
        }
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.puzzleController?.highLightTiles(touches: touches)
        super.touchesBegan(touches, with: event)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.puzzleController?.highLightTiles(touches: touches)
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.isUserInteractionEnabled = false
        checkAnswer()
    }
    
    func checkAnswer() {
        
        if (puzzleController?.answerIsCorrect())! {
            puzzleController?.lowerAnswersCountByOne()
            self.numberOfAnswersLabel.text = String(describing: puzzleController!.answersCount)
            
            puzzleController?.resetOrderNumber()
            if puzzleController?.answersCount == 0 {
                puzzleController?.addOneToPuzzleCounter()
                // check if there are more puzzles
                if (puzzleController?.isLastPuzzle())! {
                    lastPuzzleAlert()
                } else {
                    nextPuzzleAlert()
                }
            } else {
                correctAlert()
            }
        } else {
            wrongAlert()
        }
    }
    
    func correctAlert() {
        alertViewLabel.text = "That's right!"
        alertView.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.alertView.alpha = 1.0
        }) { (true) in
            UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseIn, animations: {
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
                self.puzzleController?.nextPuzzle {
                    DispatchQueue.main.async {
                        self.numberOfAnswersLabel.text = String(describing: self.puzzleController!.answersCount)
                        self.wordLabel.text = self.puzzleController?.puzzleWord
                        self.view.isUserInteractionEnabled = true
                    }
                }
            })
        }
    }
    
    func lastPuzzleAlert() {
        let alert = UIAlertController(title: "All done!", message: "Awesome!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Start Over", style: UIAlertActionStyle.default, handler: { action in
            self.puzzleController?.lastPuzzle {
                DispatchQueue.main.async {
                    self.numberOfAnswersLabel.text = String(describing: self.puzzleController!.answersCount)
                    self.wordLabel.text = self.puzzleController?.puzzleWord
                    self.view.isUserInteractionEnabled = true
                }
            }
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
                self.puzzleController?.wrongAnswer()
                self.view.isUserInteractionEnabled = true
            })
        }

        
    }
}

