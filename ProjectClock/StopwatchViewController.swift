//
//  StopwatchViewController.swift
//  ProjectClock
//
//  Created by Dallon Archibald on 1/23/21.
//

import UIKit

class StopwatchViewController: UIViewController {

    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var lapButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var hours = 0
    var minutes = 0
    var seconds = 0
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension StopwatchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lapCell", for: indexPath)
        cell.textLabel?.text = "I am a lap cell \(indexPath.row + 1)"
        return cell
    }
}
