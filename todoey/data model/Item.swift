//
//  Item.swift
//  todoey
//
//  Created by arjun adappa on 04/08/19.
//  Copyright © 2019 arjun adappa. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var title : String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
