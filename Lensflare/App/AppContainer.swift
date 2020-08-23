//
//  Builder.swift
//  Lensflare
//
//  Created by Oguz on 23.08.2020.
//

import UIKit

class AppContainer {
    
    func buildWithNavigation(_ viewModel:ViewModel) -> UINavigationController {
        let vc = ViewController(viewModel)
        return UINavigationController(rootViewController:vc)
    }
}
