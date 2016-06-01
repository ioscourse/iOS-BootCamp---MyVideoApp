//
//  Video.swift
//  
//
//  Created by Charles Konkol on 2016-05-06.
//  Copyright (c) 2015 Rock Valley College. All rights reserved.
//

import Foundation
import CoreData

class Video: NSManagedObject {

    @NSManaged var datestamp: String
    @NSManaged var link: String
    @NSManaged var name: String

}
