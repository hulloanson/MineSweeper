//
//  Square.swift
//  MineSweeper
//
//  Created by YuenChung Lun on 14/5/15.
//  Copyright (c) 2015 ycl. All rights reserved.
//

import Foundation

class Square {
    let row: Int
    let column: Int
    var minedNeighborCount = 0
    var isMine = false
    var isRevealed = false
    init(row: Int, column: Int){
        self.row = row
        self.column = column
    }    
}