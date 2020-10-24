
import UIKit
import JVFloatLabeledTextField
import RxSwift
import RxCocoa

enum InputTextFieldType {
    case text
    case emailAddress
    case password
    case picker
    case telephoneNumber
    case date(Date?)
    case time(Date?)
    case dateTime(Date?)
    case select([String?])
}

final class InputTextField: JVFloatLabeledTextField {

    // MARK: - UI

    private let separatorView = UIView()
    private let showSecureInputButton = UIButton()
    private let disclosureIcon = UIImageView()
    private let tapGestureRecognizer = UITapGestureRecognizer()

    // MARK: - Properties

    let disposeBag = DisposeBag()
    private(set) var tapEvent: Driver<Void>!

    private let type: InputTextFieldType
    private let pickerSelect = UIPickerView()

    // MARK: - Initialization

    init(type: InputTextFieldType = .text) {
        self.type = type
        super.init(frame: .zero)

        setupUI()
        setupBindings()
    }

    override init(frame: CGRect) {
        self.type = .text
        super.init(frame: frame)

        setupUI()
        setupBindings()
    }

    required init?(coder aDecoder: NSCoder) {
        self.type = .text
        super.init(coder: aDecoder)

        setupUI()
        setupBindings()
    }

    private func setupUI() {
        /*
 //showSecureInputButton.setImage(R.image.icEyeOn(), for: .normal)

        Styles.inputTextField.apply(to: self)
        Appearance.Styles.separatorView.apply(to: separatorView)
        delegate = self

        pickerSelect.tap {
            $0.dataSource = self
            $0.delegate = self
        }

        addSubview(separatorView)

        switch type {
        case .password:
            textContentType = .password
            Styles.secureInputTextField.apply(to: self)
            addSubview(showSecureInputButton)
        case .picker:
            Styles.disclosureInputTextField.apply(to: self)
            disclosureIcon.image = R.image.icDisclosureDown()
            addGestureRecognizer(tapGestureRecognizer)
            addSubview(disclosureIcon)
        case .date(let date):
            let datePickerView = UIDatePicker()
            datePickerView.datePickerMode = .date
            datePickerView.setDate(date ?? Date(), animated: false)
            datePickerView.maximumDate = Date()
            datePickerView.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)

            inputView = datePickerView
        case .select:
            inputView = pickerSelect
            pickerSelect.reloadAllComponents()
        case .emailAddress:
            textContentType = .emailAddress
            keyboardType = .emailAddress
        case .telephoneNumber:
            textContentType = .telephoneNumber
            keyboardType = .numberPad
        default:
            break
        }

        layout()
            */
    }

    private func layout() {
        separatorView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        switch type {
        case .password:
            showSecureInputButton.snp.makeConstraints { make in
                make.width.equalTo(24)
                make.height.equalTo(24)
                make.trailing.equalToSuperview()
                make.bottom.equalToSuperview().offset(-10)
            }
        case .picker:
            disclosureIcon.snp.makeConstraints { make in
                make.width.equalTo(6)
                make.height.equalTo(4)
                make.trailing.equalToSuperview()
                make.bottom.equalToSuperview().offset(-20)
            }
        default:
            break
        }
    }

    private func setupBindings() {
        tapEvent = tapGestureRecognizer.rx.event.asDriver().asVoid
            .do(onNext: { [unowned self] in
                self.superview?.endEditing(true)
            })

        self.rx.controlEvent(.editingDidBegin).asDriver()
            .drive(onNext: { [unowned self] _ in
                Appearance.Styles.activeSeparatorView.apply(to: self.separatorView)
            })
            .disposed(by: disposeBag)

        self.rx.controlEvent(.editingDidEnd).asDriver()
            .drive(onNext: { [unowned self] _ in
                //Appearance.Styles.separatorView.apply(to: self.separatorView)
            })
            .disposed(by: disposeBag)

        showSecureInputButton.rx.tap.asDriver()
            .drive(onNext: { [unowned self] _ in
                self.isSecureTextEntry = !self.isSecureTextEntry

                //let image = self.isSecureTextEntry ? R.image.icEyeOn() : R.image.icEyeOff()
                //self.showSecureInputButton.setImage(image, for: .normal)
            })
            .disposed(by: disposeBag)
    }

    func setupDatePicker(date: Date?) {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        datePickerView.setDate(date ?? Date(), animated: false)
        datePickerView.maximumDate = Date()
        datePickerView.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)

        inputView = datePickerView
    }
}

// MARK: - TextFieldDelegate

extension InputTextField: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch type {
        case .picker:
            return false
        default:
            return true
        }
    }
}

// MARK: - PickerView DataSource, Delegate

extension InputTextField: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard case .select(let values) = type else {
            return 0
        }

        return values.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard case .select(let values) = type else {
            return ""
        }

        return values[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard case .select(let values) = type else {
            return
        }

        text = values[row]
        sendActions(for: .valueChanged)
    }
}

// MARK: - Pickers

extension InputTextField {

    @objc
    private func datePickerChanged(sender: UIDatePicker) {
        text = Formatters.getDateString(forDate: sender.date)
        sendActions(for: .valueChanged)
    }
}

// MARK: - Styles

extension InputTextField {
    struct Styles {
        static let inputTextField = UIViewStyle<JVFloatLabeledTextField> {
            $0.placeholderColor = Appearance.Colors.lightText
            $0.floatingLabelTextColor = Appearance.Colors.lightText
            $0.floatingLabelActiveTextColor = Appearance.Colors.mainTint
            $0.floatingLabelFont = Appearance.font(ofSize: 14, weight: .regular)
            $0.textColor = Appearance.Colors.blackLabel
            $0.floatingLabelYPadding = 4
            $0.clipsToBounds = true
        }

        static let secureInputTextField = UIViewStyle<JVFloatLabeledTextField> {
            $0.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: $0.frame.height))
            $0.rightViewMode = .always
            $0.isSecureTextEntry = true
        }

        static let disclosureInputTextField = UIViewStyle<JVFloatLabeledTextField> {
            $0.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: $0.frame.height))
            $0.rightViewMode = .always
        }
    }
}
