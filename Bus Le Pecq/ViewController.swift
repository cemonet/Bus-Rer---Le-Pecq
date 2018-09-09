//
//  ViewController.swift
//  Bus Le Pecq
//
//  Created by EMONET Corentin on 05/09/2018.
//  Copyright © 2018 EMONET Corentin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    enum Categorie {
        case paris
        case cergy
        case rer
        
        var name: String {
            switch self {
            case .paris: return "Paris"
            case .cergy: return "Cergy"
            case .rer: return "RER"
            }
        }
        
        var itineraires: [Itineraire] {
            switch self {
            case .paris:
                return [
                    .brossoletteAller,
                    .vesinetLePecqRetour
                ]
            case .cergy:
                return [
                    .saintGermainEnlayeAller,
                    .cergyPrefectureRetour,
                    .neuvilleUniversiteRetour
                ]
            case .rer:
                return [
                    .vesinetLePecqAllerRer,
                    .saintGermainEnLayeAllerRer,
                    .gareDeLyonRetourRer
                ]
            }
        }
    }
    
    private let segmentedControl: UISegmentedControl = UISegmentedControl()
    private let tableView: UITableView = UITableView(frame: .zero, style: UITableViewStyle.grouped)
    
    private let categories: [Categorie] = [
        .paris,
        .cergy,
        .rer
    ]
    
    private var passages: [Itineraire: [Passage]] = [:]
    
    private var buttons: [Itineraire: UIButton] = [:]
    
    private var categorie: Categorie {
        return categories[segmentedControl.selectedSegmentIndex]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        setupStyle()
        setupLayout()
        
        loadItineraires()
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.tableView.reloadData()
        }
    }
    
    private func setupSubviews() {
        view.addSubview(segmentedControl)
        view.addSubview(tableView)
    }
    
    private func setupStyle() {
        tableView.register(PassageTableViewCell.self, forCellReuseIdentifier: "passage")
        tableView.dataSource = self
        tableView.delegate = self
        
        segmentedControl.addTarget(self, action: #selector(didChangeSegmented(sender:)), for: .valueChanged)
        
        for (i, categorie) in categories.enumerated() {
            segmentedControl.insertSegment(withTitle: categorie.name, at: i, animated: false)
        }
        segmentedControl.selectedSegmentIndex = 0
    }
    
    private func setupLayout() {
        for subview in view.subviews {
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            segmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 44),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            segmentedControl.heightAnchor.constraint(equalToConstant: 44),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadItineraires() {
        for itineraire in categorie.itineraires where passages[itineraire] == nil {
            loadPassages(for: itineraire)
        }
    }
    
    private func loadPassages(for itineraire: Itineraire) {
        API.shared.passages(for: itineraire) { [weak self] success, passages in
            guard let strongSelf = self else { return }
            
            strongSelf.buttons[itineraire]?.isHidden = false
            
            if success {
                strongSelf.passages[itineraire] = passages
                strongSelf.tableView.reloadData()
            }
        }
    }
    
    @objc private func didTapReload(button: UIButton) {
        let itineraire: Itineraire = categorie.itineraires[button.tag]
        buttons[itineraire]?.isHidden = true
        loadPassages(for: itineraire)
    }
    
    @objc private func didChangeSegmented(sender: UISegmentedControl) {
        tableView.reloadData()
        loadItineraires()
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return categorie.itineraires.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let passages = passages[categorie.itineraires[section]] else { return 0 }
        
        return passages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let passages = passages[categorie.itineraires[indexPath.section]] else { return UITableViewCell() }
        
        let passage: Passage = passages[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "passage", for: indexPath) as? PassageTableViewCell {
            cell.configure(with: passage)
            return cell
        }
        
        return UITableViewCell()
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view: UIView = UIView()
        
        let label: UILabel = UILabel()
        label.text = categorie.itineraires[section].name
        label.font = UIFont.systemFont(ofSize: 14)
        
        var buttonOpt: UIButton?
        
        if let savedButton = buttons[categorie.itineraires[section]] {
            savedButton.removeConstraints(savedButton.constraints)
            savedButton.removeFromSuperview()
            buttonOpt = savedButton
        } else {
            let newButton: UIButton = UIButton()
            newButton.setTitle("🔄", for: .normal)
            newButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            newButton.addTarget(self, action: #selector(didTapReload), for: .touchUpInside)
            newButton.translatesAutoresizingMaskIntoConstraints = false
            newButton.tag = section
            newButton.isHidden = true
            buttonOpt = newButton
            buttons[categorie.itineraires[section]] = newButton
        }
        
        guard let button = buttonOpt else { return nil }
        
        view.addSubview(label)
        view.addSubview(button)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            label.heightAnchor.constraint(equalToConstant: 50),
            
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            button.topAnchor.constraint(equalTo: view.topAnchor),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            button.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itineraire: Itineraire = categorie.itineraires[indexPath.section]
        let horrairesVC: HorrairesViewController = HorrairesViewController(itineraire: itineraire)
        present(horrairesVC, animated: true, completion: nil)
    }
}

