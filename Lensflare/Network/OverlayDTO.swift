//
//  OverlayModel.swift
//  Lensflare
//
//  Created by Oguz on 21.08.2020.
//

struct OverlayDTO: Decodable {
    let overlayId: Int?
    let overlayName:String?
    let overlayPreviewIconUrl: String?
    let overlayUrl: String?
    
    var overlayCellViewModel: OverlayCell.ViewModel {
        .init(overlayPreviewIconUrl: overlayPreviewIconUrl, overlayName: overlayName)
    }
}
