//
//  FeedCell.swift
//  RSSNewsReader
//
//  Created by Diana Agapkina on 27.11.20.
//

import UIKit

protocol FeedCellDelegate: class {
    func addFeedToFeatured(cell: FeedCell)
}

class FeedCell: UITableViewCell {

    // MARK: - Properties
    weak var delegate: FeedCellDelegate?
    
    var feed: Feed? {
        didSet {
            titleLabel.text = feed?.title
            descriptionLabel.text = feed?.description.trim().removeHtmlTags()
            dateLabel.text = feed?.pubDate.formatDate()
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.numberOfLines = 4
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.isUserInteractionEnabled = false

        let stack = UIStackView(arrangedSubviews: [titleLabel, dateLabel, descriptionLabel])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 5

        addSubview(stack)
        stack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
