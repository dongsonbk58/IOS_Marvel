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
                    let peopleID = people.value(forKeyPath: "characterID") as? Int ?? 0
                    if peopleID == characterID {
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
                characterObject.setValue(String(describing: character.characterId), forKey: "characterID")
                characterObject.setValue(character.name, forKey: "name")
                characterObject.setValue(character.description, forKey: "desc")
                characterObject.setValue(character.modified, forKey: "modified")
                if let path = character.thumbnail?.path {
                    if let exten = character.thumbnail?.exten {
                        characterObject.setValue(path + "." + exten, forKey: "avatarUrl")
                    }
                }
                do {
                    try managedContext.save()
                } catch {

                }
            }
        }
    }

    func getListCharacter() -> [Character] {
        var characters = [Character]()
        var peoples = [NSManagedObject]()
        if let managedContext = getManagerContext() {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CharacterEntity")
            do {
                peoples = try managedContext.fetch(fetchRequest)
                for people in peoples {
                    let character = Character(characterId: people.value(forKeyPath: "characterID") as? Int ?? 0,
                                              name: people.value(forKeyPath: "name") as? String ?? "",
                                              description: people.value(forKeyPath: "desc") as? String ?? "",
                                              modified: people.value(forKeyPath: "modified") as? String ?? "",
                                              avatarUrl: people.value(forKeyPath: "avatarUrl") as? String ?? "")
                    characters.append(character)
                }
            } catch {

            }
        }
        return characters
    }

    func deleteCharacter(characterID: Int) -> Bool {
        if let managedContext = getManagerContext() {
            if let people = isExist(characterID: characterID) {
                managedContext.delete(people)
                return true
            }
        }
        return false
    }
}
