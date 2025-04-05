//
//  EventDetailView.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 3/31/25.
//

import UIKit
import SnapKit
import CoreData

final class EventDetailView: BaseView {

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let posterImageView = UIImageView()
    private var posterImageViewHeightConstraint: Constraint?
    
    private let pinButton = UIButton(type: .system)
    var onPinTapped: (() -> Void)?

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    private let infoStackView = UIStackView()

    private let categoryTitleLabel = UILabel()
    private let categoryValueLabel = UILabel()
    
    private let dateTitleLabel = UILabel()
    private let dateValueLabel = UILabel()

    private let placeTitleLabel = UILabel()
    private let placeValueLabel = UILabel()

    private let targetTitleLabel = UILabel()
    private let targetValueLabel = UILabel()

    private let feeTitleLabel = UILabel()
    private let feeValueLabel = UILabel() // [TODO] 요금 값이 제대로 안들어가고 있음
    
    private let playerTitleLabel = UILabel()
    private let playerValueLabel = UILabel()

    private let programTitleLabel = UILabel()
    private let programValueLabel = UILabel()

    private let descriptionTitleLabel = UILabel()
    private let descriptionValueLabel = UILabel()

    private let linkButton = UIButton(type: .system)
        
    override func setupHierarchy() {
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [posterImageView, pinButton,
         titleLabel, subtitleLabel, linkButton].forEach {
            contentView.addSubview($0)
        }
        
        let categoryRow = UIStackView(arrangedSubviews: [categoryTitleLabel, categoryValueLabel])
        let dateRow = UIStackView(arrangedSubviews: [dateTitleLabel, dateValueLabel])
        let placeRow = UIStackView(arrangedSubviews: [placeTitleLabel, placeValueLabel])
        let targetRow = UIStackView(arrangedSubviews: [targetTitleLabel, targetValueLabel])
        let feeRow = UIStackView(arrangedSubviews: [feeTitleLabel, feeValueLabel])
        let playerRow = UIStackView(arrangedSubviews: [playerTitleLabel, playerValueLabel])
        let programRow = UIStackView(arrangedSubviews: [programTitleLabel, programValueLabel])
        let descriptionRow = UIStackView(arrangedSubviews: [descriptionTitleLabel, descriptionValueLabel])
        
        [categoryRow, dateRow, placeRow, targetRow, feeRow, playerRow, programRow, descriptionRow].forEach {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.distribution = .fillProportionally
            $0.alignment = .top
            infoStackView.addArrangedSubview($0)
        }
        
        infoStackView.axis = .vertical
        infoStackView.spacing = 10
        
        contentView.addSubview(infoStackView)
    }
    
    override func setupLayout() {

        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView)
        }
        
        posterImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(-44)
            $0.horizontalEdges.equalTo(contentView)
            self.posterImageViewHeightConstraint = $0.height.equalTo(100).constraint
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(posterImageView.snp.bottom).offset(16)
            $0.leading.equalTo(contentView).inset(20)
            $0.trailing.lessThanOrEqualTo(pinButton.snp.leading).offset(-10)
        }

        pinButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalTo(contentView).inset(10)
            $0.width.equalTo(30)
            $0.height.equalTo(titleLabel)
        }

        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(contentView).inset(20)
        }
        
        infoStackView.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(contentView).inset(20)
        }

        linkButton.snp.makeConstraints {
            $0.top.equalTo(infoStackView.snp.bottom).offset(10)
            $0.centerX.equalTo(contentView)
            $0.bottom.equalTo(contentView)
        }
    }

    override func setupView() {
        backgroundColor = .white

        posterImageView.contentMode = .scaleAspectFit

        titleLabel.font = .pretendardBold(ofSize: 20)
        titleLabel.numberOfLines = 2
        titleLabel.adjustsFontSizeToFitWidth = true
        
        pinButton.setImage(UIImage(systemName: "pin"), for: .normal)
        pinButton.tintColor = .systemOrange
        pinButton.addTarget(self, action: #selector(pinTapped), for: .touchUpInside)

        [subtitleLabel].forEach {
            $0.font = .pretendardRegular(ofSize: 14)
            $0.numberOfLines = 0
        }
        
        [categoryTitleLabel, dateTitleLabel, placeTitleLabel, targetTitleLabel, feeTitleLabel,
         playerTitleLabel, programTitleLabel, descriptionTitleLabel].forEach {
            $0.textColor = .secondaryLabel
            $0.font = .pretendardMedium(ofSize: 14)
            $0.setContentHuggingPriority(.required, for: .horizontal)
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
            $0.snp.makeConstraints { $0.width.equalTo(60) }
        }

        [categoryValueLabel, dateValueLabel, placeValueLabel, targetValueLabel, feeValueLabel,
         playerValueLabel, programValueLabel, descriptionValueLabel].forEach {
            $0.font = .pretendardRegular(ofSize: 14)
            $0.textColor = .label
            $0.numberOfLines = 0
        }

        categoryTitleLabel.text = "카테고리"
        dateTitleLabel.text = "기간"
        placeTitleLabel.text = "장소"
        targetTitleLabel.text = "대상"
        feeTitleLabel.text = "요금"
        playerTitleLabel.text = "시행" // [TODO] 워딩 고민..
        programTitleLabel.text = "프로그램" // [TODO] 워딩 고민..
        descriptionTitleLabel.text = "부가 설명" // [TODO] 워딩 고민..
        linkButton.setTitle("공식 홈페이지 바로가기", for: .normal)
    }

    func configure(with event: CulturalEventModel, _ isPinned: Bool) {
        categoryValueLabel.text = event.codeName.orDash
        titleLabel.text = event.title.orDash
        subtitleLabel.text = "\(event.orgName.orDash) · \(event.guName.orDash)"
        dateValueLabel.text = event.date.orDash
        placeValueLabel.text = event.place.orDash
        targetValueLabel.text = event.useTarget ?? "누구나"
        feeValueLabel.text = event.useFee.orDash
        playerValueLabel.text = event.player.orDash
        programValueLabel.text = event.program.orDash
        descriptionValueLabel.text = event.etcDesc.orDash
        
        if let url = URL(string: event.mainImage ?? "") {
            posterImageView.loadImage(from: url) { [weak self] image in
                guard let self = self, let image = image else { return }

                let width = UIScreen.main.bounds.width
                let aspectRatio = image.size.height / image.size.width
                let newHeight = width * aspectRatio
                
                self.posterImageViewHeightConstraint?.update(offset: newHeight)
                self.layoutIfNeeded()
            }
        }

        if let link = event.orgLink, let url = URL(string: link) { // [TODO] WebView 로 전환
            linkButton.addAction(UIAction(handler: { _ in
                UIApplication.shared.open(url)
            }), for: .touchUpInside)
        } else {
            linkButton.isHidden = true
        }
        
        updatePinState(isPinned: isPinned)
    }

    @objc private func pinTapped() {
        onPinTapped?()
    }
    
    func updatePinState(isPinned: Bool) {
        let imageName = isPinned ? "pin.fill" : "pin"
        pinButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}
