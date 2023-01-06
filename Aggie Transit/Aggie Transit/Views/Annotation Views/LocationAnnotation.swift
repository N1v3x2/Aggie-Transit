//
//  LocationAnnotation.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 1/3/23.
//

import Foundation
import MapKit
// used to differentiate between annotations
class LocationAnnotation: MKPointAnnotation {
    
}

class LocationAnnotationView: MKAnnotationView {
    private var directionsButton: UIButton?
    private var directionsButtonHeight: Double?
    private var directionsButtonWidth: Double?
    private var favoritesButton: UIButton?
    private var favoritesButtonHeight: Double?
    private var favoriesButtonWidth: Double?
    private var nameLabel: UILabel?
    private var addressLabel: UILabel?
    private var stackView: UIStackView?
    private var buttonStack: UIStackView?
    private var width: Double?
    private var height: Double?
    private var safeMargins: UILayoutGuide?
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.frame = CGRect(x: 0, y: 0, width: 175, height: 84)
        clusteringIdentifier = "location"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        self.nameLabel?.isHidden = true
        self.addressLabel?.isHidden = true
        self.favoritesButton?.isHidden = true
        self.directionsButton?.isHidden = true
        super.prepareForReuse()
    }
    override func prepareForDisplay() {
        super.prepareForDisplay()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        height = self.frame.height
        width = self.frame.width
        self.backgroundColor = UIColor(named:"launchScreenBackgroundColor")
        self.layer.cornerRadius = 15
        if let height = height, let width = width {
            directionsButtonHeight = 20 * (height/84)
            favoritesButtonHeight = directionsButtonHeight
            directionsButtonWidth = 139 * (width/175)
            favoriesButtonWidth = width - 10 - directionsButtonWidth!
            stackView = UIStackView()
            buttonStack = UIStackView()
            nameLabel = UILabel()
            addressLabel = UILabel()
            safeMargins = self.safeAreaLayoutGuide
            if let nameLabel = nameLabel, let addressLabel = addressLabel, let directionsButtonWidth = directionsButtonWidth, let directionsButtonHeight = directionsButtonHeight, let favoriesButtonWidth = favoriesButtonWidth, let favoritesButtonHeight = favoritesButtonHeight, let stackView = stackView, let buttonStack = buttonStack, let safeMargins = safeMargins {
                // confiure vertical stack view
                stackView.axis = .vertical
                stackView.translatesAutoresizingMaskIntoConstraints = false
                stackView.spacing = 0//5 * (height/84)
                stackView.alignment = .center
                stackView.clipsToBounds = true
                // add to view hierarchy
                self.addSubview(stackView)
                // add constraints
                stackView.leadingAnchor.constraint(equalTo: safeMargins.leadingAnchor,constant: 2 * (width/175)).isActive = true
                stackView.trailingAnchor.constraint(equalTo: safeMargins.trailingAnchor,constant: 2 * (width/175)).isActive = true
                stackView.centerYAnchor.constraint(equalTo: safeMargins.centerYAnchor).isActive = true
                // configure the text label
                nameLabel.translatesAutoresizingMaskIntoConstraints = false
                nameLabel.textAlignment = .center
                addressLabel.translatesAutoresizingMaskIntoConstraints = false
                addressLabel.textAlignment = .center
                nameLabel.clipsToBounds = true
                addressLabel .clipsToBounds = true
                addressLabel.lineBreakMode = .byTruncatingTail
                nameLabel.lineBreakMode = .byTruncatingTail
                nameLabel.numberOfLines = 0
                guard let name = annotation?.title, let address = annotation?.subtitle else {return}
                let nameAttributes: [NSAttributedString.Key:Any] = [
                    .font : UIFont.boldSystemFont(ofSize: 12),
                    .foregroundColor : UIColor(named: "textColor") ?? .black
                ]
                let addressAttributes: [NSAttributedString.Key:Any] = [
                    .font : UIFont.systemFont(ofSize: 10),
                    .foregroundColor: UIColor(named: "textColor") ?? .black
                ]
                nameLabel.attributedText = NSAttributedString(string: name!, attributes: nameAttributes)
                addressLabel.attributedText = NSAttributedString(string: address!, attributes: addressAttributes)
                // add the label to the view hierarchy
                stackView.addArrangedSubview(nameLabel)
                stackView.addArrangedSubview(addressLabel)
                // configure the horizontal stack view
                buttonStack.axis = .horizontal
                buttonStack.translatesAutoresizingMaskIntoConstraints = false
                buttonStack.spacing = 2 * (width/175)
                buttonStack.alignment = .leading
                // add to view hierarcy
                stackView.addArrangedSubview(buttonStack)
                // configure the buttons
                favoritesButton = UIButton(type: .system)
                directionsButton = UIButton(type: .system)
                if let favoritesButton = favoritesButton, let directionsButton = directionsButton {
                    favoritesButton.backgroundColor = UIColor(named: "favoriteLocationGold")
                    favoritesButton.setTitle("⭐️", for: .normal)
                    directionsButton.backgroundColor = .systemBlue
                    directionsButton.setTitle("Directions", for: .normal)
                    favoritesButton.translatesAutoresizingMaskIntoConstraints = false
                    directionsButton.translatesAutoresizingMaskIntoConstraints = false
                    favoritesButton.layer.cornerRadius = 5
                    directionsButton.layer.cornerRadius = 5
                    favoritesButton.addTarget(self, action: #selector(handleFavoritesPressed), for: .touchUpInside)
                    directionsButton.addTarget(self, action: #selector(handleDirectionsPressed), for: .touchUpInside)
                    // add to view hierarchy
                    buttonStack.addArrangedSubview(favoritesButton)
                    buttonStack.addArrangedSubview(directionsButton)
                    // constrain the width and height
                    favoritesButton.heightAnchor.constraint(equalToConstant: favoritesButtonHeight).isActive = true
                    favoritesButton.widthAnchor.constraint(equalToConstant: favoriesButtonWidth).isActive = true
                    directionsButton.heightAnchor.constraint(equalToConstant: directionsButtonHeight).isActive = true
                    directionsButton.widthAnchor.constraint(equalToConstant: directionsButtonWidth).isActive = true
                }
            }
            
        }
        
    }
}
//MARK: - Handle the buttons being pressed
extension LocationAnnotationView {
    @objc func handleDirectionsPressed(sender: UIButton){
        print("implement this method")
        print(self.annotation?.title, self.annotation?.subtitle)
    }
    @objc func handleFavoritesPressed(sender: UIButton){
        print("implement this method")
        print(self.annotation?.title, self.annotation?.subtitle)
    }
}

