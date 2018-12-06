//
//  AddEditMatchViewController.swift
//  MyGameTracker
//
//  Created by Clemens Stift on 06.12.18.
//  Copyright © 2018 Clemens Stift. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AddEditMatchViewController: UIViewController {

var appDelegate : AppDelegate!
var managedContext : NSManagedObjectContext!
    
    var isCreateNew: Bool!
    var selectedMatch : Match!
    var gamePlayed : Game!
    var oponentPlayed : Player!
    
    // Text Fields
    @IBOutlet weak var scoreHomeLabelField: UILabel!
    @IBOutlet weak var scoreHomeTextField: UITextField!
    @IBOutlet weak var scoreAwayLabelField: UILabel!
    @IBOutlet weak var scoreAwayTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var addProofButton: UIButton!
    @IBOutlet weak var proofImageView: UIImageView!
    

override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = NSLocalizedString("AddEditMatch-Title", comment: "")
    scoreHomeLabelField.text = NSLocalizedString("AddEditMatch-ScoreHomeLabel", comment: "")
    scoreAwayLabelField.text = NSLocalizedString("AddEditMatch-ScoreAwayLabel", comment: "")
    saveButton.setTitle(NSLocalizedString("AddEditMatch-SaveButtonLabel", comment: ""), for: .normal)
    addProofButton.setTitle(NSLocalizedString("AddEditMatch-ProofButtonLabel", comment: ""), for: .normal)
    
    if(!isCreateNew){
        scoreHomeTextField.text = String(selectedMatch.userScore)
        scoreAwayTextField.text = String(selectedMatch.opponentScore)
        // Pass data to the imageView
    }
    
    setUpCoreData()
}
    
    @IBAction func saveMatch(_ sender: Any) {
        
        var matchToBeSaved : Match
        
        if (isCreateNew){
            let matchEntity = NSEntityDescription.entity(forEntityName:"Match", in: managedContext)!
            matchToBeSaved = NSManagedObject(entity: matchEntity, insertInto: managedContext) as! Match
        } else {
            matchToBeSaved = selectedMatch
        }
        
        matchToBeSaved.game = gamePlayed
        matchToBeSaved.opponent = oponentPlayed
        
        matchToBeSaved.userScore = Int16(scoreHomeTextField.text!) ?? 0
        matchToBeSaved.opponentScore = Int16(scoreAwayTextField.text!) ?? 0
        
        if (matchToBeSaved.userScore > matchToBeSaved.opponentScore){
            matchToBeSaved.won = true
        } else {
            matchToBeSaved.won = false
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return
        }
        
        navigationController?.popViewController(animated: true)
        }
    

    func setUpCoreData(){
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
    }
    

}
