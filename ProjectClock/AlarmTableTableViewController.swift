//
//  AlarmTableTableViewController.swift
//  ProjectClock
//
//  Created by Hykilpikonna on 1/13/21.
//

import UIKit

class AlarmViewController: UIViewController
{
    // TODO: Remove example and use localStorage
    var data: [Alarm] = [Alarm(alarmTime: Date(), text: "Wake up lol", wakeMethod: wvms[0])]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in: UITableView) -> Int { return 1 }

    override func tableView(_ v: UITableView, numberOfRowsInSection s: Int) -> Int { return data.count }

    override func tableView(_ v: UITableView, cellForRowAt i: IndexPath) -> UITableViewCell
    {
        // Get the cell and item at index i
        let cell = tableView.dequeueReusableCell(withIdentifier: "alarm", for: i)
        let item = data[i.row]
        
        // Set the content of the cell to the content of the item.
        cell.textLabel?.text = item.text
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
}
