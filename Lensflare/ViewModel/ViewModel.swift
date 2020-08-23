//
//  OverlayCellViewModel.swift
//  Lensflare
//
//  Created by Oguz on 23.08.2020.
//

import Foundation

final class ViewModel: NSObject {
    
    var data = [OverlayDTO(overlayId: 0, overlayName: "None", overlayPreviewIconUrl: nil, overlayUrl: nil)]
    
    func fetchData(completed: @escaping (_ success: Bool) -> Void) {
        NetworkManager.shared.getData(type: [OverlayDTO].self, .get, params: [:]) { result in
            switch result {
                
            case .success(let data):
                self.data.append(contentsOf: data)
                completed(true)
                
            case .failure(let error):
                completed(false)
                print(error)
            }
        }
    }
}
