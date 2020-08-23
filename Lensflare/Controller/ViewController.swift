//
//  ViewController.swift
//  Lensflare
//
//  Created by Oguz on 21.08.2020.
//

import UIKit

protocol ViewControllerDelegate:class {
    func viewControllerDelegate(_ vc: ViewController, selected imageURL: String?)
    func viewControllerDelegate(_ vc: ViewController)
}

final class ViewController: UIViewController {
    
    weak var delegate: ViewControllerDelegate?
    
    private var collectionHeightConstraint = NSLayoutConstraint()
    
    private var data: [OverlayModel] = [OverlayModel(overlayId: 0, overlayName: "None", overlayPreviewIconUrl: nil, overlayUrl: nil)]
    
    private var thumbNails: [UIImage] = []
        
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.dataSource = self
        cv.contentInset.left = 10
        cv.contentInset.right = 10
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = #colorLiteral(red: 0.1097619608, green: 0.1096628532, blue: 0.1179399118, alpha: 1)
        cv.register(OverlayCell.self)
        return cv
    }()
    
    private var addImageButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(#imageLiteral(resourceName: "imageAddLarge"), for: .normal)
        b.tintColor = .darkGray
        b.addTarget(self, action:  #selector(addImageViewTapped), for: .touchUpInside)
        return b
    }()
            
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.04702279717, green: 0.04691094905, blue: 0.05519593507, alpha: 1)
        setupLayout()
        setupNavBar()
        getData()
    }
    
    private func showCollectionView() {
        collectionHeightConstraint.constant = view.frame.width*0.3
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func createBitMapViewWith(_ givenImage: UIImage) {
        addImageButton.removeFromSuperview()
        collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .left)
        let bitmapView = BitmapView(givenImage)
        delegate = bitmapView
        bitmapView.tag = 13
        let safeAreaHeight = view.frame.height - view.safeAreaInsets.bottom - view.safeAreaInsets.top
        bitmapView.frame.size = givenImage.fittingSizeForGiven(height: safeAreaHeight*0.7)
        bitmapView.center = CGPoint(x: view.center.x, y: view.center.y)
        self.view.addSubview(bitmapView)
    }
    
    private func removeBitmapView(){
        delegate = nil
        let bitmapView = view.subviews.filter({ $0.tag == 13 }).first
        bitmapView?.removeFromSuperview()
    }
    
    private func setupNavBar() {
        title = "Lensflare"
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTapped))
        }
    
    private func cacheWithImageIO(_ url: NSURL) -> UIImage? {
        guard let imageSource = CGImageSourceCreateWithURL(url, nil) else { return nil }
        
        let options: [NSString:Any] = [kCGImageSourceShouldCacheImmediately: true]
        let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, options as CFDictionary)! as NSDictionary
        guard let cachedImage = CGImageSourceCreateImageAtIndex(imageSource, 0, options as CFDictionary),
        let oriantation = imageProperties[kCGImagePropertyOrientation as String] as? Int else { return nil }

        let image = UIImage(cgImage: cachedImage, scale: 1, orientation: UIImage.Orientation(oriantation))
        
        return image
    }
    
    private func getData() {
        NetworkManager.shared.getData(type: [OverlayModel].self, .get, params: [:]) { result in
            switch result {
            case .success(let data):
                self.data.append(contentsOf: data)
                DispatchQueue.main.async { [weak self] in
                    self?.collectionView.reloadData()
                    self?.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .left)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc private func saveTapped() {
        delegate?.viewControllerDelegate(self)
        alert(title: "Saved!", message: "Photo successfully saved your libraries")
    }
    
    @objc private func addImageViewTapped() {
        showPickerAlert()
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ReusableView {
    static var defaultReuseIdentifier: String {
        return "OverlayCell"
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: OverlayCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.cellData = data[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width*0.18, height: collectionView.frame.height*0.9)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.viewControllerDelegate(self, selected: data[indexPath.item].overlayUrl)
    }
}

extension ViewController {
    private func setupLayout() {
        view.addSubview(addImageButton)
        NSLayoutConstraint.activate([
            addImageButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            addImageButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.7),
            addImageButton.heightAnchor.constraint(equalTo: addImageButton.widthAnchor),
            addImageButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -view.frame.width*0.2)
        ])
        
        collectionHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 0)
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionHeightConstraint
        ])
    }
}

//MARK: - UIIMagePickerControllerDelegate Methods
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showPickerAlert() {
        let photoLibraryAction = UIAlertAction(title: "Choose from library", style: .default) { (action) in
            self.showImagePicker(sourceType: .photoLibrary)
        }
        let cameraAction = UIAlertAction(title: "Take a photo", style: .default) { (action) in
            self.showImagePicker(sourceType: .camera)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        AlertService.showAlert(style: .actionSheet, title: "Add photo", message: nil, actions: [photoLibraryAction,cameraAction,cancel], completion: nil)
    }
    
    func showImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePicker: UIImagePickerController = {
            let picker = UIImagePickerController()
            picker.sourceType = sourceType
            picker.allowsEditing = true
            picker.delegate = self
            return picker
        }()
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imgUrl = info[UIImagePickerController.InfoKey.imageURL] as? NSURL{
            self.removeBitmapView()
            let image = cacheWithImageIO(imgUrl) ?? UIImage()
            self.createBitMapViewWith(image)
        }
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Change", style: .plain, target: self, action: #selector(self.addImageViewTapped))
        dismiss(animated: true) {
            if self.collectionHeightConstraint.constant == 0 {
                self.showCollectionView()
            }
        }
    }
}

