//
//  ViewController.swift
//  MineSweeper
//
//  Created by YuenChung Lun on 14/5/15.
//  Copyright (c) 2015 ycl. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var boardView: UIView!
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    let boardSize:Int = 10
    var board:Board
    var squareButtons:[SquareButton] = []
    var movesCount = 0
    var secondCount = 0
    var numberOfMine = 0
    
    var oneSecondTimer:NSTimer?
    
    func oneSecond() {
        secondCount++
        timeLabel.text = "Time: \(secondCount)"
    }
    
    func endCurrentGame() {
        if self.oneSecondTimer != nil {
            self.oneSecondTimer?.invalidate()
            self.oneSecondTimer = nil
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        self.board = Board(size: boardSize)
        super.init(coder: aDecoder)
    }
    
    func initBoard() {
        for row in 0 ..< board.size {
            for column in 0 ..< board.size {
                let square = board.squares[row][column]
                println("\(square.isRevealed)")
                let squareSize:CGFloat = self.boardView.frame.width / CGFloat(boardSize)
                let squareButton = SquareButton(squareModel: square, squareSize: squareSize, squareMargin: 0)
                squareButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
                squareButton.addTarget(self, action: "squareButtonPressed:", forControlEvents: .TouchUpInside)
                self.boardView.addSubview(squareButton)
                self.squareButtons.append(squareButton)
            }
        }
    }
    
    func resetBoardView() {
        self.board.resetBoard()
        for squareButton in self.squareButtons {
            squareButton.setTitle("#", forState: .Normal)
        }
    }
    
    func uiStartNewGame() {
        println("UI reset called.")
        movesCount = 0
        movesLabel.text = "Moves: \(movesCount)"
        secondCount = 0
        timeLabel.text = "Time: \(secondCount)"
        numberOfMine = 0
        self.resetBoardView()
        self.countNumberOfMine(squareButtons)
    }
    
    func squareButtonPressed(sender: SquareButton) {
        sender.fingerPressed = true
        if sender.square.isPressed == false {
            movesCount++
            movesLabel.text = "Moves: \(movesCount)"
            println(movesCount)
            sender.square.isPressed = true
        }
        squareButtonTriggered(sender)
        if (movesCount == 1) {
            self.oneSecondTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("oneSecond"), userInfo: nil, repeats: true)
        }
    }
    
    func countNumberOfMine(squareButtons: [SquareButton]) {
        for i in squareButtons {
            if decideSquareButtonText(i.square) == "M" {
                numberOfMine++
            }
        }
    }
//    
//    func mineSafelyDiscovered(gestureRecognizer:UILongPressGestureRecognizer){
//        
//    }
    
    func checkAllRevealed(squareButtons: [SquareButton]) -> Bool {
        var isRevealedCount = 0
        for i in squareButtons {
            if i.square.isRevealed == true {
                isRevealedCount++
            }
        }
        if isRevealedCount == (board.size*board.size - numberOfMine) {
            return true
        } else {
            return false
        }
    }
    
    func squareButtonTriggered(sender: SquareButton) {
        var setText = decideSquareButtonText(sender.square)
        println("Pressed row:\(sender.square.row), col:\(sender.square.column)", "setText: '\(setText)'.")
        sender.square.isRevealed = true
        switch setText {
        case "revealedAlready":
            println("Pressed Already.")
        case "M":
            minePressed(sender);
        case "":
            sender.setTitle(setText, forState: .Normal)
            openWhiteSpace(sender.square)
        default:
            sender.setTitle(setText, forState: .Normal)
        }
        var allRevealed = checkAllRevealed(squareButtons)
        if allRevealed == true {
            var gameCompletedAlert = UIAlertView()
            gameCompletedAlert.addButtonWithTitle("New Game")
            gameCompletedAlert.title = "Congratulations!"
            gameCompletedAlert.message = "You've completed the game"
            gameCompletedAlert.show()
            gameCompletedAlert.delegate = self
        }
    }
    
    func openWhiteSpace(square: Square) {
        var neighbors = board.scanNeighbor(square, mode: "Four")
        for neighbor in neighbors {
            squareButtonTriggered(squareButtons[neighbor.row * boardSize + neighbor.column])
        }
    }
    
    func minePressed(sender: SquareButton) {
        if sender.fingerPressed {
            self.endCurrentGame()
            var alertView = UIAlertView()
            alertView.addButtonWithTitle("New Game")
            alertView.title = "OOPS."
            alertView.message = "You tapped on a mine."
            alertView.show()
            alertView.delegate = self
        } else {
            sender.square.isRevealed = false
        }
    }
    
    func alertView(View: UIAlertView!, clickedButtonAtIndex buttonIndex: Int) {
        //start new game when the alert is dismissed
        self.uiStartNewGame()
    }
    
    func decideSquareButtonText(square: Square) -> String {
        var returnText = ""
        if square.isRevealed {
            returnText = "revealedAlready"
        } else {
            if square.isMine {
                returnText = "M"
            } else {
                if square.minedNeighborCount > 0 {
                    returnText = "\(square.minedNeighborCount)"
                } else {
                    returnText = ""
                }
            }
        }
        return returnText
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.initBoard()
        self.uiStartNewGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func newGamePressed(){
        self.endCurrentGame()
        println("New Game.")
        self.uiStartNewGame()
    }
}

