//
//  Category.swift
//  todoey
//
//  Created by arjun adappa on 04/08/19.
//  Copyright © 2019 arjun adappa. All rights reserved.
//

import Foundation
import RealmSwift

class Category:Object{
    @objc dynamic var name: String = ""
    let items = List<Item>()
    
}
