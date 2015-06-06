//
//  Video.swift
//  
//
//  Created by Charles Konkol on 2015-06-06.
//
//

import Foundation
import CoreData

class Video: NSManagedObject {

    @NSManaged var datestamp: String
    @NSManaged var link: String
    @NSManaged var name: String

}
