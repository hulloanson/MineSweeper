//
//  Board.swift
//  MineSweeper
//
//  Created by YuenChung Lun on 14/5/15.
//  Copyright (c) 2015 ycl. All rights reserved.
//

import Foundation

class Board {
    let size:Int
    var squares: [[Square]] = []
    init(size:Int) {
        self.size = size
        for row in 0 ..< size {
            var rows: [Square] = []
            for column in 0 ..< size {
                let square: Square = Square(row: row, column: column)
                rows.append(square)
            }
            squares.append(rows)
        }
    }
    
    func startNewGame(){
        self.resetBoard()
    }
    
    func resetBoard() {
        for row in 0 ..< size {
            for column in 0 ..< size {
                squares[row][column].isRevealed = false
                setMine(squares[row][column])

            }
        }
        for row in 0 ..< size {
            for column in 0 ..< size {
                countMinedNeighbor(squares[row][column])
            }
        }
    }
        
    func setMine(square: Square) {
        square.isMine = ((arc4random()%10) == 0)
    }
    
    func countMinedNeighbor(square: Square){
        var minedNeighborCount = 0
        var neighborArr: [Square] = scanNeighbor(square)
        for neighbor in neighborArr {
            if neighbor.isMine {
                minedNeighborCount++
            }
        }
        square.minedNeighborCount = minedNeighborCount
    }

    func scanNeighbor(square: Square) -> [Square] { //scan for non-empty neighbors
        var adjTiles = [(-1, -1), (0, -1), (-1, 0), (1, 1), (1, 0), (0, 1), (-1, 1), (1, -1)]
        var neighbors: [Square] = []
        for (rowOffset, columnOffset) in adjTiles {
            let optionalNeighbor:Square? = getTile(square.row+rowOffset, column: square.column+columnOffset)
            if let neighbor = optionalNeighbor {
                neighbors.append(neighbor)
            }
        }
        return neighbors
    }
    
    func getTile(row: Int, column: Int) -> Square? { //get square object with row and column number
        if row >= 0 && row < self.size && column >= 0 && column < self.size {
            return self.squares[row][column]
        } else {
            return nil
        }
    }
    
    
}