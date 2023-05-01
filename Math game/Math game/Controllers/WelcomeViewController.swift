//
//  WelcomeViewController.swift
//  Math game
//
//  Created by Aurelio Le Clarke on 01.05.2023.
//

import UIKit

class WelcomeViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    //Array of user Defaults
    var dataSource: [UserScoreSection] = [] {
        
        didSet {
            print("Value of var dataSource was changed")
            tableView.reloadData()
        }
    }
    let singleton = ViewController()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "ScoreTableViewCell", bundle: nil), forCellReuseIdentifier: ScoreTableViewCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource  = self
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(getUserScore), for: .valueChanged)
 
    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserScore()
    }
    
    func deleteContact(indexPath: IndexPath) {
        
        let deletedContact = dataSource[indexPath.section].list.remove(at: indexPath.row)
        
        if dataSource[indexPath.section].list.count < 1 {
            dataSource.remove(at: indexPath.section)
        }
        
        singleton.deleteUser(indexPath: indexPath, users: deletedContact)
 
    }
    
    
    @objc func getUserScore() {
      
        tableView.refreshControl?.endRefreshing()

        var easyScoreList = ViewController.getAllUserScores(level: .easy)
        easyScoreList.sort { userScore1, userScore2 in
            return userScore1.score > userScore2.score
        }
        let easyScoreSection = UserScoreSection(list: easyScoreList, title: "Easy")
        
        var mediumScoreList = ViewController.getAllUserScores(level: .medium)
        mediumScoreList.sort { userScore1, userScore2 in
            return userScore1.score > userScore2.score
        }
        let mediumScoreSection = UserScoreSection(list: mediumScoreList, title: "Medium")
        
        var hardScoreList = ViewController.getAllUserScores(level: .hard)
        hardScoreList.sort { userScore1, userScore2 in
            return userScore1.score > userScore2.score
        }
        let hardScoreSection = UserScoreSection(list: hardScoreList, title: "Hard")
        
        self.dataSource  = [easyScoreSection,mediumScoreSection,hardScoreSection]
        

        
        
    }
    

    
 
}

//MARK: - Table View

extension WelcomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func getSingleUserText(indexPath: IndexPath) -> String? {
        
        let userScore: UserScore = dataSource[indexPath.section].list[indexPath.row]
        
    
        
        let text  = "Name: \(userScore.name),Score: \(userScore.score)"
        
        return text
        
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteContact(indexPath: indexPath)
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScoreTableViewCell.identifier, for: indexPath) as! ScoreTableViewCell
        
        cell.scoreLabel.text = getSingleUserText(indexPath: indexPath)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].list.count
        
   
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("User selected \(indexPath.row)")
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return dataSource[section].title
     
    }
    
    
    
}

    

 

