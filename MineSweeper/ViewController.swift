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
                squareButton.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
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
        self.resetBoardView()
    }
    
    func squareButtonPressed(sender: SquareButton) {
        println("Pressed row:\(sender.square.row), col:\(sender.square.column)")
//        sender.setTitle("", forState: .Normal)
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
        println("New Game.")
        self.uiStartNewGame()
    }


}

