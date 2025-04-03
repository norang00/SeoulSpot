//
//  EventDetailView.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 3/31/25.
//

import UIKit

final class EventDetailView: BaseView {

    let posterImageView = UIImageView()
    let pinButton = UIButton(type: .system)
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()

    private let infoStackView = UIStackView()

    private let dateTitleLabel = UILabel()
    private let dateValueLabel = UILabel()

    private let placeTitleLabel = UILabel()
    private let placeValueLabel = UILabel()

    private let targetTitleLabel = UILabel()
    private let targetValueLabel = UILabel()

    private let feeTitleLabel = UILabel()
    private let feeValueLabel = UILabel()

    private let categoryTitleLabel = UILabel()
    private let categoryValueLabel = UILabel()
    
    let linkButton = UIButton(type: .system)
    
    let emptyView = UIView()
    
    override func setupHierarchy() {
        
        [posterImageView, pinButton,
         titleLabel, subtitleLabel,
         linkButton, emptyView].forEach {
            addSubview($0)
        }
        
        let dateRow = UIStackView(arrangedSubviews: [dateTitleLabel, dateValueLabel])
        let placeRow = UIStackView(arrangedSubviews: [placeTitleLabel, placeValueLabel])
        let targetRow = UIStackView(arrangedSubviews: [targetTitleLabel, targetValueLabel])
        let feeRow = UIStackView(arrangedSubviews: [feeTitleLabel, feeValueLabel])
        let categoryRow = UIStackView(arrangedSubviews: [categoryTitleLabel, categoryValueLabel])
        
        [dateRow, placeRow, targetRow, feeRow, categoryRow].forEach {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.distribution = .fillProportionally
            infoStackView.addArrangedSubview($0)
        }
        
        infoStackView.axis = .vertical
        infoStackView.spacing = 12
        
        addSubview(infoStackView)
    }
    
    override func setupLayout() {
        posterImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(520)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(posterImageView.snp.bottom).offset(16)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(20)
            $0.width.equalTo(320)
        }

        pinButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(10)
            $0.trailing.equalTo(safeAreaLayoutGuide).inset(10)
            $0.height.equalTo(titleLabel)
        }

        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        infoStackView.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(20)
        }

        linkButton.snp.makeConstraints {
            $0.top.equalTo(infoStackView.snp.bottom).offset(10)
            $0.centerX.equalTo(safeAreaLayoutGuide)
        }
        
        emptyView.snp.makeConstraints {
            $0.top.equalTo(linkButton.snp.bottom)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide)
            $0.height.greaterThanOrEqualTo(8)
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
    }

    override func setupView() {
        backgroundColor = .white

        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true

        titleLabel.font = .pretendardBold(ofSize: 20)
        titleLabel.numberOfLines = 2
        titleLabel.adjustsFontSizeToFitWidth = true

        [subtitleLabel].forEach {
            $0.font = .pretendardRegular(ofSize: 14)
            $0.numberOfLines = 0
        }
        
        [dateTitleLabel, placeTitleLabel, targetTitleLabel, feeTitleLabel, categoryTitleLabel].forEach {
            $0.textColor = .secondaryLabel
            $0.font = .pretendardMedium(ofSize: 14)
            $0.setContentHuggingPriority(.required, for: .horizontal)
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
            $0.snp.makeConstraints { $0.width.equalTo(60) } // ✅ 너비 고정 (예: 60pt)
        }

        [dateValueLabel, placeValueLabel, targetValueLabel, feeValueLabel, categoryValueLabel].forEach {
            $0.font = .pretendardRegular(ofSize: 14)
            $0.textColor = .label
        }

        dateTitleLabel.text = "기간"
        placeTitleLabel.text = "장소"
        targetTitleLabel.text = "대상"
        feeTitleLabel.text = "요금"
        categoryTitleLabel.text = "카테고리"
        linkButton.setTitle("공식 홈페이지 바로가기", for: .normal)
    }

    func configure(with event: CulturalEvent) {
        pinButton.setImage(UIImage(systemName: "pin"), for: .normal)
        pinButton.tintColor = .systemOrange
        
        titleLabel.text = event.title
        subtitleLabel.text = "\(event.orgName) · \(event.guName)"
        dateValueLabel.text = event.date
        placeValueLabel.text = event.place
        targetValueLabel.text = event.useTarget ?? "누구나"
        feeValueLabel.text = ((event.useFee?.isEmpty) != nil) ? "-" : event.useFee
        categoryValueLabel.text = event.codeName
        
        if let url = URL(string: event.mainImage ?? "") {
            posterImageView.loadImage(from: url)
        }

        if let link = event.orgLink, let url = URL(string: link) { // [TODO] WebView 로 전환
            linkButton.addAction(UIAction(handler: { _ in
                UIApplication.shared.open(url)
            }), for: .touchUpInside)
        } else {
            linkButton.isHidden = true
        }
    }
}
