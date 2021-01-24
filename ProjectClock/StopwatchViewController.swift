//
//  StopwatchViewController.swift
//  ProjectClock
//
//  Created by Dallon Archibald on 1/23/21.
//  Reference: https://youtu.be/H691qFRpaWA

import UIKit

class StopwatchViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var hours = 0
    var minutes = 0
    var seconds = 0
    var started = false
    
    var lappedTimes: [String] = []
    var timer = Timer()
    
    /**
     Start/stop stopwatch
     */
    @IBAction func start(_ sender: UIButton)
    {
        if !started
        {
            // Start timer
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(count), userInfo: nil, repeats: true)
            started = true
            startButton.setTitle("Stop", for: .normal)
            resetButton.setTitle("Lap", for: .normal)
        }
        else
        {
            // Stop timer
            timer.invalidate()
            started = false
            startButton.setTitle("Start", for: .normal)
            resetButton.setTitle("Reset", for: .normal)
        }
    }
    
    @objc fileprivate func count()
    {
        // Add time (If it goes longer than 24 hours, the hour count should go to 25)
        seconds += 1
        
        if seconds == 60
        {
            minutes += 1
            seconds = 0
        }
        if minutes == 60
        {
            hours += 1
            minutes = 0
        }
        
        timeLabel.text = String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    /**
     Lap/reset button
     */
    @IBAction func lapOrReset(_ sender: UIButton)
    {
        if started
        {
            // Insert lap
            lappedTimes.insert(timeLabel.text!, at: 0)
            tableView.reloadData()
        }
        else
        {
            // Reset
            seconds = 0
            minutes = 0
            seconds = 0
            lappedTimes = []
            timeLabel.text = "00:00:00"
            tableView.reloadData()
        }
    }
}

/**
 Table data source
 */
extension StopwatchViewController: UITableViewDelegate, UITableViewDataSource
{
    /**
     Define row count
     */
    func tableView(_ _: UITableView, numberOfRowsInSection _: Int) -> Int
    {
        return lappedTimes.count
    }
    
    /**
     Set cell at i
     */
    func tableView(_ view: UITableView, cellForRowAt i: IndexPath) -> UITableViewCell
    {
        let cell = view.dequeueReusableCell(withIdentifier: "lapCell", for: i)
        cell.textLabel?.text = lappedTimes[i.row]
        cell.selectionStyle = .none
        return cell
    }
    
    /**
     Swipe left to delete cells at i
     */
    func tableView(_ view: UITableView, commit: UITableViewCell.EditingStyle, forRowAt i: IndexPath)
    {
        if commit == .delete
        {
            lappedTimes.remove(at: i.row)
            view.deleteRows(at: [i], with: .automatic)
        }
    }
}

/**
 Class to set relative font size for the stopwatch
 */
class StopwatchText: UILabel
{
    @IBInspectable var iPhoneFontSize: CGFloat = 0
    {
        didSet
        {
            overrideFontSize(iPhoneFontSize)
        }
    }

    func overrideFontSize(_ fontSize: CGFloat)
    {
        let size = UIScreen.main.bounds.size
        let width = UIDevice.current.orientation.isPortrait ? size.width : size.height
        
        // ViewWidth-based font size
        font = font.withSize(0.22 * width)
    }
}
