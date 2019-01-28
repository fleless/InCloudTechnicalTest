//
//  Task.swift
//  TrackingTest
//
//  Created by fahmex on 25/01/2019.
//  Copyright © 2019 fahmi. All rights reserved.
//

class Task {
    var idTask: String
    var description: String
    var startDate: String
    var endDate: String
    var time: String
    var title: String
    var idUser: String
    
    init(idTask: String, description: String, date: String, time: String, startDate:String, title:String, idUser: String){
        self.idTask = idTask
        self.description = description
        self.endDate = date
        self.time = time
        self.startDate = startDate
        self.title = title
        self.idUser = idUser
    }
}
