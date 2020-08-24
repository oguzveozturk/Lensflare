//
//  OverlayCellViewModel.swift
//  Lensflare
//
//  Created by Oguz on 23.08.2020.
//

import Foundation

final class ViewModel: NSObject {
    
    private lazy var localData = PersistantManager.shared
    
    var data = [OverlayDTO(overlayId: 0, overlayName: "None", overlayPreviewIconUrl: nil, overlayUrl: nil)]
    
    func fetchDataFromNetwork(completed: @escaping (_ success: Bool) -> Void) {
        NetworkManager.shared.getData(type: [OverlayDTO].self, .get, params: [:]) { result in
            switch result {
                
            case .success(let data):
                self.data.append(contentsOf: data)
                data.forEach { self.updateLocalData($0) }
                completed(true)
                
            case .failure(let error):
                self.getOverlaysFromLocalData { (succes) in
                    succes ? completed(true) : completed(false)
                    print(error)
                }
            }
        }
    }
    
    func getOverlaysFromLocalData(completed: @escaping (_ sucsess: Bool)-> Void){
        let overlayEntity = self.localData.fetch(OverlayEntity.self)
        overlayEntity.forEach {
            let overlay = OverlayDTO(overlayId: Int($0.overlayId), overlayName: $0.overlayName, overlayPreviewIconUrl: $0.overlayPreviewIconUrl, overlayUrl: $0.overlayUrl)
            self.data.append(overlay)
        }
        
        data = data.sorted( by: { $0.overlayId! < $1.overlayId! })
        completed(true)
    }

    func updateLocalData(_ overlayDTO: OverlayDTO) {
        let localOverlays = localData.fetch(OverlayEntity.self)
        if let localOverlay = localOverlays.filter({ Int($0.overlayId) == overlayDTO.overlayId }).first {
            localOverlay.overlayUrl = overlayDTO.overlayUrl
            localOverlay.overlayName = overlayDTO.overlayName
            localOverlay.overlayPreviewIconUrl = overlayDTO.overlayPreviewIconUrl
            localData.saveContext()
        } else {
            
            let overlayEntity = OverlayEntity(context: localData.context)
            overlayEntity.overlayUrl = overlayDTO.overlayUrl
            overlayEntity.overlayName = overlayDTO.overlayName
            overlayEntity.overlayPreviewIconUrl = overlayDTO.overlayPreviewIconUrl
            guard let int = overlayDTO.overlayId else { return }
            overlayEntity.overlayId = Int16(int)
        }
        localData.saveContext()
    }
}
