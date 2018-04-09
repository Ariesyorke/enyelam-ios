//
//  NSummary+CoreDataClass.swift
//  Nyelam
//
//  Created by Bobi on 4/9/18.
//  Copyright © 2018 e-Nyelam. All rights reserved.
//
//

import Foundation
import CoreData

@objc(NSummary)
public class NSummary: NSManagedObject {
    private let KEY_ORDER = "order"
    private let KEY_SERVICE = "service"
    private let KEY_CONTACT = "contact"
    private let KEY_PARTICIPANTS = "participants"
    
    func parse(json: [String : Any]) {
        if let orderJson = json[KEY_ORDER] as? [String: Any] {
            if let orderId = orderJson["order_id"] as? String {
                self.order = NOrder.getOrder(using: orderId)
            }
            if self.order == nil {
                self.order = NOrder.init(entity: NSEntityDescription.entity(forEntityName: "NOrder", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
            }
            self.order!.parse(json: json)
            self.id = self.order!.orderId
        } else if let orderString = json[KEY_ORDER] as? String {
            do {
                let data = orderString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let orderJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                if let orderId = orderJson["order_id"] as? String {
                    self.order = NOrder.getOrder(using: orderId)
                }
                if self.order == nil {
                    self.order = NOrder.init(entity: NSEntityDescription.entity(forEntityName: "NOrder", in: AppDelegate.sharedManagedContext)!, insertInto: AppDelegate.sharedManagedContext)
                }
                self.order!.parse(json: json)
                self.id = self.order!.orderId
            } catch {
                print(error)
            }
        }
        if let serviceJson = json[KEY_SERVICE] as? [String: Any] {
            if let id = serviceJson["id"] as? String {
                self.diveService = NDiveService.getDiveService(using: id)
            }
            if self.diveService == nil {
                self.diveService = NDiveService()
            }
            self.diveService!.parse(json: json)
        } else if let serviceString = json[KEY_SERVICE] as? String {
            do {
                let data = serviceString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let serviceJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                if let id = serviceJson["id"] as? String {
                    self.diveService = NDiveService.getDiveService(using: id)
                }
                if self.diveService == nil {
                    self.diveService = NDiveService()
                }
                self.diveService!.parse(json: json)
            } catch {
                print(error)
            }
        }
        if let contactJson = json[KEY_CONTACT] as? [String: Any] {
            self.contact = Contact(json: contactJson)
        } else if let contactString = json[KEY_CONTACT] as? String {
            do {
                let data = contactString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let contactJson: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                self.contact = Contact(json: contactJson)
            } catch {
                print(error)
            }
        }
        if let participantArray = json[KEY_PARTICIPANTS] as? Array<[String: Any]>, !participantArray.isEmpty {
            self.participant = []
            for participant in participantArray {
                self.participant!.append(Participant(json: participant))
            }
        } else if let participantString = json[KEY_PARTICIPANTS] as? String {
            do {
                let data = participantString.data(using: String.Encoding.utf8, allowLossyConversion: true)
                let participantArray: Array<[String: Any]> = try JSONSerialization.jsonObject(with: data!, options: []) as! Array<[String: Any]>
                self.participant = []
                for participant in participantArray {
                    self.participant!.append(Participant(json: participant))
                }
            } catch {
                print(error)
            }
        }
    }
    
    func serialized() -> [String : Any] {
        var json: [String: Any] = [:]
        if let order = self.order {
            json[KEY_ORDER] = order.serialized()
        }
        if let service = self.diveService {
            json[KEY_SERVICE] = service.serialized()
        }
        if let contact = self.contact {
            json[KEY_CONTACT] = contact.serialized()
        }
        if let participants = self.participant, !participants.isEmpty {
            var array: Array<[String: Any]> = []
            for participant in participants {
                array.append(participant.serialized())
            }
            json[KEY_PARTICIPANTS] = array
        }
        return json
    }
    
    static func getSummary(using id: String) -> NSummary? {
        let managedContext = AppDelegate.sharedManagedContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NSummary")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let summaries = try managedContext.fetch(fetchRequest) as? [NSummary]
            if let summaries = summaries, !summaries.isEmpty {
                return summaries.first
            }
        } catch {
            print(error)
        }
        return nil
    }
}
