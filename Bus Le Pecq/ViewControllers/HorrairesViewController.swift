//
//  HorrairesViewController.swift
//  Bus Le Pecq
//
//  Created by EMONET Corentin on 06/09/2018.
//  Copyright © 2018 EMONET Corentin. All rights reserved.
//

import UIKit
import WebKit

final class HorrairesViewController: UIViewController {
    private let itineraire: Itineraire
    
    private let backButton: UIButton = UIButton()
    private let titleLabel: UILabel = UILabel()
    private let webView: WKWebView = WKWebView()
    
    init(itineraire: Itineraire) {
        self.itineraire = itineraire
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url: String = API.shared.urlBus(for: itineraire)
        let myURL = URL(string: url)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        
        setupSubviews()
        setupStyle()
        setupLayout()
    }
    
    private func setupSubviews() {
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(webView)
    }
    
    private func setupStyle() {
        view.backgroundColor = .white
        
        backButton.setTitle("Retour", for: .normal)
        backButton.setTitleColor(.black, for: .normal)
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        
        titleLabel.text = "\(itineraire.name) - \(itineraire.line.rawValue)"
        titleLabel.textAlignment = .right
        
        var transform: CGAffineTransform = CGAffineTransform(scaleX: 2, y: 2)
        transform = transform.translatedBy(x: UIScreen.main.bounds.width / 4, y: UIScreen.main.bounds.height / 4)
        webView.transform = transform
    }
    
    private func setupLayout() {
        for subview in view.subviews {
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 55),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: backButton.bottomAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func didTapBack() {
        dismiss(animated: true, completion: nil)
    }
}
