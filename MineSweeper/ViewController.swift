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
    var firstMove = true
    
    var oneSecondTimer:NSTimer?
    
    func oneSecond() {
        secondCount++
        timeLabel.text = "Time: \(secondCount)"
    }
    
    func endCurrentGame() {
        if self.oneSecondTimer != nil {
            self.oneSecondTimer!.invalidate()
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
        self.resetBoardView()
        

    }
    
    func squareButtonPressed(sender: SquareButton) {
        if firstMove {
            self.oneSecondTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("oneSecond"), userInfo: nil, repeats: true)
            firstMove = false
        }
        println("Pressed row:\(sender.square.row), col:\(sender.square.column)")
        var setText = decideSquareButtonText(sender.square)
        switch setText {
        case "pressedAlredy":
            println(setText)
        case "M":
            minePressed();
        default:
            sender.setTitle(setText, forState: .Normal)
        }
    }
    
    func minePressed(){
        self.endCurrentGame()
        var alertView = UIAlertView()
        alertView.addButtonWithTitle("New Game")
        alertView.title = "OOPS."
        alertView.message = "You tapped on a mine."
        alertView.show()
        alertView.delegate = self
    }
    
    func alertView(View: UIAlertView!, clickedButtonAtIndex buttonIndex: Int) {
        //start new game when the alert is dismissed
        self.uiStartNewGame()
    }
    
    func decideSquareButtonText(square: Square) -> String {
        var returnText = ""
        if square.isRevealed {
            returnText = "pressedAlready"
        } else {
            movesCount++
            movesLabel.text = "Moves: \(movesCount)"
            square.isRevealed = true;
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

