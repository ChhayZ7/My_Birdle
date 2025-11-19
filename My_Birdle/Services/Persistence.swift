//
//  Persistence.swift
//  My_Birdle
//
//  Created by KimChhay Leng on 11/11/2025.
//
// Core Data stack and persistence controller

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    

    init(inMemory: Bool = false){
        container = NSPersistentContainer(name: "Birdle")
        
        // Use in-memory store for testing/previews
        if inMemory{
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores{ description, error in
            if let error = error {
                fatalError("Error loading Core Data: \(error.localizedDescription)")
            }
        }
        
        // Aut0-merge changes from background context
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    // Save context
    func save(){
        let context = container.viewContext
        
        if context.hasChanges{
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error.localizedDescription)")
            }
        }
    }
    
    // Saves completed puzzle result to history
    func savePuzzleResult(_ result: PuzzleResult){
        let context = container.viewContext
        let history = PuzzleHistory(context: context)
        
        history.id = UUID()
        history.birdName = result.birdName
        history.attempts = Int16(result.attempts)
        history.timeSpent = result.timeSpent
        history.completionDate = result.date
        history.imageUrl = result.imageUrl
        history.photographer = result.photographer
        history.license = result.license
        history.wikiLink = result.wikiLink
        
        save()
    }
    
    // Fetches all puzzle history, sorted by most recent first
    func fetchHistory() -> [PuzzleHistory]{
        let request: NSFetchRequest<PuzzleHistory> = PuzzleHistory.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \PuzzleHistory.completionDate, ascending: false)]
        
        do {
            return try container.viewContext.fetch(request)
        } catch {
            print("Error fetching history: \(error.localizedDescription)")
            return []
        }
    }
    
    // Checks if user has already completed today's puzzle (prevent multiple attempts per day)
    func hasSolvedToday() -> Bool{
        let request: NSFetchRequest<PuzzleHistory> = PuzzleHistory.fetchRequest()
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        
        // Query for puzzles completed between start of today and start of tomorrow
        request.predicate = NSPredicate(format: "completionDate >= %@ AND completionDate < %@", today as NSDate, tomorrow as NSDate)
        
        do {
            let count = try container.viewContext.count(for: request)
            return count > 0
        } catch {
            print("Error checking today's puzzle: \(error.localizedDescription)")
            return false
        }
    }
}
