//
//  ViewController.swift
//  ExampleApp
//
//  Created by Krystian Bujak on 03/12/2018.
//  Copyright © 2018 SwingDev. All rights reserved.
//

import UIKit
import RxSwift
import RxSwiftAutoRetry

enum SampleError: Error {
    case sampleErrorCase
}
class ViewController: UIViewController {

    let containerView = GradientView()
    let tableView = UITableView()
    let horizontalStackView = UIStackView()
    let retryNumberLabel = UILabel()
    let retryNumberTxtField = UITextField()
    let errorLabel = UILabel()
    let startButton = UIButton()
    let activityIndicator = UIActivityIndicatorView()
    let disposeBag = DisposeBag()
    var timeArray = [TimeInterval]()
    var startTime: Date?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(containerView)
        containerView.frame = view.frame

        [tableView,
         horizontalStackView,
         retryNumberLabel,
         retryNumberTxtField,
         startButton,
         errorLabel,
         activityIndicator].forEach { containerView.addSubview($0) }
        [retryNumberLabel, retryNumberTxtField].forEach { horizontalStackView.addArrangedSubview($0) }

        tableView.delegate = self
        tableView.dataSource = self

        setupTableView()
        setupHorizontalStackView()
        setupLabel()
        setupTxtField()
        setupStartButton()
        setupErrorLabel()
        setupActivityIndicator()

        startButton.addTarget(self, action: #selector(startAction), for: .touchUpInside)

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }

    @objc private func startAction() {
        guard let numberString = retryNumberTxtField.text,
            let number = Int(numberString) else { return }

        timeArray.removeAll()
        startTime = Date()

        DispatchQueue.main.async { [weak self] in
            self?.startButton.isEnabled = false
            self?.retryNumberTxtField.isEnabled = false
            self?.errorLabel.isHidden = true
            self?.activityIndicator.isHidden = false
            self?.activityIndicator.startAnimating()
            self?.tableView.reloadData()
        }

        Observable<String>.create { observer in
            observer.onError(SampleError.sampleErrorCase)
            return Disposables.create()
            }
            .retryExponentially(maxAttemptCount: number) { [weak self] _ in
                guard let startTime = self?.startTime else { return }
                self?.timeArray.append(Date().timeIntervalSince(startTime))
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
            .subscribe(onError: { [weak self] _ in
                DispatchQueue.main.async {
                    self?.errorLabel.isHidden = false
                }}, onDisposed: { [weak self] in
                    DispatchQueue.main.async {
                        self?.startButton.isEnabled = true
                        self?.retryNumberTxtField.isEnabled = true
                        self?.activityIndicator.isHidden = true
                        self?.activityIndicator.stopAnimating()
                    }
            })
            .disposed(by: disposeBag)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension ViewController {
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addConstraints([
            NSLayoutConstraint(item: tableView,
                               attribute: .top,
                               relatedBy: .equal,
                               toItem: containerView,
                               attribute: .top,
                               multiplier: 1.0,
                               constant: 50),
            NSLayoutConstraint(item: tableView,
                               attribute: .leading,
                               relatedBy: .equal,
                               toItem: containerView,
                               attribute: .leading,
                               multiplier: 1.0,
                               constant: 20),
            NSLayoutConstraint(item: tableView,
                               attribute: .trailing,
                               relatedBy: .equal,
                               toItem: containerView,
                               attribute: .trailing,
                               multiplier: 1.0,
                               constant: -20),
            NSLayoutConstraint(item: tableView,
                               attribute: .height,
                               relatedBy: .equal,
                               toItem: nil,
                               attribute: .notAnAttribute,
                               multiplier: 1.0,
                               constant: 250)
            ])
        tableView.backgroundColor = .white
        tableView.layer.cornerRadius = 5
        tableView.layer.borderWidth = 3
        tableView.indicatorStyle = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Custom")
    }

    private func setupHorizontalStackView() {
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addConstraints([
            NSLayoutConstraint(item: horizontalStackView,
                               attribute: .top,
                               relatedBy: .equal,
                               toItem: tableView,
                               attribute: .bottom,
                               multiplier: 1.0,
                               constant: 30),
            NSLayoutConstraint(item: horizontalStackView,
                               attribute: .leading,
                               relatedBy: .equal,
                               toItem: containerView,
                               attribute: .leading,
                               multiplier: 1.0,
                               constant: 20),
            NSLayoutConstraint(item: horizontalStackView,
                               attribute: .trailing,
                               relatedBy: .equal,
                               toItem: containerView,
                               attribute: .trailing,
                               multiplier: 1.0,
                               constant: -20),
            NSLayoutConstraint(item: horizontalStackView,
                               attribute: .height,
                               relatedBy: .equal,
                               toItem: nil,
                               attribute: .notAnAttribute,
                               multiplier: 1.0,
                               constant: 50)
            ])
        horizontalStackView.distribution = .fillProportionally
        horizontalStackView.alignment = .center
        horizontalStackView.axis = .horizontal
    }

    private func setupLabel() {
        retryNumberLabel.text = "Number of retries:"
        retryNumberLabel.textColor = .black
        retryNumberLabel.font = UIFont(name: "ArialMT", size: 25)
    }

    private func setupTxtField() {
        retryNumberTxtField.textAlignment = .center
        retryNumberTxtField.font = UIFont(name: "ArialMT", size: 25)
        retryNumberTxtField.backgroundColor = UIColor.lightGray
        retryNumberTxtField.layer.cornerRadius = 5
        retryNumberTxtField.keyboardType = .numberPad
        retryNumberTxtField.addConstraints([
            NSLayoutConstraint(item: retryNumberTxtField,
                               attribute: .width,
                               relatedBy: .equal,
                               toItem: nil,
                               attribute: .notAnAttribute,
                               multiplier: 1.0,
                               constant: 50),
            NSLayoutConstraint(item: retryNumberTxtField,
                               attribute: .height,
                               relatedBy: .equal,
                               toItem: nil,
                               attribute: .notAnAttribute,
                               multiplier: 1.0,
                               constant: 50)
        ])
        retryNumberTxtField.attributedPlaceholder = NSAttributedString(
            string: "1",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        )
    }

    private func setupStartButton() {
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.isEnabled = true
        startButton.backgroundColor = .lightGray
        containerView.addConstraints([
            NSLayoutConstraint(item: startButton,
                               attribute: .top,
                               relatedBy: .equal,
                               toItem: horizontalStackView,
                               attribute: .bottom,
                               multiplier: 1.0,
                               constant: 30),
            NSLayoutConstraint(item: startButton,
                               attribute: .leading,
                               relatedBy: .equal,
                               toItem: containerView,
                               attribute: .leading,
                               multiplier: 1.0,
                               constant: 20),
            NSLayoutConstraint(item: startButton,
                               attribute: .trailing,
                               relatedBy: .equal,
                               toItem: containerView,
                               attribute: .trailing,
                               multiplier: 1.0,
                               constant: -20),
            NSLayoutConstraint(item: startButton,
                               attribute: .height,
                               relatedBy: .equal,
                               toItem: nil,
                               attribute: .notAnAttribute,
                               multiplier: 1.0,
                               constant: 50)
            ])
        startButton.setTitle("Start", for: .normal)
        startButton.setTitleColor(.darkGray, for: .normal)
        startButton.setTitleColor(.white, for: .highlighted)
        startButton.layer.cornerRadius = 5
    }

    private func setupErrorLabel() {
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.isHidden = true
        errorLabel.text = "Error occured"
        errorLabel.textColor = .white
        retryNumberTxtField.font = UIFont(name: "ArialMT", size: 20)
        containerView.addConstraints([
            NSLayoutConstraint(item: errorLabel,
                               attribute: .top,
                               relatedBy: .equal,
                               toItem: startButton,
                               attribute: .bottom,
                               multiplier: 1.0,
                               constant: 30),
            NSLayoutConstraint(item: errorLabel,
                               attribute: .centerX,
                               relatedBy: .equal,
                               toItem: containerView,
                               attribute: .centerX,
                               multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: errorLabel,
                               attribute: .height,
                               relatedBy: .equal,
                               toItem: nil,
                               attribute: .notAnAttribute,
                               multiplier: 1.0,
                               constant: 50)
            ])
    }

    private func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.isHidden = true
        activityIndicator.color = .white
        containerView.addConstraints([
            NSLayoutConstraint(item: activityIndicator,
                               attribute: .bottom,
                               relatedBy: .equal,
                               toItem: containerView,
                               attribute: .bottom,
                               multiplier: 1.0,
                               constant: -50),
            NSLayoutConstraint(item: activityIndicator,
                               attribute: .centerX,
                               relatedBy: .equal,
                               toItem: containerView,
                               attribute: .centerX,
                               multiplier: 1.0,
                               constant: 0),
            NSLayoutConstraint(item: errorLabel,
                               attribute: .height,
                               relatedBy: .equal,
                               toItem: nil,
                               attribute: .notAnAttribute,
                               multiplier: 1.0,
                               constant: 50)
            ])
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Custom"),
            indexPath.row < timeArray.count else { return UITableViewCell() }

        let index = indexPath.row
        let time = timeArray[index]
        cell.textLabel?.text = "\(index + 1) retry executed after \(Double(round(100 * time) / 100)) s"
        return cell
    }
}
