//
//  Test_Code_Review.swift
//  NewsApi
//
//  Created by dev on 27.10.2023.
//  Copyright © 2023 Alexandr Bondar. All rights reserved.
//

import Foundation

import MTSBFoundation
import MTSBUI
import RxCocoa
import RxSwift

// MARK: - FAThirdStepViewController

final class FAThirdStepViewController: UIViewController {
    
    // MARK: - Nested types
    
    private enum Consts {
        
        enum Strings {
            static let stepTitle: String = "О работе"
            static let screenTitle: String = "Параметры кредита"
            static let labourType: String = "Вид занятости"
            static let orgName: String = "Наименование организации"
            static let employmentDate: String = "Дата приёма на работу"
            static let orgInn: String = "ИНН организации"
            static let orgAddress: String = "Адрес организации"
            
            static let bottomButton: String = "Продолжить"
            static let cancelButtonTittle = "Отмена"
            static let done: String = "Готово"
            static let employmentDateSubtitle = "ММ.ГГГГ"
            static let checkBoxTitle = "Разрешаю банку проверить мою кредитную историю"
            static let checkBoxWarning = "Для подачи заявки необходимо дать согласие на запрос кредитной истории"
        }
        
        enum Colors {
            static let background: UIColor = .neutral800
            static let loaderBackground: UIColor = .white
            static let cancelButtonColor: UIColor = .black
        }
        
        static let currentStep: Int = 3
        static let fullStepCount: Int = 3
        static let loadingAnimationDuration: Double = 0.2
        static let loadingViewAlpha: CGFloat = 1.0
        
        enum Sizes {
            static let cancelButtonBottom: CGFloat = -16
            static let pagerHeight: CGFloat = 26.0
            static let clearButtonWidth: CGFloat = 50.0
            static let pagerWidth: CGFloat = 120.0
            static let buttonVerticalInset: CGFloat = 16.0
            static let butonHorizontalInsets: CGFloat = 16.0
            static let buttonCornerRadius: CGFloat = 8.0
            static let bottomSpaceForNonNotchedPhones: CGFloat = 16.0
            static let bottomSpaceForNotchedPhones: CGFloat = 50.0
        }
        
        static let backBarItemImage: UIImage = #imageLiteral(resourceName: "back")
        static let backBarItemConsts: UIBarButtonItem.Style = .plain
    }
    
    // MARK: - Private properties
    
    private let once = Once()
    
    private let oldVariable: String?

    private var keyboardConstraint = NSLayoutConstraint()
    
    private let newVariable: String = "doing nothing"

    private lazy var titleView: TitleWithStepsView = {
        let titleView = TitleWithStepsView()
        titleView.setSteps(
            currentStep: 3,
            allStepsCount: 3
        )
        titleView.setTitle(title: Consts.Strings.stepTitle)
        
        return titleView
    }()
    
    private lazy var scrollContainer: UIScrollView = {
        let scroll = UIScrollView()
        
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        
        return scroll
    }()
    
    private lazy var contentContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        
        return stack
    }()
    
    private lazy var labourType: Select = {
        let target = Select()
        target.placeholder = Consts.Strings.labourType
        
        target.buttonTapAction = { [weak self] in
            guard let self = self else { return }
            
            self.viewModel.onNeedToPickLabourType()
            
            self.once.perform { [weak self] in
                self?.viewModel.labourTypeChanged()
            }
        }
        
        return target
    }()
    
    private lazy var orgNameInput: BottomDescriptionWrapper<Input> = {
        let input = Input()
        input.placeholder = Consts.Strings.orgName
        
        return input.withBottomTexts()
    }()
    
    private lazy var orgNameSelectButton: UIButton = {
        $0.backgroundColor = .clear
        
        $0.addTarget(
            self,
            action: #selector(orgNameSelectButtonAction),
            for: .touchUpInside
        )
        
        return $0
    }(UIButton())
    
    private lazy var orgNameClearButton: UIButton = {
        $0.backgroundColor = .clear
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        $0.addTarget(
            self,
            action: #selector(orgNameClearButtonAction),
            for: .touchUpInside
        )
        
        return $0
    }(UIButton())
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle(Consts.Strings.cancelButtonTittle, for: .normal)
        button.setTitleColor(Consts.Colors.cancelButtonColor, for: .normal)
        button.titleLabel?.font = .p2Medium
        button.target(forAction: #selector(cancelCreditCreationTapped), withSender: self)
        
        return button
    }()
    
    private lazy var loader: UIView = {
        let loadingView = UIView()
        loadingView.isOpaque = false
        loadingView.backgroundColor = Consts.Colors.loaderBackground
        
        let loader = DotsLoader()
        loadingView.addSubviewWithAutolayout(loader)
        loader.layoutInstructions {
            $0.centerX == loadingView.centerXAnchor
            $0.centerY == loadingView.centerYAnchor
        }
        
        return loadingView
    }()
    
    private lazy var employmentDateInput: BottomDescriptionWrapper<Input> = {
        let input = Input()
        input.keyboardType = UIKeyboardType.decimalPad
        input.placeholder = Consts.Strings.employmentDate
        input.delegate = self.viewModel.textfieldEntryValidator
        input.descriptionText = Consts.Strings.employmentDateSubtitle
        
        input.textFieldInputAccessoryView = makeKeyboardToolbar(
            doneAction: #selector(employmentDateDoneAction),
            title: Consts.Strings.done
        )
        
        input.buttonTapAction = { [weak input, weak self] in
            input?.text = ""
            self?.viewModel.onNeedToClearEmploymentDate()
        }
        
        input.editingChanged = { [weak self] _ in
            guard let self = self else { return }
            
            self.once.perform { [weak self] in
                self?.viewModel.employmentDateInputChanged()
            }
        }
        
        return input.withBottomTexts()
    }()
    
    private lazy var orgInnInput: BottomDescriptionWrapper<Input> = {
        let input = Input()
        input.placeholder = Consts.Strings.orgInn
        
        input.editingChanged = { [weak self] _ in
            guard let self = self else { return }
            
            self.once.perform { [weak self] in
                self?.viewModel.orgInnChanged()
            }
        }
        
        return input.withBottomTexts()
    }()
    
    private lazy var orgAddressInput: BottomDescriptionWrapper<Input> = {
        let input = Input()
        input.placeholder = Consts.Strings.orgAddress
        
        return input.withBottomTexts()
    }()
    
    private lazy var fillerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        view.setContentHuggingPriority(
            .notRequired,
            for: .vertical
        )
        
        return view
    }()
    
    private lazy var actionButton: Buttons.Component.TextWithArrow = {
        let button = Buttons.Component.TextWithArrow(
            size: .L,
            palette: Buttons.Base.Palette.MTSPresets.primary
        )
        
        button.addTarget(
            self,
            action: #selector(onActionButtonClick),
            for: .touchUpInside
        )
        
        button.text = Consts.Strings.bottomButton
        
        return button
    }()
    
    private lazy var backBarItem: UIBarButtonItem = {
        return .init(
            image: Consts.backBarItemImage,
            style: Consts.backBarItemConsts,
            target: self,
            action: #selector(onBackAction)
        )
    }()
    
    private lazy var checkBox: BottomDescriptionWrapper<CheckBox> = {
        let checkBox = CheckBox()
        checkBox.title = Consts.Strings.checkBoxTitle
        checkBox.errorTitle = Consts.Strings.checkBoxWarning
        checkBox.apply(
            .init(
                designedState: .default,
                infoButtonState: .disable
            ),
            animated: false
        )
        
        let touchGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(toggleArgeementState)
        )
        checkBox.addGestureRecognizer(touchGesture)
        
        return checkBox.withBottomTexts()
    }()
    
    private lazy var actionButtonWrapper: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }()
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    
    private let viewModel: FAThirdStepViewModel
    
    // MARK: - Init
    
    init(viewModel: FAThirdStepViewModel) {
        self.viewModel = viewModel
        
        super.init(
            nibName: nil,
            bundle: nil
        )
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupSubscriptions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigation()
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unregisterForKeyboardNotifications()
    }
    
    // MARK: - Actions
    
    @objc private func cancelCreditCreationTapped() {
        navigationController?.isNavigationBarHidden = false
        viewModel.onCancelCreditCreation()
    }
    
    @objc private func employmentDateDoneAction() {
        _ = employmentDateInput.content.resignFirstResponder()
    }
    
    @objc private func onBackAction() {
        viewModel.onBackAction()
    }
    
    @objc private func onActionButtonClick() {
        if !checkBox.content.isSelected {
            checkBox.content.apply(
                .init(
                    designedState: .error,
                    infoButtonState: .disable
                ),
                animated: false
            )
        }
        viewModel.onNextAction()
    }
    
    @objc private func toggleArgeementState() {
        viewModel.needToToggleAgreement()
    }
    
    @objc private func closeTapped() {
        viewModel.onCloseFlow()
    }
    
    @objc func orgNameSelectButtonAction() {
        viewModel.onNeedToPickOrgName()
        
        once.perform { [weak self] in
            self?.viewModel.orgNameChanged()
        }
    }
    
    @objc func orgNameClearButtonAction() {
        viewModel.onNeedToClearOrgData()
    }
    
    // MARK: - Private methods
    
    private func setupNavigation() {
        title = Consts.Strings.screenTitle
        
        addBackButton(
            backActionTarget: self,
            backAction: #selector(onBackAction)
        )
        
        navigationController?.navigationBar.isHidden = false
        
        navigationController?.setNavigationBarHidden(
            false,
            animated: true
        )
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func addCloseButton() {
        let closeBarButtonItem = UIBarButtonItem(
            image: FullApproveV2Images.close,
            style: .plain,
            target: self,
            action: #selector(closeTapped)
        )
        navigationItem.rightBarButtonItem = closeBarButtonItem
    }
    
    private func setupUI() {
        addCloseButton()
        title = Consts.Strings.screenTitle
        navigationItem.backBarButtonItem = nil
        navigationItem.leftBarButtonItem = backBarItem
        view.backgroundColor = Consts.Colors.background
        view.addSubviewWithAutolayout(titleView)
        view.addSubviewWithAutolayout(scrollContainer)
        scrollContainer.addSubviewWithAutolayout(contentContainer)
        
        self.navigationController?.isNavigationBarHidden = false
        
        employmentDateInput.content.descriptionText = Consts.Strings.employmentDateSubtitle
        orgNameInput.addSubviewWithAutolayout(orgNameSelectButton)
        orgNameInput.addSubviewWithAutolayout(orgNameClearButton)
        
        actionButtonWrapper.addSubviewWithAutolayout(actionButton)
        contentContainer.addArrangedSubview(labourType.withBottomTexts())
        contentContainer.addArrangedSubview(orgNameInput)
        contentContainer.addArrangedSubview(employmentDateInput)
        contentContainer.addArrangedSubview(orgInnInput)
        contentContainer.addArrangedSubview(orgAddressInput)
        contentContainer.addArrangedSubview(checkBox)
        contentContainer.addArrangedSubview(fillerView)
        contentContainer.addArrangedSubview(actionButtonWrapper)
        
        let bottomSpacerHeight: CGFloat
        
        if isHasNotch {
            bottomSpacerHeight = Consts.Sizes.bottomSpaceForNotchedPhones
        } else {
            bottomSpacerHeight = Consts.Sizes.bottomSpaceForNonNotchedPhones
        }
        
        let spacer = UIView(height: bottomSpacerHeight)
        contentContainer.addArrangedSubview(spacer)
        
        actionButton.layoutInstructions {
            $0.top == actionButtonWrapper.topAnchor
            $0.bottom == actionButtonWrapper.bottomAnchor
            $0.leading == actionButtonWrapper.leadingAnchor + Consts.Sizes.butonHorizontalInsets
            $0.trailing == actionButtonWrapper.trailingAnchor - Consts.Sizes.butonHorizontalInsets
        }
        
        titleView.layoutInstructions {
            $0.top == view.safeAreaLayoutGuide.topAnchor
            $0.leading == view.leadingAnchor
            $0.trailing == view.trailingAnchor
        }
        
        contentContainer.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.greaterThanOrEqualTo(scrollContainer.snp.height)
        }
        
        scrollContainer.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        orgNameSelectButton.layoutInstructions {
            $0.bottom == orgNameInput.bottomAnchor
            $0.top == orgNameInput.topAnchor
            $0.leading == orgNameInput.leadingAnchor
            $0.trailing == orgNameClearButton.leadingAnchor
        }
        
        orgNameClearButton.layoutInstructions {
            $0.bottom == orgNameInput.bottomAnchor
            $0.top == orgNameInput.topAnchor
            $0.width == Consts.Sizes.clearButtonWidth
            $0.trailing == orgNameInput.trailingAnchor
        }
    }
    
    private func setupLoader() {
        loader.alpha = 0
        view.addSubviewWithAutolayout(loader)
        loader.pinToEdges()
    }
    
    private func setupCancelButton() {
        view.addSubviewWithAutolayout(cancelButton)
        cancelButton.layoutInstructions {
            $0.centerX == view.centerXAnchor
            $0.bottom == view.safeAreaLayoutGuide.bottomAnchor + Consts.Sizes.cancelButtonBottom
        }
    }
    
    private func setupSubscriptions() {
        
        viewModel
            .isHiddenNameAndDateFields
            .drive(orgNameInput.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel
            .isSubmitingForm
            .drive(onNext: { [weak self] submited in
                if submited {
                    self?.showLoading()
                } else {
                    self?.hideLoading()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel
            .isHiddenNameAndDateFields
            .drive(employmentDateInput.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel
            .isHiddenInnField
            .drive{ [weak self] isHidden in
                self?.orgInnInput.content.event = StatefulTextField.InputEvent.disabled
                self?.orgInnInput.isHidden = isHidden
            }
            .disposed(by: disposeBag)
        
        viewModel
            .isHiddenAddressField
            .drive{ [weak self] isHidden in
                self?.orgAddressInput.content.event = StatefulTextField.InputEvent.disabled
                self?.orgAddressInput.isHidden = isHidden
            }
            .disposed(by: disposeBag)
        
        viewModel
            .labourType
            .drive(labourType.rx.text)
            .disposed(by: disposeBag)
        
        viewModel
            .orgName
            .drive(orgNameInput.content.rx.text)
            .disposed(by: disposeBag)
        
        viewModel
            .employmentDate
            .drive(employmentDateInput.content.rx.text)
            .disposed(by: disposeBag)
        
        viewModel
            .labourTypeErrorText
            .drive(labourType.rx.error)
            .disposed(by: disposeBag)
        
        viewModel
            .orgNameErrorText
            .drive(orgNameInput.content.rx.error)
            .disposed(by: disposeBag)
        
        viewModel
            .employmentDateErrorText
            .drive(employmentDateInput.content.rx.error)
            .disposed(by: disposeBag)
        
        viewModel
            .orgInn
            .drive(orgInnInput.content.rx.text)
            .disposed(by: disposeBag)
        
        viewModel
            .orgAddress
            .drive(orgAddressInput.content.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.isAgreementAccepted
            .drive { [weak self] isSelected in
                let state: CheckBox.ComponentState.DesignedState
                
                if isSelected {
                    state = .selected
                } else {
                    state = .error
                    self?.viewModel.onHintShow()
                }
                
                UIView.animate(withDuration: 0.25) {
                    self?.checkBox.content.apply(
                        .init(
                            designedState: state,
                            infoButtonState: .disable
                        )
                    )
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.isNextButtonEnabled
            .drive(actionButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    private func makeKeyboardToolbar(
        doneAction: Selector,
        title: String
    ) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.items = [
            UIBarButtonItem(
                barButtonSystemItem: .flexibleSpace,
                target: nil,
                action: nil
            ),
            
            UIBarButtonItem(
                title: title,
                style: .plain,
                target: self,
                action: doneAction
            )
        ]
        toolbar.sizeToFit()
        
        return toolbar
    }
    
    private func showLoading() {
        setupLoader()
        setupCancelButton()
        navigationController?.isNavigationBarHidden = true
        UIView.animate(withDuration: Consts.loadingAnimationDuration) {
            self.loader.alpha = Consts.loadingViewAlpha
        }
    }
    
    private func hideLoading() {
        UIView.animate(
            withDuration: Consts.loadingAnimationDuration,
            animations: {
                self.loader.alpha = 0
            },
            completion: { _ in
                self.loader.removeFromSuperview()
                self.cancelButton.removeFromSuperview()
                self.navigationController?.isNavigationBarHidden = false
            }
        )
    }
    
    // MARK: - UIViewControllerKeyboardHelper
    
    private func registerForKeyboardNotifications() {
        let center = NotificationCenter.default
        center.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        center.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func unregisterForKeyboardNotifications() {
        let center = NotificationCenter.default
        center.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        center.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardFrameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else {
            return
        }
        
        let inputItemBottomPoint = CGPoint(
            x: employmentDateInput.bounds.minX,
            y: employmentDateInput.bounds.maxY
        )
        let convertedPoint = employmentDateInput.convert(
            inputItemBottomPoint,
            to: self.view
        )
        let delta = view.bounds.maxY - convertedPoint.y
        let contentCorrectionForKeyboard = keyboardFrameValue.cgRectValue.size.height - delta
        
        guard
            contentCorrectionForKeyboard > 0,
            let mainView = view,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber,
            let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        else {
            return
        }
        
        keyboardConstraint = NSLayoutConstraint(
            item: mainView,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: contentContainer,
            attribute: .bottom,
            multiplier: 1,
            constant: 0
        )
        keyboardConstraint.isActive = true
        keyboardConstraint.constant = contentCorrectionForKeyboard
        
        UIView.animate(
            withDuration: TimeInterval(duration.doubleValue),
            delay: 0,
            options: UIView.AnimationOptions(rawValue: curve.uintValue),
            animations: { self.view.layoutIfNeeded() }
        )
    }
    
    @objc func keyboardWillHide(notification _: NSNotification) {
        keyboardConstraint.constant = 0
        keyboardConstraint.isActive = false
    }
}
