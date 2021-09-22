//
//  StopWatchTableViewCell.swift
//  RxSwiftPractice
//
//  Created by Masato Takamura on 2021/09/23.
//

import UIKit

class StopWatchTableViewCell: UITableViewCell {
    static var className: String {
        String(describing: StopWatchTableViewCell.self)
    }

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var timeLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()

    }

    func configure(title: String, time: String) {
        titleLabel.text = title
        timeLabel.text = time
    }

    
}
