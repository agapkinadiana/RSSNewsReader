//
//  DBService.swift
//  RSSNewsReader
//
//  Created by Diana Agapkina on 29.11.20.
//

import CoreData

private let databaseName = "FeedEntity"

class DBService {
    static let shared = DBService()
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: databaseName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Check if existing feeds according to the id
    
    func feedExists(feedId: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: databaseName)
        fetchRequest.predicate = NSPredicate(format: "id == %@", feedId)
        var results: [NSManagedObject] = []
        do {
            results = try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print("Error executing fetch request: \(error)")
        }
        return results.count > 0
    }
    
    // MARK: - Add the selected feed to Core Data
    
    func saveCurrentFeed(item: Feed) {
        if(!feedExists(feedId: item.id)) {
            let bgContext = persistentContainer.newBackgroundContext()
            let feed = FeedEntity(context: bgContext)
            feed.id = item.id
            feed.title = item.title
            feed.pubDate = item.pubDate
            feed.desc = item.description
            do {
                try bgContext.save()
            } catch {
                print("DEBUG: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Fetch all feeds in Core Data
    
    func fetchSavedFeed() -> [Feed] {
        var rssFeeds = [Feed]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: databaseName)
        do {
            if let feeds = try persistentContainer.viewContext.fetch(fetchRequest) as? [FeedEntity] {
                for feed in feeds {
                    guard let id = feed.id,
                          let title = feed.title,
                          let pubDate = feed.pubDate,
                          let desc = feed.desc
                    else { return rssFeeds }
                    rssFeeds.append(Feed(id: id, title: title, description: desc, pubDate: pubDate, link: nil))
                }
            }
        } catch {
            print("DEBUG: \(error.localizedDescription)")
            return []
        }
        return rssFeeds
    }
    
    // MARK: - Remove selected feed according to the id
    
    func deleteSelectedFeed(feedId: String) {
        let bgContext = persistentContainer.newBackgroundContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: databaseName)
        fetchRequest.predicate = NSPredicate(format: "id == %@", feedId)
        do {
            if let record = try bgContext.fetch(fetchRequest) as? [FeedEntity] {
                bgContext.delete(record.first!)
                try bgContext.save()
            }
        } catch {
            print("DEBUG: \(error.localizedDescription)")
        }
    }
}
