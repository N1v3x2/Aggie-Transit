//
//  Unnamed.swift
//  Aggie Transit
//
//  Created by Soham Nagawanshi on 12/16/22.
//

import UIKit

class BusRouteTableViewCell: UITableViewCell {
    private var cornerRadius: Double? = 36.75
    private let borderWidth = 1.5
    private var width: Double?
    private var height: Double?
    private var view: UIView?
    private var viewHeight: Double?
    private var viewWidth: Double?
    private var margins: UILayoutGuide?
    private var viewMargins: UILayoutGuide?
    private var iconLabel: UILabel?
    private var customTextLabel: UILabel?
    private var stackView: UIStackView?
    private var baseView: UIView?
    var icon: NSAttributedString?
    var text: String?
    var cellColor: UIColor?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutIfNeeded()
    }
    required init?(coder: NSCoder){
        fatalError()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.clearsContextBeforeDrawing = true
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.selectedBackgroundView = nil
        // access the views width and height
        width = self.contentView.frame.width
        height = self.contentView.frame.height
        self.contentView.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
        if let width = width, let height = height {
            // add a subview to the view and shape it accordingly
            viewHeight = 86.25 * (height/110)
            viewWidth = (355-16) * (width/375)
            if let viewHeight = viewHeight, let viewWidth = viewWidth {
                if let cornerRadius = cornerRadius{
                    view = UIView()
                    baseView = UIView()
                    if let view = view, let cellColor = cellColor, let baseView {
                        // configure the view
                        view.layer.cornerRadius = cornerRadius
                        view.layer.borderWidth = borderWidth
                        view.layer.borderColor = UIColor(named: "borderColor")?.cgColor
                        view.backgroundColor = cellColor
                        view.translatesAutoresizingMaskIntoConstraints = false
                        // configure base view
                        baseView.backgroundColor = UIColor(named: "launchScreenBackgroundColor")
                        baseView.translatesAutoresizingMaskIntoConstraints = false
                        // add to the view hierarchy
                        self.contentView.addSubview(baseView)
                        self.contentView.addSubview(view)
                        // add constraints
                        margins = self.safeAreaLayoutGuide
                        if let margins = margins {
                            view.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
                            view.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
                            view.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
                            view.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
                            baseView.heightAnchor.constraint(equalToConstant: viewHeight).isActive = true
                            baseView.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
                            baseView.centerXAnchor.constraint(equalTo: margins.centerXAnchor).isActive = true
                            baseView.centerYAnchor.constraint(equalTo: margins.centerYAnchor).isActive = true
                        }
                        // create stack view
                        stackView = UIStackView()
                        if let stackView = stackView{
                            // configure stackView
                            stackView.alignment = .leading
                            stackView.distribution = .equalCentering
                            stackView.axis = .horizontal
                            stackView.spacing = 8
                            stackView.translatesAutoresizingMaskIntoConstraints = false
                            // add stackview to view hierarchy
                            view.addSubview(stackView)
                            // add constraints
                            viewMargins = view.safeAreaLayoutGuide
                            if let viewMargins = viewMargins {
                                stackView.leadingAnchor.constraint(equalTo: viewMargins.leadingAnchor,constant: 30).isActive = true
                                stackView.centerYAnchor.constraint(equalTo: viewMargins.centerYAnchor).isActive = true
                            }
                            // create icon label and text label
                            iconLabel = UILabel()
                            customTextLabel = UILabel()
                            if let iconLabel = iconLabel, let customTextLabel = customTextLabel, let icon = icon, let text = text {
                                iconLabel.attributedText = icon
                                iconLabel.textColor = UIColor(named: "modalTableCellTextColor")
                                customTextLabel.text = text
                                customTextLabel.textColor = UIColor(named: "modalTableCellTextColor")
                                // add to view hierarchy
                                stackView.addArrangedSubview(iconLabel)
                                stackView.addArrangedSubview(customTextLabel)
                                
                            }
                        }
                        
                    }
                }
            }
            
        }
        
    }
    
}
