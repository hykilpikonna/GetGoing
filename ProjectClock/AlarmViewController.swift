//
//  AlarmViewController.swift
//  ProjectClock
//
//  Created by Hykilpikonna on 1/13/21.
//

import UIKit

class AlarmViewController: UIViewController
{
    @IBOutlet weak var table: UITableView!
    
    // TODO: Remove example and use localStorage
    var data: [Alarm] = [Alarm(alarmTime: Date(), text: "Wake up lol", wakeMethod: wvms[0])]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
    }
}

extension AlarmViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in: UITableView) -> Int { return 1 }

    func tableView(_ v: UITableView, numberOfRowsInSection s: Int) -> Int { return data.count }

    func tableView(_ v: UITableView, cellForRowAt i: IndexPath) -> UITableViewCell
    {
        // Get the cell and item at index i
        let rawCell = v.dequeueReusableCell(withIdentifier: "alarm", for: i)
        guard let cell = rawCell as? AlarmTableCell else { return rawCell }
        let item = data[i.row]
    
        // Set the content of the cell to the content of the item.
        cell.descriptionText.text = item.text
        
        return cell
    }
    
    /// This defines the height
    func tableView(_ v: UITableView, heightForRowAt i: IndexPath) -> CGFloat { return 120 }
    
    func tableView(_ v: UITableView, didSelectRowAt i: IndexPath) { v.deselectRow(at: i, animated: true) }
}

class AlarmTableCell: UITableViewCell
{
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var ampm: UILabel!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var enable: UISwitch!
    @IBOutlet weak var repeatText: UILabel!
    @IBOutlet weak var goingOffText: UILabel!
}
