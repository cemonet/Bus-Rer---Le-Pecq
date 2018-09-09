//
//  PassageTableViewCell.swift
//  Bus Le Pecq
//
//  Created by EMONET Corentin on 05/09/2018.
//  Copyright © 2018 EMONET Corentin. All rights reserved.
//

import UIKit

final class PassageTableViewCell: UITableViewCell {
    private let restantLabel: UILabel = UILabel()
    private let busLabel: UILabel = UILabel()
    private let heureLabel: UILabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupSubviews()
        setupStyle()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with passage: Passage) {
        if let bus = passage.bus {
            restantLabel.text = bus.attente()
            busLabel.text = bus.line
            heureLabel.text = bus.heure()
            
            let couleur: UIColor = bus.isRT ? .blue : .red
            restantLabel.textColor = couleur
            busLabel.textColor = couleur
            heureLabel.textColor = couleur
        } else if let rer = passage.rer {
            restantLabel.text = rer.name
            busLabel.text = rer.destination
            heureLabel.text = rer.infos
            
            restantLabel.textColor = .blue
            busLabel.textColor = .blue
            heureLabel.textColor = .blue
        }
    }
    
    private func setupSubviews() {
        addSubview(restantLabel)
        addSubview(busLabel)
        addSubview(heureLabel)
    }
    
    private func setupStyle() {
        selectionStyle = .none
    }
    
    private func setupLayout() {
        for subview in subviews where subview != contentView {
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            restantLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            restantLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            busLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            busLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            heureLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            heureLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
