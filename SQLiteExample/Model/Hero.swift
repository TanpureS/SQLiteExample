//
//  Hero.swift
//  SQLiteExample
//
//  Created by Shivaji Tanpure on 23/05/18.
//  Copyright © 2018 Shivaji Tanpure. All rights reserved.
//

import Foundation

class Hero {
    
    var id: Int
    var name: String?
    var powerRanking: Int
    
    init(id: Int, name: String?, powerRanking: Int){
        self.id = id
        self.name = name
        self.powerRanking = powerRanking
    }
}
