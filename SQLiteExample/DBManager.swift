//
//  DBManager.swift
//  SQLiteExample
//
//  Created by Shivaji Tanpure on 23/05/18.
//  Copyright © 2018 Shivaji Tanpure. All rights reserved.
//

import UIKit
import SQLite3

class DBManager: NSObject {
    var db: OpaquePointer?
    var heroList = [Hero]()
    static let sharedInstance = DBManager()
    private override init() {}
    
    //Create and Open DB
    func createDatabase(){
        //creating the database file
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("HeroesDatabase.sqlite")
        print("path:\(fileURL)")
        
        //method to open the database.
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        //Once we have the database open, we need to create the table
        //To create the table we can use the function sqlite3_exec()
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Heroes (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, powerrank INTEGER)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
    }
    
    //Insert data into DB
    func insert(name:String, powerRanking:String) {
        
        //creating a statement
        var stmt: OpaquePointer?
        
        //the insert query
        let queryString = "INSERT INTO Heroes (name, powerrank) VALUES (?,?)"
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //binding the parameters
        if sqlite3_bind_text(stmt, 1, name, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        if sqlite3_bind_int(stmt, 2, (powerRanking as NSString).intValue) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        //executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting hero: \(errmsg)")
            return
        }
       
        readValues()
        
        //displaying a success message
        print("Herro saved successfully")
        
    }
    
    //Read data from DB
    func readValues(){
        
        //first empty the list of heroes
        heroList.removeAll()
        
        //this is our select query
        let queryString = "SELECT * FROM Heroes"
        
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let powerrank = sqlite3_column_int(stmt, 2)
            
            //adding values to list
            heroList.append(Hero(id: Int(id), name: String(describing: name), powerRanking: Int(powerrank)))
        }
        
        print("Hero list:\(heroList)")
    }

}
