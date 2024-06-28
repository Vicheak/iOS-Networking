//
//  Note+CoreDataProperties.swift
//  NoteApp
//
//  Created by @suonvicheakdev on 28/6/24.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var detail: String?
    @NSManaged public var noteID: String?
    @NSManaged public var title: String?
    @NSManaged public var folder: Folder?

}

extension Note : Identifiable {

}
