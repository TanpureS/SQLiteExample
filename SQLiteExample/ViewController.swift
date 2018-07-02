//
//  ViewController.swift
//  SQLiteExample
//
//  Created by Shivaji Tanpure on 23/05/18.
//  Copyright © 2018 Shivaji Tanpure. All rights reserved.
//

import UIKit


//LINK: https://www.simplifiedios.net/swift-sqlite-tutorial/#comment-5982

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldPowerRanking: UITextField!
    @IBOutlet weak var tableViewHeroes: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.tableViewHeroes.delegate = self
        self.tableViewHeroes.dataSource = self
        
        DBManager.sharedInstance.createDatabase()
        
        //Read data from DB if exists
        DBManager.sharedInstance.readValues()
        self.tableViewHeroes.reloadData()
    }

    //Read values from DB and display itto tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //this method is giving the row count of table view which is
        //total number of heroes in the list
        return DBManager.sharedInstance.heroList.count
    }
    
    //this method is binding the hero name with the tableview cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        let hero: Hero
        hero = DBManager.sharedInstance.heroList[indexPath.row]
        cell.textLabel?.text = hero.name
        return cell
    }
    
    
    @IBAction func buttonSave(_ sender: Any) {
        //getting values from textfields
        let name = textFieldName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let powerRanking = textFieldPowerRanking.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //validating that values are not empty
        if(name?.isEmpty)!{
            textFieldName.layer.borderColor = UIColor.red.cgColor
            return
        }
        
        if(powerRanking?.isEmpty)!{
            textFieldName.layer.borderColor = UIColor.red.cgColor
            return
        }
        
        //Insert values into table
        DBManager.sharedInstance.insert(name: name!, powerRanking: powerRanking!)

        //emptying the textfields
        textFieldName.text=""
        textFieldPowerRanking.text=""
        
        self.tableViewHeroes.reloadData()

    }
    

}

