//
//  HomeScreenModalTableViewCell.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 11/9/22.
//

import UIKit

class HomeScreenModalTableViewCell: UITableViewCell {
    let icon: String
    let text: String
    let cellColor: cellBackgroundColor
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String, icon: String, text: String, cellColor: cellBackgroundColor) {
        self.icon = icon
        self.text = text
        self.cellColor = cellColor
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        // scale height and width appropriately based on modal's height and width
            // keep height, corner radius of cells the same for all phones, adjust width accordingly
        let height = 86.25
        let width = HomeScreenModalViewController().view.frame.width - 20 * (375/HomeScreenModalViewController().view.frame.width)
        let cornerRadius = 36.75
        // add a subview to the content view and shape it accordingly
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        view.layer.cornerRadius = cornerRadius
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(named: "borderColor")?.cgColor
        view.backgroundColor = UIColor(named: self.cellColor.rawValue)
        // add view to hierarchy and constrain it
        let contentViewMargins = self.contentView.safeAreaLayoutGuide
        self.contentView.addSubview(view)
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
        view.widthAnchor.constraint(equalToConstant: width).isActive = true
        view.centerXAnchor.constraint(equalTo: contentViewMargins.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: contentViewMargins.centerYAnchor).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        // create two labels and embed in horizontal stack view
        let iconLabel = UILabel()
        iconLabel.text = self.icon
        iconLabel.textColor = UIColor(named: "modalTableCellTextColor")
        let textLabel = UILabel()
        textLabel.text = self.text
        textLabel.textColor = UIColor(named: "modalTableCellTextColor")
        let stackview = UIStackView()
        stackview.addArrangedSubview(iconLabel)
        stackview.addArrangedSubview(textLabel)
        stackview.alignment = .leading
        stackview.distribution = .equalCentering
        stackview.axis = .horizontal
        stackview.spacing = 8
        // add stackview to view hierarchy and add constraints
        view.addSubview(stackview)
        let margins = view.layoutMarginsGuide
        stackview.leadingAnchor.constraint(equalTo: margins.leadingAnchor,constant: 10).isActive = true
        stackview.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
        stackview.translatesAutoresizingMaskIntoConstraints = false
    }
}

enum cellBackgroundColor: String {
    case all = "all"
    case reveilleRed = "reveilleRed"
    case oldArmyGreen = "oldArmyGreen"
    case excelPink = "excelPink"
    case rudderGreen = "rudderGreen"
    case ringDanceBlue = "ringDanceBlue"
    case ewalkPurple = "ewalkPurple"
    case fishCampOrange = "fishCampOrange"
    case hullaballoBrown = "hullaballoBrown"
    case matthewGainesBrown = "matthewGainesBrown"
    case centuryTreeRed = "centuryTreeRed"
    case rellisBlue = "rellisBlue"
    case nightsAndWeekendsRed = "nightsAndWeekendsRed"
    case rellisCirculatorBlue = "rellisCirculatorBlue"
    case thursdayAndFridayGreen = "thursdayAndFridayGreen"
    case bonfirePurple = "bonfirePurple"
    case nightsAndWeekendsPurple = "nightsAndWeekendsPurple"
    case yellPracticeBlack = "yellPracticeBlack"
    case nightsAndWeekendsBrown = "nightsAndWeekendsBrown"
    case gigEmRed = "gigEmRed"
    case bushSchoolBlue = "bushSchoolBlue"
    case twelfthManGreen = "twelfthManGreen"
    case airportTeal = "airportTeal"
    case howdyPurple = "howdyPurple"
    case ringDayRed = "ringDayRed"
    case excelModifiedPink = "excelModifiedPink"
    case rudderModifiedGreen = "rudderModifiedGreen"
    case ewalkModifiedPurple = "ewalkModifiedPurple"
    case hullabalooModifiedBrown = "hullabalooModifiedBrown"
    case agronomyRdOrange = "agronomyRdOrange"
    case bonfireRed = "bonfireRed"
    case bushLibrarySalmon = "bushLibrarySalmon"
    case downtownBryanBlue = "downtownBryanBlue"
    case paraShuttleRed = "paraShuttleRed"
    case reedOlsenPink = "reedOlsonPink"
    case stotzerBlue = "stotzerBlue"
    case whrTeal = "whrTeal"
    case favoriteLocationGold = "favoriteLocationGold"
    case recentLocationRed = "recentLocationRed"
}