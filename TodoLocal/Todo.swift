//
//  Todo.swift
//  TodoLocal
//
//  Created by Mark Meretzky on 4/2/19.
//  Copyright © 2019 New York University School of Professional Studies. All rights reserved.
//

import Foundation;

struct Todo {
    var id: String;   //assigned by AWS, not by us
    var name: String;
    var description: String?;
    
    init(id: String = "", name: String, description: String?) {
        self.id = id.isEmpty ? "<id will go here>" : id;
        self.name = name;
        self.description = description;
    }
}
