//
//  SquareButtons.swift
//  MineSweeper
//
//  Created by YuenChung Lun on 15/5/15.
//  Copyright (c) 2015 ycl. All rights reserved.
//

import Foundation
import UIKit

class SquareButton : UIButton {
    let squareSize:CGFloat
    let squareMargin:CGFloat
    var square:Square
    var fingerPressed = false
    var safeDiscover = false
    init(squareModel:Square, squareSize:CGFloat, squareMargin:CGFloat) {
        self.square = squareModel
        self.squareSize = squareSize
        self.squareMargin = squareMargin
        let x = CGFloat(self.square.column) * (squareSize + squareMargin)
        let y = CGFloat(self.square.row) * (squareSize + squareMargin)
        let squareFrame = CGRectMake(x, y, squareSize, squareSize)
        super.init(frame: squareFrame)
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}