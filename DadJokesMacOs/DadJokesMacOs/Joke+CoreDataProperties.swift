//
//  Joke+CoreDataProperties.swift
//  DadJokesMacOs
//
//  Created by Owen Henley on 26/09/2019.
//  Copyright © 2019 Owen Henley. All rights reserved.
//
//

import Foundation
import CoreData

extension Joke {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Joke> {
        return NSFetchRequest<Joke>(entityName: "Joke")
    }

    @NSManaged public var setup: String
    @NSManaged public var punchline: String
    @NSManaged public var rating: String

}
