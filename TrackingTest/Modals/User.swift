//
//  User.swift
//  TrackingTest
//
//  Created by fahmex on 25/01/2019.
//  Copyright © 2019 fahmi. All rights reserved.
//

class User {
    var idUser: String
    var name: String
    var password: String
    
    init(id:String, name:String, password:String) {
        self.idUser = id
        self.name = name
        self.password = password
    }
}
