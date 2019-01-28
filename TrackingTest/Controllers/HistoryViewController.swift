//
//  HistoryViewController.swift
//  TrackingTest
//
//  Created by fahmex on 25/01/2019.
//  Copyright © 2019 fahmi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var tasks: [Task] = Array()
    var filtered: [Task] = Array()
    var searching = false
    @IBOutlet weak var searchBar: UISearchBar!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searching){
            return filtered.count
        }else{
        return tasks.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell") as! HIstoryTableViewCell
        if(searching){
            cell.desc.text = self.filtered[indexPath.row].description
            cell.startDate.text = self.filtered[indexPath.row].startDate
            cell.endDate.text = self.filtered[indexPath.row].endDate
            cell.title.text = self.filtered[indexPath.row].title
            cell.timer.text = self.filtered[indexPath.row].time
            return cell
        }else{
        cell.desc.text = self.tasks[indexPath.row].description
        cell.startDate.text = self.tasks[indexPath.row].startDate
        cell.endDate.text = self.tasks[indexPath.row].endDate
        cell.title.text = self.tasks[indexPath.row].title
        cell.timer.text = self.tasks[indexPath.row].time
        return cell
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.tintColor = UIColor.white
        tableView.layer.masksToBounds = true
        tableView.layer.borderColor = UIColor( red: 31/255, green: 171/255, blue:255/255, alpha: 1.0 ).cgColor
        tableView.layer.borderWidth = 2.0
        loadTasks()
    }
    
    func loadTasks(){
        let url = "http://\(AppDelegate.url)/tasks"
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: nil)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                
                switch response.result{
                case .failure(let error):
                    print(error)
                case .success(let value):
                    let json = JSON(value)
                    for res in json.arrayValue {
                        let start = res["startDate"].stringValue
                        let desc = res["description"].stringValue
                        let time = res["time"].stringValue
                        let end = res["endDate"].stringValue
                        let title = res["title"].stringValue
                        let id = res["idTask"].stringValue
                        let idU = res["idUser"].stringValue
                        let task = Task(idTask: id, description: desc, date: end, time: time, startDate: start, title: title, idUser: idU)
                        self.tasks.append(task)
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    
}

extension HistoryViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = tasks.filter({$0.description.contains(searchText) })
        searching = true
        if(searchText == ""){
            searching = false
        }
        tableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableView.reloadData()
    }
}
