//
//  UICollectionView+Register.swift
//  Lensflare
//
//  Created by Oguz on 23.08.2020.
//

import UIKit

protocol ReusableView: class {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}

//Confirming Collection View and TableView for Registering and Dequeing
extension UICollectionView {
    func register<T: UICollectionViewCell>(_: T.Type) where T: ReusableView {
        register(T.self, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    //Registering Supplementary View
    
    func register<T: UICollectionReusableView>(_: T.Type, supplementaryViewOfKind: String) where T: ReusableView {
        register(T.self, forSupplementaryViewOfKind: supplementaryViewOfKind, withReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    //Dequeing
    
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }
    
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind: String, indexPath: IndexPath) -> T where T: ReusableView {
        guard let supplementaryView = dequeueReusableSupplementaryView(ofKind: ofKind, withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue supplementary view with identifier: \(T.defaultReuseIdentifier)")
        }
        return supplementaryView
    }
}
