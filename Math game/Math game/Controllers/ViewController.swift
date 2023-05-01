//
//  ViewController.swift
//  Math game
//
//  Created by Aurelio Le Clarke on 27.04.2023.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var problemLabel: UILabel!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var resultField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var restartButton: UIButton!
    
    var dataModel: UserScoreModel = UserScoreModel()
    
    
    static let userScoreKey = "userScore"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateProblem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = .black
    }
    
    //loads after view shows
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scheduleTimer()
    }
    
    @IBAction func submitPressed(_ sender: UIButton) {
        guard let text  = resultField.text else {
            print("Text is nil")
            return
        }
        guard !text.isEmpty else {
            print("Text is empty")
            return }
        
        guard let result = Double(text) else {
            print("Couldnt convert text \(text) to Double")
            return }
        
        
        print("Result is \(result)")
        
        if result  == self.dataModel.result {
            let selectedLevel = segmentedControl.selectedSegmentIndex
            dataModel.score += dataModel.scoreAmount[selectedLevel]
            
            
            scoreLabel.text = "Score: \(dataModel.score)"
            print("Correct answer")
        }else {
            print("Incorrect answer ")
        }
        generateProblem()
        resultField.text = nil
    }
    
    private func generateProblem() {
        
        let selectedIndex = segmentedControl.selectedSegmentIndex
        let levels = dataModel.levelOfGame[selectedIndex]
        
        let firstDigit = Int.random(in: levels)
        var startingIndex = levels.lowerBound
        var endIndex = levels.upperBound
        
        guard  let arithmeticOperator: String  = ["+", "-","x","/"].randomElement() else { return }
        
        if arithmeticOperator == "/" && startingIndex == 0 {
            startingIndex = 1
        }else if arithmeticOperator == "-"  {
            endIndex = firstDigit
        }
        
        
        let secondDigit = Int.random(in: startingIndex...endIndex)
        
        problemLabel.text = "\(firstDigit) \(arithmeticOperator) \(secondDigit) ="
        
        switch arithmeticOperator {
        case "+":
            
            dataModel.result = Double(firstDigit + secondDigit)
            
        case "-":
            
            dataModel.result = Double(firstDigit - secondDigit)
            
        case "x":
            
            dataModel.result = Double(firstDigit * secondDigit)
        case "/":
            
            dataModel.result = Double(firstDigit) / Double(secondDigit)
        default:
            
            dataModel.result = nil
        }
    }
    
    func restart() {
        dataModel.score = 0
        scoreLabel.text = "Score: 0"
        generateProblem()
        scheduleTimer()
        resultField.isEnabled = true
        submitButton.isEnabled = true
    }
    
    private func scheduleTimer() {
        dataModel.countdown = 30
        dataModel.timer?.invalidate()
        dataModel.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimerUI), userInfo: nil, repeats: true)
        
    }
    
    
    
    @objc func updateTimerUI() {
        dataModel.countdown -= 1
        var seconds = "\(dataModel.countdown)"
        
        if dataModel.countdown < 10 {
            seconds  = "0\(dataModel.countdown)"
        }
        timerLabel.text = "00 : \(seconds)"
        progressView.progress  = Float(30 - dataModel.countdown)  / Float(30)
        if dataModel.countdown <= 0 {
            finishTheGame()
        }
    }
    
    @IBAction func restartPressed(_ sender: UIButton) {
        restart()
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        restart()
        
    }
    //MARK: - Timer ends
    func finishTheGame() {
        dataModel.timer?.invalidate()
        resultField.isEnabled = false
        submitButton.isEnabled = false
        
        askForName()
        
    }
    //MARK: - Alert controller
    
    func askForName() {
        
        let alertController = UIAlertController(title: "Game is over", message: "Save your score \(dataModel.score)", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Write your name"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let textField = alertController.textFields?.first else { return }
            guard let text = textField.text, !text.isEmpty else {
                print("Textfield nil")
                return }
            print("Name \(text)")
            
            self.saveUserScoreAsStruct(name: text)
            
        }
        
        alertController.addAction(saveAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
        
    }
    
    
    func saveUserScoreAsStruct(name: String) {
        
        let userScore = UserScore(name: name, score: dataModel.score)
        
        var level: Levels?
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            level = .easy
        case 1:
            level = .medium
        case 2:
            level = .hard
        default:
            ()
        }
        
        guard let level = level  else {
            print("Level is nil because index out of range")
            return }
        
        let userScoreArray: [UserScore] = ViewController.getAllUserScores(level: level) + [userScore]
        do {
            let encoder = JSONEncoder()
            let encoded =  try encoder.encode(userScoreArray)
            let userDefaults = UserDefaults.standard
            userDefaults.set(encoded, forKey: level.keys())
        }catch {
            print("Couldn't encode given [UserScore] into data with error \(error.localizedDescription)")
            
        }
    }
    
    static func getAllUserScores(level: Levels) -> [UserScore] {
        
        var result: [UserScore] = []
        
        let userDefaults = UserDefaults.standard
        
        if let data = userDefaults.object(forKey: level.keys()) as? Data {
            //do catch block for if throws error
            do {
                
                let decoder = JSONDecoder()
                result = try decoder.decode([UserScore].self, from: data)
                
            }catch {
                print("Couldn't decode given data to [Userscore] with error \(error.localizedDescription)")
            }
        }
        
        return result
        
    }
    
    
    
    //MARK: - Save in UserDefaults
    func saveUserScore(name: String) {
        let userScore: [String : Any] = ["name": name, "score": dataModel.score]
        let userScoreArray: [ [ String : Any ] ] = getUserScoreArray() + [userScore]
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(userScoreArray, forKey: ViewController.userScoreKey)
        
    }
    
    func getUserScoreArray() -> [[String: Any]] {
        
        let userDefaults = UserDefaults.standard
        let array = userDefaults.array(forKey: ViewController.userScoreKey) as? [[String: Any]]
        return array ?? []
    }

    
    //извлечение контактов
    
    func extractContacts(users: UserScore) {
       
        
        
    }
    
    //создать функцию который передается параметром
    
    func deleteUser(indexPath: IndexPath, users: UserScore) {
        
        let userDefaults: UserDefaults = UserDefaults.standard
        
        var users = userDefaults.array(forKey: ViewController.userScoreKey)
        users?.remove(at: indexPath.row)
        userDefaults.set(users, forKey: ViewController.userScoreKey)
        userDefaults.synchronize()
    }
    
}

    



