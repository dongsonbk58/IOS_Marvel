//
//  DBManager.swift
//  IOSMarvel
//
//  Created by mai.thi.giang on 4/13/18.
//  Copyright © 2018 mai.thi.giang. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DBManager {

    class var sharedInstance: DBManager {
        struct Static {
            static let instance = DBManager()
        }
        return Static.instance
    }

    func getManagerContext() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        return managedContext
    }

    func isExist(characterID: Int) -> NSManagedObject? {
        var peoples = [NSManagedObject]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: characterTable)
        if let managedContext = getManagerContext() {
            do {
                peoples = try managedContext.fetch(fetchRequest)
                for people in peoples {
                    let peopleID = people.value(forKeyPath: feildID) as? String
                    if peopleID == String(characterID) {
                        return people
                    }
                }
            } catch {
                return nil
            }
        }
        return nil
    }

    func insertCharacter(character: Character) {
        if let managedContext = getManagerContext() {
            if let entity = NSEntityDescription.entity(forEntityName: characterTable, in: managedContext) {
                let characterObject = NSManagedObject(entity: entity, insertInto: managedContext)
                if let characterID = character.characterId {
                    characterObject.setValue(String(characterID), forKey: feildID)
                }
                characterObject.setValue(character.name, forKey: feildName)
                characterObject.setValue(character.description, forKey: feildDesc)
                characterObject.setValue(character.modified, forKey: feildModidied)
                if let path = character.thumbnail?.path {
                    if let exten = character.thumbnail?.exten {
                        characterObject.setValue(path + "." + exten, forKey: feildAvatarUrl)
                    }
                }
                if let avatarUrl = character.avatarUrl {
                    characterObject.setValue(avatarUrl, forKey: feildAvatarUrl)
                }
                do {
                    try managedContext.save()
                    if let characterID = character.characterId {
                        appDelegate().characterIdList.append(characterID)
                    }
                } catch {
                }
            }
        }
    }

    func getListCharacter() -> [Character] {
        var characters = [Character]()
        var peoples = [NSManagedObject]()
        if let managedContext = getManagerContext() {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
            do {
                peoples = try managedContext.fetch(fetchRequest)
                for people in peoples {
                    let character = Character(characterId: people.value(forKeyPath: feildID) as? String ?? "",
                                              name: people.value(forKeyPath: feildName) as? String ?? "",
                                              description: people.value(forKeyPath: feildDesc) as? String ?? "",
                                              modified: people.value(forKeyPath: feildModidied) as? String ?? "",
                                              avatarUrl: people.value(forKeyPath: feildAvatarUrl) as? String ?? "")
                    characters.append(character)
                }
            } catch {
            }
        }
        return characters
    }

    func deleteCharacter(characterID: Int) {
        if let managedContext = getManagerContext() {
            if let people = isExist(characterID: characterID) {
                managedContext.delete(people)
                do {
                    try managedContext.save()
                    if let index = appDelegate().characterIdList.index(of: characterID) {
                        appDelegate().characterIdList.remove(at: index)
                    }
                } catch {
                }
            }
        }
    }

    func searchCharacter(name: String) -> [Character] {
        var characters = [Character]()
        var peoples = [NSManagedObject]()
        if let managedContext = getManagerContext() {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
            do {
                peoples = try managedContext.fetch(fetchRequest)
                for people in peoples {
                    if (people.value(forKey: feildName) as? String ?? "").lowercased().contains(name.lowercased()) {
                        let character = Character(characterId: people.value(forKeyPath: feildID) as? String ?? "",
                                                  name: people.value(forKeyPath: feildName) as? String ?? "",
                                                  description: people.value(forKeyPath: feildDesc) as? String ?? "",
                                                  modified: people.value(forKeyPath: feildModidied) as? String ?? "",
                                                  avatarUrl: people.value(forKeyPath: feildAvatarUrl) as? String ?? "")
                        characters.append(character)
                    }
                }
            } catch {
            }
        }
        return characters
    }
}
