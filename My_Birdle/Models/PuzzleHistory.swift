//
//  PuzzleHistory.swift
//  My_Birdle
//
//  Created by KimChhay Leng on 11/11/2025.
//
// Core Data entity for storing completed puzzle history

import Foundation
import CoreData

@objc(PuzzleHistory)
public class PuzzleHistory: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID?
    @NSManaged public var birdName: String?
    @NSManaged public var attempts: Int16
    @NSManaged public var timeSpent: Double
    @NSManaged public var completionDate: Date?
    @NSManaged public var imageUrl: String?
    @NSManaged public var photographer: String?
    @NSManaged public var license: String?
    @NSManaged public var wikiLink: String?
}

extension PuzzleHistory {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PuzzleHistory> {
        return NSFetchRequest<PuzzleHistory>(entityName: "PuzzleHistory")
    }
}
