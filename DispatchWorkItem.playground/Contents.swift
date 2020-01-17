//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

// https://stackoverflow.com/questions/54058634/what-are-the-benefits-of-using-dispatchworkitem-in-swift

class MyViewController : UIViewController {
    
    private var pendingRequestWorkItem: DispatchWorkItem?
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "DispatchWorkItem"
        label.textColor = .black
        view.addSubview(label)
        NSLayoutConstraint.activate([NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0),NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)])
        
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "输入关键词"
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.addTarget(self, action: #selector(onTextChanged), for: .editingChanged)
        view.addSubview(textField)

        NSLayoutConstraint.activate([NSLayoutConstraint(item: textField, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),NSLayoutConstraint(item: textField, attribute: .bottom, relatedBy: .equal, toItem: label, attribute: .top, multiplier: 1, constant: -50)])
        
        self.view = view
    }
    
    @objc func onTextChanged(textField: UITextField) {
        print("用户输入了\(textField.text ?? "")")
        pendingRequestWorkItem?.cancel()
        let requestWorkItem = DispatchWorkItem { [weak self] in
            guard let text = textField.text else {return}
            self?.search(with: text)
        }
        // Save the new work item and execute it after 250 ms
        pendingRequestWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500),
                                      execute: requestWorkItem)
        
    }
    
    func search(with keyword: String)  {
        guard let url = URL(string: "http://balala.moneybang888.com/app/version/version?bundleId=com.cnschr.speedhr") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            /*
             A dispatch work item has a cancel flag. If it is cancelled before running, the dispatch queue won’t execute it and will skip it. If it is cancelled during its execution, the cancel property return True. In that case, we can abort the execution
             */
            if self.pendingRequestWorkItem!.isCancelled {
                return
            }
            guard let data = data else { return }
            let jsonStr = String(data: data, encoding: .utf8)
            print("\(keyword)请求结果为\(jsonStr ?? "")")
        }.resume()
        
    }
    
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
