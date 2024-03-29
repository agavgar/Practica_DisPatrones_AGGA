//
//  LoginViewController.swift
//  Practica_DisPatrones_AGGA
//
//  Created by Alejandro Alberto Gavira García on 22/1/24.
//

import UIKit

final class LoginViewController: UIViewController {
    
    //MARK: - IB Outlets
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    
    //MARK: - Models
    private var viewModel: LoginViewModel
    
    //MARK: - Init
    init(viewModel: LoginViewModel = LoginViewModel()){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginButton.tintColor = .DBYellow
        setObservers()
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func loginButtonTap(_ sender: UIButton) {
        
        viewModel.onLoginButton(email: emailTextField.text, password: passwordTextField.text)
    }
    
}

extension LoginViewController {
    
    func setObservers(){
        
        
        viewModel.loginViewState = { [weak self] status in
            
            switch status {
            case .loading(let isLoading):
                self?.loadingView.isHidden = !isLoading
                self?.errorLabel.isHidden = true
            case .loaded:
                DispatchQueue.main.async {
                    self?.loadingView.isHidden = true
                    self?.errorLabel.isHidden = true
                }
                //MARK: - Todo navegar a la home
                self?.navigateToHome()
            case .loginError(let error):
                self?.errorLabel.text = error
                self?.errorLabel.isHidden = (error == nil || error?.isEmpty == true)
            case .networkError(let error):
                self?.showAlert(message: error)
            }
        }
    }
    
    private func navigateToHome(){
        
        DispatchQueue.main.async {
            let nextVM = HomeViewModel(useCase: HeroesUseCase())
            let nextVC = HomeCollectionViewController(viewModel: nextVM)
            self.navigationController?.setViewControllers([nextVC], animated: true)
        }
        
    }
    
    private func showAlert(message: String){
        let alertController = UIAlertController(title: "Network Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Accept", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    

}
