//
//  OverlayEntity+CoreDataProperties.swift
//  Lensflare
//
//  Created by Oguz on 24.08.2020.
//
//

import Foundation
import CoreData


extension OverlayEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OverlayEntity> {
        return NSFetchRequest<OverlayEntity>(entityName: "OverlayEntity")
    }

    @NSManaged public var overlay: NSObject?
    @NSManaged public var overlayId: Int16
    @NSManaged public var overlayName: String?
    @NSManaged public var overlayPreviewIconUrl: String?
    @NSManaged public var overlayUrl: String?
    @NSManaged public var thumb: NSObject?

}
