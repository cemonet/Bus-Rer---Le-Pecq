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
            
            restantLabel.textColor = .purple
            busLabel.textColor = .red
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
        
        restantLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        restantLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        busLabel.adjustsFontSizeToFitWidth = true
        busLabel.minimumScaleFactor = 0.1
        busLabel.font = UIFont.systemFont(ofSize: 16)
        busLabel.textAlignment = .center
        busLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        busLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        heureLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        heureLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private func setupLayout() {
        for subview in subviews where subview != contentView {
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            restantLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            restantLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            busLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            busLabel.leadingAnchor.constraint(equalTo: restantLabel.trailingAnchor, constant: 20),
            busLabel.trailingAnchor.constraint(equalTo: heureLabel.leadingAnchor, constant: -20),
            
            heureLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            heureLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
