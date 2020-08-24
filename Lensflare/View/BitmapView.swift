//
//  BitmapView.swift
//  Lensflare
//
//  Created by Oguz on 21.08.2020.
//

import UIKit

final class BitmapView: UIView {
    
    private var isImageSetted = true
        
    private var givenImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private var overlayImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private let histogram: HistogramGraphView
    
    init(histogram: HistogramGraphView = HistogramDisplay()) {
        self.histogram = histogram
        super.init(frame: .zero)
        layer.masksToBounds = true
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit { print("bitMapView deinitialized") }
    
    convenience init(_ givenImage: UIImage) {
        self.init()
        self.givenImageView.image = givenImage
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.histogram.imageRef = givenImageView.image?.cgImage
    }
    
    func saveToLibrary(){
        guard let savingImage = givenImageView.image else { return }
        let frame = CGRect(x: 0, y: 0, width: savingImage.size.width, height: savingImage.size.height)
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        format.preferredRange = .extended
        let renderer = UIGraphicsImageRenderer(size: savingImage.size, format: format)
        histogram.isHidden = true
        let finalImage = renderer.image { ctx in
            self.drawHierarchy(in: frame, afterScreenUpdates: true)
            histogram.isHidden = false
        }
        
        UIImageWriteToSavedPhotosAlbum(finalImage, nil, nil, nil)
    }
    
        //MARK: Add Gestures
    
    private func addRotateGesture(view: UIView) {
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(handleRotate(_:)))
        rotate.delegate = self
        view.addGestureRecognizer(rotate)
    }
    
    private func addPinchGesture(view: UIView) {
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        pinch.delegate = self
        view.addGestureRecognizer(pinch)
    }
    
    private func addPanGesture(view: UIView) {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pan.delegate = self
        view.addGestureRecognizer(pan)
    }
    
        //MARK: Handle Gestures
    
    @objc func handlePinch(_ sender: UIPinchGestureRecognizer) {
        let image = sender.view!
        image.transform = image.transform.scaledBy(x: sender.scale, y: sender.scale)
        sender.scale = 1
    }
    
    @objc func handleRotate(_ sender: UIRotationGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            sender.view?.transform = sender.view!.transform.rotated(by: sender.rotation)
            sender.rotation = 0
        }
    }
    
    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        let image = sender.view!
        switch sender.state {
        case .began:
            print(sender.location(in: self))
        case .changed:
            moveViewWithPan(overlay: image, sender: sender)
        case .ended,.cancelled:
            print(sender.location(in: self))
        default:
            break
        }
    }
    
    private func moveViewWithPan(overlay: UIView, sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: givenImageView)
        overlay.center = CGPoint(x: overlay.center.x + translation.x, y: overlay.center.y + translation.y)
        sender.setTranslation(.zero, in: overlay)
    }
}
    //MARK: Setup Layouts
extension BitmapView {
    private func setupLayout() {
        addSubview(givenImageView)
        NSLayoutConstraint.activate([
            givenImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            givenImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            givenImageView.widthAnchor.constraint(equalTo: widthAnchor),
            givenImageView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
        
        addSubview(histogram)
        NSLayoutConstraint.activate([
            histogram.bottomAnchor.constraint(equalTo: bottomAnchor),
            histogram.trailingAnchor.constraint(equalTo: trailingAnchor),
            histogram.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
            histogram.heightAnchor.constraint(equalTo: histogram.widthAnchor, multiplier: 0.4)
        ])
        
        addSubview(overlayImageView)
        NSLayoutConstraint.activate([
            overlayImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            overlayImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            overlayImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            overlayImageView.heightAnchor.constraint(equalTo: overlayImageView.widthAnchor)
        ])
    }
}
    //MARK: ImageProcessorView Protocol
extension BitmapView: ImageProcessorView {
    func save() {
        saveToLibrary()
    }
    
    func process(_ imageURL: String?) {
        if isImageSetted {
            isImageSetted = !isImageSetted
            addPanGesture(view: overlayImageView)
            addPinchGesture(view: overlayImageView)
            addRotateGesture(view: overlayImageView)
        }

        if let imageURL = imageURL {
            overlayImageView.setImage(imageURL, isThumbNail: false)
        } else {
            overlayImageView.image = nil
        }
    }
}
    //MARK: UIGestureRecognizerDelegate Method
extension BitmapView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
