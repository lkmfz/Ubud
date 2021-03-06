//
//  LocalResourceViewController.swift
//  Ubud-Example
//
//  Created by Luqman Fauzi on 23/10/2017.
//  Copyright © 2017 Luqman Fauzi. All rights reserved.
//

import UIKit
import Ubud

private let reuseIdentifier = "ImageCell"

final class LocalResourceViewController: UICollectionViewController {

    private lazy var images: [UIImage] = {
        return UIImage.generateRandomImages(count: 15)
    }()

    private var example: Example!

    public init(example: Example) {
        super.init(collectionViewLayout: ImagesFlowLayout())
        self.example = example
        self.view.translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.backgroundColor = UIColor.groupTableViewBackground
        collectionView?.alwaysBounceVertical = true
    }
}

extension LocalResourceViewController {

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ImageCell else {
            fatalError("Cell not found")
        }
        let image = images[indexPath.item]
        cell.configure(image: image)
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UbudController.show(
            presentedBy: self,
            dataSource: self,
            paginationDelegate: self,
            atIndex: indexPath.item
        )
    }
}

extension LocalResourceViewController: UbudControllerDataSource {

    // MARK: - UbudControllerDataSource

    func numberOfOPhotos(in controller: UbudController) -> Int {
        return images.count
    }

    func imageSourceForItem(in controller: UbudController, atIndex index: Int) -> PhotoDataSource {
        let image = images[index]
        return .image(image)
    }
}

extension LocalResourceViewController: UbudControllerPaginationDelegate {

    // MARK: - UbudControllerPaginationDelegate

    func imagesPaginationStyle(in controller: UbudController) -> ImagesPaginationStyle? {
        if example == .paginationTextExample {
            return .textIndicator
        } else {
            return .dotIndicator
        }
    }

    func imagesPaginationDidChange(in controller: UbudController, atIndex index: Int) {
        print("Did change at: \(index)")
    }
}
