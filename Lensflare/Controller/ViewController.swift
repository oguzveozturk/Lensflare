//
//  ViewController.swift
//  Lensflare
//
//  Created by Oguz on 21.08.2020.
//

import UIKit

final class ViewController: UIViewController {
    
    private var data: [OverlayModel] = [OverlayModel(overlayId: 0, overlayName: "None", overlayPreviewIconUrl: nil, overlayUrl: nil)]
        
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = #colorLiteral(red: 0.1097619608, green: 0.1096628532, blue: 0.1179399118, alpha: 1)
        cv.register(OverlayCell.self, forCellWithReuseIdentifier: OverlayCell.identifier)
        return cv
    }()
    
    private var addImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.image = #imageLiteral(resourceName: "imageAddLarge").withTintColor(.darkGray)
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.04702279717, green: 0.04691094905, blue: 0.05519593507, alpha: 1)
        setupLayout()
        setupNavBar()
        getData()
        addImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addImageViewTapped)))
    }
    
    private func setupNavBar() {
        title = "Overlay"
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTapped))
        }
    
    private func getData() {
        NetworkManager.shared.getData(type: [OverlayModel].self, .get, params: [:]) { result in
            switch result {
            case .success(let data):
                print(data)
                self.data.append(contentsOf: data)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .left)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc private func saveTapped() {
        print("saved")
    }
    
    @objc private func addImageViewTapped() {
        showPickerAlert()
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OverlayCell.identifier, for: indexPath) as? OverlayCell else { return UICollectionViewCell() }
        cell.index = indexPath.item
        cell.cellData = data[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width*0.18, height: collectionView.frame.width*0.18)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return view.frame.width*0.05
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: view.frame.width*0.05, bottom: 0, right: view.frame.width*0.05)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NetworkManager.shared.downloadImage(urlString: data[indexPath.item].overlayUrl) { (image, error) in
            DispatchQueue.main.async {
            self.addImageView.image = image
            }
        }
    }
}

extension ViewController {
    func setupLayout() {
        
        view.addSubview(addImageView)
        NSLayoutConstraint.activate([
            addImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            addImageView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.7),
            addImageView.heightAnchor.constraint(equalTo: addImageView.widthAnchor),
            addImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -view.frame.width*0.2)
        ])
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.21)
            
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
            picker.navigationItem.rightBarButtonItem?.title = "Geri"
            return picker
        }()
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageEdited = info[UIImagePickerController.InfoKey.editedImage] as? UIImage  {
            self.addImageView.image = imageEdited
        }else if let imageEdited = info[UIImagePickerController.InfoKey.originalImage] as? UIImage  {
            self.addImageView.image = imageEdited
        }
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Change", style: .plain, target: self, action: #selector(self.addImageViewTapped))
        
        dismiss(animated: true, completion: nil)
    }
}
