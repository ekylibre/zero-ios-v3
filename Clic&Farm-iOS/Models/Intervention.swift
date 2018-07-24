//
//  Intervention.swift
//  ClickAndFarm-IOS
//
//  Created by Guillaume Roux on 16/07/2018.
//  Copyright © 2018 Ekylibre. All rights reserved.
//

import UIKit
import os.log

class Intervention: NSObject, NSCoding {

    //MARK: Properties

    enum InterventionType {
        case Semis, TravailSol, Irrigation, Recolte, Entretien, Fertilisation, Pulverisation
    }

    enum Status {
        case OutOfSync, Synchronised, Validated
    }

    var type: InterventionType
    var crops: String
    var infos: String
    var date: Date
    var status: Status

    //MARK: Archiving Paths

    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("interventions")

    //MARK: Types

    struct PropertyKey {
        static let type = "type"
        static let crops = "crops"
        static let infos = "infos"
        static let date = "date"
        static let status = "status"
    }

    //MARK: Initialization

    init(type: InterventionType, crops: String, infos: String, date: Date, status: Status) {
        self.type = type
        self.crops = crops
        self.infos = infos
        self.date = date
        self.status = status
    }

    //MARK: NSCoding

    func encode(with aCoder: NSCoder) {
        aCoder.encode(type, forKey: PropertyKey.type)
        aCoder.encode(crops, forKey: PropertyKey.crops)
        aCoder.encode(infos, forKey: PropertyKey.infos)
        aCoder.encode(date, forKey: PropertyKey.date)
        aCoder.encode(status, forKey: PropertyKey.status)
    }

    required convenience init?(coder aDecoder: NSCoder) {

        guard let type = aDecoder.decodeObject(forKey: PropertyKey.type) as? InterventionType else {
            os_log("Unable to decode the type for an Intervention object.", log: OSLog.default, type: .debug)
            return nil
        }

        guard let crops = aDecoder.decodeObject(forKey: PropertyKey.crops) as? String else {
            os_log("Unable to decode the crops for an Intervention object.", log: OSLog.default, type: .debug)
            return nil
        }

        guard let infos = aDecoder.decodeObject(forKey: PropertyKey.infos) as? String else {
            os_log("Unable to decode the infos for an Intervention object.", log: OSLog.default, type: .debug)
            return nil
        }

        guard let date = aDecoder.decodeObject(forKey: PropertyKey.date) as? Date else {
            os_log("Unable to decode the date for an Intervention object.", log: OSLog.default, type: .debug)
            return nil
        }

        guard let status = aDecoder.decodeObject(forKey: PropertyKey.status) as? Status else {
            os_log("Unable to decode the status for an Intervention object.", log: OSLog.default, type: .debug)
            return nil
        }

        self.init(type: type, crops: crops, infos: infos, date: date, status: status)
        
    }
}
