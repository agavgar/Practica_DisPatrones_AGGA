//
//  HomeCustomCollectionViewCell.swift
//  Practica_DisPatrones_AGGA
//
//  Created by Alejandro Alberto Gavira García on 23/1/24.
//

import UIKit

final class HomeCustomCollectionViewCell: UICollectionViewCell {

    //MARK: - Identifier
    static let identifier = "HomeCustomCollectionViewCell"
    
    //MARK: - Outlets
    @IBOutlet weak var heroLabel: UILabel!
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var heroFavorite: UIImageView!
    
    
    //MARK: - Configure
    func configure(with hero: DragonBallHero){
        heroLabel.text = hero.name
        heroImage.setImage(url: hero.photo)
        heroFavorite.isHidden = !hero.favorite
    }

}
