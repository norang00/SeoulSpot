//
//  EventDetailView.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 3/31/25.
//

import UIKit

final class EventDetailView: BaseView {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let posterImageView = UIImageView()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel() // 기관명, 지역
    let dateLabel = UILabel()
    let placeLabel = UILabel()
    let targetLabel = UILabel()
    let feeLabel = UILabel()
    let categoryLabel = UILabel()
    let linkButton = UIButton(type: .system)

    override func setupHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [posterImageView, titleLabel, subtitleLabel, dateLabel, placeLabel, targetLabel, feeLabel, categoryLabel, linkButton].forEach {
            contentView.addSubview($0)
        }
    }

    override func setupLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()      // scrollView의 content 영역
            $0.width.equalToSuperview()     // 가로 스크롤 방지
        }
        
        posterImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(240)
            $0.height.equalTo(320)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(posterImageView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(titleLabel)
        }

        dateLabel.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalTo(titleLabel)
        }

        placeLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(titleLabel)
        }

        targetLabel.snp.makeConstraints {
            $0.top.equalTo(placeLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalTo(titleLabel)
        }

        feeLabel.snp.makeConstraints {
            $0.top.equalTo(targetLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(titleLabel)
        }

        categoryLabel.snp.makeConstraints {
            $0.top.equalTo(feeLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalTo(titleLabel)
        }

        linkButton.snp.makeConstraints {
            $0.top.equalTo(categoryLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(40)
        }
    }

    override func setupView() {
        backgroundColor = .white

        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 12

        titleLabel.font = .pretendardBold(ofSize: 20)
        titleLabel.numberOfLines = 0

        [subtitleLabel, dateLabel, placeLabel, targetLabel, feeLabel, categoryLabel].forEach {
            $0.font = .pretendardRegular(ofSize: 14)
            $0.numberOfLines = 0
        }

        linkButton.setTitle("공식 페이지 바로가기", for: .normal)
    }

    func configure(with event: CulturalEvent) {
        titleLabel.text = event.title
        subtitleLabel.text = "\(event.orgName) · \(event.guName)"
        dateLabel.text = "기간: \(event.date)"
        placeLabel.text = "장소: \(event.place)"
        targetLabel.text = "대상: \(event.useTarget ?? "누구나")"
        feeLabel.text = "요금: \(event.useFee ?? "-")"
        categoryLabel.text = "카테고리: \(event.codeName)"

        if let url = URL(string: event.mainImage ?? "") {
            posterImageView.loadImage(from: url)
        }

        if let link = event.orgLink, let url = URL(string: link) {
            linkButton.addAction(UIAction(handler: { _ in
                UIApplication.shared.open(url)
            }), for: .touchUpInside)
        } else {
            linkButton.isHidden = true
        }
    }
}
