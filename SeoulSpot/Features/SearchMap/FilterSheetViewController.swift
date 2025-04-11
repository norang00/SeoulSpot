//
//  FilterSheetViewController.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 4/10/25.
//

import UIKit
import SnapKit

struct FilterSelection {
    var categories: [EventCategory]
    var districts: [District]
    var prices: [PriceType]
    var audiences: [AudienceTarget]
}

protocol FilterSheetDelegate: AnyObject {
    func didApplyFilters(_ filters: FilterSelection)
}

final class FilterSheetViewController: UIViewController {
    
    private var currentFilters: FilterSelection

    var delegate: FilterSheetDelegate?
    
    private let titleLabel = UILabel()
    private let doneButton = UIButton()
    private let resetButton = UIButton(type: .system)
    
    private let scrollView = UIScrollView()
    private let contentView = UIStackView()
    
    private var selectedCategories: Set<EventCategory> = []
    private var selectedDistricts: Set<District> = []
    private var selectedPrices: Set<PriceType> = []
    private var selectedAudiences: Set<AudienceTarget> = []
    
    private let categoryLabel = UILabel()
    private let categoryScroll = UIScrollView()
    private let categoryStack = UIStackView()

    private let districtLabel = UILabel()
    private let districtScroll = UIScrollView()
    private let districtStack = UIStackView()

    private let priceLabel = UILabel()
    private let priceScroll = UIScrollView()
    private let priceStack = UIStackView()

    private let audienceLabel = UILabel()
    private let audienceScroll = UIScrollView()
    private let audienceStack = UIStackView()
    
    init(currentFilters: FilterSelection) {
        self.currentFilters = currentFilters
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.tintColor = .accent
        setupHierarchy()
        setupLayout()
        setupView()

        doneButton.addTarget(self, action: #selector(applyFilters), for: .touchUpInside)
    }

    private func setupHierarchy() {
        view.addSubview(titleLabel)
        view.addSubview(doneButton)
        view.addSubview(resetButton)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.axis = .vertical
        contentView.spacing = 16
        contentView.isLayoutMarginsRelativeArrangement = true

        [categoryLabel, categoryScroll,
         districtLabel, districtScroll,
         audienceLabel, audienceScroll,
         priceLabel, priceScroll
        ].forEach { contentView.addArrangedSubview($0) }

        [categoryStack, districtStack, priceStack, audienceStack].forEach {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.alignment = .center
            $0.distribution = .fillProportionally
        }

        categoryScroll.addSubview(categoryStack)
        districtScroll.addSubview(districtStack)
        priceScroll.addSubview(priceStack)
        audienceScroll.addSubview(audienceStack)
    }
    
    private func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.leading.equalToSuperview().offset(20)
        }

        doneButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(20)
        }

        resetButton.snp.makeConstraints {
            $0.centerY.equalTo(doneButton)
            $0.trailing.equalTo(doneButton.snp.leading).offset(-12)
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(16)
        }

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }

        [categoryScroll, districtScroll, priceScroll, audienceScroll].forEach {
            $0.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(40)
            }
        }

        [categoryStack, districtStack, priceStack, audienceStack].forEach {
            $0.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.edges.equalToSuperview()
            }
        }

        [categoryLabel, districtLabel, priceLabel, audienceLabel].forEach {
            $0.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(20)
            }
        }
    }
    
    private func setupView() {
        selectedCategories = Set(currentFilters.categories)
        selectedDistricts = Set(currentFilters.districts)
        selectedPrices = Set(currentFilters.prices)
        selectedAudiences = Set(currentFilters.audiences)
        
        titleLabel.text = "행사 찾아보기"
        titleLabel.font = .boldSystemFont(ofSize: 18)

        resetButton.setTitle("초기화", for: .normal)
        resetButton.setTitleColor(.systemRed, for: .normal)
        resetButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        resetButton.addTarget(self, action: #selector(resetSelections), for: .touchUpInside)

        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .accent
        config.baseForegroundColor = .white
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12)

        let font = UIFont(name: "Pretendard-Medium", size: 14) ?? .boldSystemFont(ofSize: 14)
        config.attributedTitle = AttributedString("적용하기", attributes: AttributeContainer([.font: font]))

        doneButton.configuration = config

        categoryLabel.text = "카테고리"
        districtLabel.text = "지역"
        priceLabel.text = "유/무료"
        audienceLabel.text = "관람 대상"

        [categoryLabel, districtLabel, priceLabel, audienceLabel].forEach {
            $0.font = .systemFont(ofSize: 16, weight: .medium)
        }

        EventCategory.allCases.forEach { category in
            let button = makeFilterButton(title: category.rawValue)
            button.addAction(UIAction { [weak self] _ in
                if self?.selectedCategories.contains(category) == true {
                    self?.selectedCategories.remove(category)
                } else {
                    self?.selectedCategories.insert(category)
                }
                self?.updateButtonAppearance(button, selected: self?.selectedCategories.contains(category) == true)
            }, for: .touchUpInside)
            categoryStack.addArrangedSubview(button)
            updateButtonAppearance(button, selected: selectedCategories.contains(category))
        }
        District.allCases.forEach { district in
            let button = makeFilterButton(title: district.rawValue)
            button.addAction(UIAction { [weak self] _ in
                if self?.selectedDistricts.contains(district) == true {
                    self?.selectedDistricts.remove(district)
                } else {
                    self?.selectedDistricts.insert(district)
                }
                self?.updateButtonAppearance(button, selected: self?.selectedDistricts.contains(district) == true)
            }, for: .touchUpInside)
            districtStack.addArrangedSubview(button)
            updateButtonAppearance(button, selected: selectedDistricts.contains(district))
        }
        PriceType.allCases.forEach { price in
            let button = makeFilterButton(title: price.rawValue)
            button.addAction(UIAction { [weak self] _ in
                if self?.selectedPrices.contains(price) == true {
                    self?.selectedPrices.remove(price)
                } else {
                    self?.selectedPrices.insert(price)
                }
                self?.updateButtonAppearance(button, selected: self?.selectedPrices.contains(price) == true)
            }, for: .touchUpInside)
            priceStack.addArrangedSubview(button)
            updateButtonAppearance(button, selected: selectedPrices.contains(price))
        }
        AudienceTarget.allCases.forEach { target in
            let button = makeFilterButton(title: target.displayName)
            button.addAction(UIAction { [weak self] _ in
                if self?.selectedAudiences.contains(target) == true {
                    self?.selectedAudiences.remove(target)
                } else {
                    self?.selectedAudiences.insert(target)
                }
                self?.updateButtonAppearance(button, selected: self?.selectedAudiences.contains(target) == true)
            }, for: .touchUpInside)
            audienceStack.addArrangedSubview(button)
            updateButtonAppearance(button, selected: selectedAudiences.contains(target))
        }

        [categoryScroll, districtScroll, priceScroll, audienceScroll].forEach {
            $0.showsHorizontalScrollIndicator = false
            $0.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }

        [categoryStack, districtStack, priceStack, audienceStack].forEach {
            $0.clipsToBounds = false
        }
    }
    
    private func makeFilterButton(title: String) -> UIButton {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .systemGray6
        config.baseForegroundColor = .label
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
        config.cornerStyle = .capsule

        let font = UIFont(name: "Pretendard-Regular", size: 14) ?? .systemFont(ofSize: 14)
        config.attributedTitle = AttributedString(title, attributes: AttributeContainer([.font: font]))

        let button = UIButton(configuration: config, primaryAction: nil)
        return button
    }
    
    private func updateButtonAppearance(_ button: UIButton, selected: Bool) {
        guard var config = button.configuration else { return }
        if selected {
            config.baseBackgroundColor = .accent
            config.baseForegroundColor = .white
        } else {
            config.baseBackgroundColor = .systemGray6
            config.baseForegroundColor = .label
        }
        button.configuration = config
    }
    
    @objc private func resetSelections() {
        selectedCategories.removeAll()
        selectedDistricts.removeAll()
        selectedPrices.removeAll()
        selectedAudiences.removeAll()

        [categoryStack, districtStack, priceStack, audienceStack].forEach { stack in
            stack.arrangedSubviews.compactMap { $0 as? UIButton }.forEach {
                updateButtonAppearance($0, selected: false)
            }
        }
    }
    
    @objc private func applyFilters() {
        let filters = FilterSelection(
            categories: Array(selectedCategories),
            districts: Array(selectedDistricts),
            prices: Array(selectedPrices),
            audiences: Array(selectedAudiences)
        )
        delegate?.didApplyFilters(filters)
        dismiss(animated: true)
    }
}
