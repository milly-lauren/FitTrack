//
//  FitnessItem.swift
//  Fitness Track
//
//  Created by Juan  on 6/30/19.
//  Copyright © 2019 New Horizon. All rights reserved.
//

import MongoSwift

// A fitness item from a MongoDB document
struct FitnessItem: Codable
{
    
    private enum CodingKeys: String, CodingKey
    {
        case id = "_id"
        case ownerId = "owner_id"
        case task, checked
    }
    
    let id: ObjectId
    let ownerId: String
    let task: String
    
    var checked: Bool
    {
        didSet
        {
            itemsCollection.updateOne(
                filter: ["_id": id],
                update: ["$set": [CodingKeys.checked.rawValue: checked] as Document],
                options: nil)
            { _ in
                    
            }
        }
    }
}
