//
//  ViewController.swift
//  miniApp2
//
//  Created by 宋航 on 2018/2/19.
//  Copyright © 2018年 宋航. All rights reserved.
//

import UIKit
import WebKit
import Alamofire
import SSZipArchive
import JavaScriptCore

class ViewController: UIViewController {
    let handanURL: String = "http://localhost:3000/"
    let cachesDirectory: URL = FileManager.default.urls(for: .cachesDirectory, in: .allDomainsMask).first! as URL
    let packTypeName = ".zip"
    var webView : MiniWebview!
    var jsContext : JSContext!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(cachesDirectory)
        preLoadMiniApp()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension ViewController{
    /// 准备加载HTML
    func preLoadMiniApp(){
        let zipName: String = "1"
        let isExists:Bool =  checkFileIsReadyLoad(name: (zipName+packTypeName))
        if isExists == true {
            print("已下载")
            unpackZip(name: zipName)
            //读取解压后的HTML内容
//            loadHTML(zipName: zipName)
        }
        else{
            downloadZip(name: zipName, callback: { (res) -> (Void) in
                if res.error != nil {
                    print(res.error as Any)
                }
                else{
                    print("下载完成，准备解压")
                    self.unpackZip(name: zipName)
//                    self.loadHTML(zipName: zipName)
                }
            })
        }
        
    }
    /// 查看caches里面是否有指定文件或者文件夹
    ///
    /// - Parameter name: 文件/文件夹名字
    /// - Returns: 是否存在
    func checkFileIsReadyLoad(name:String) -> Bool{
        let fileURL:URL = cachesDirectory.appendingPathComponent(name)
        let exists:Bool = FileManager().fileExists(atPath: fileURL.path)
        return exists
    }
    
    /// 下载zip包
    ///
    /// - Parameters:
    ///   - name: zip包名字
    ///   - callback: 下载后回调
    func downloadZip(name:String,callback:@escaping ((DefaultDownloadResponse)->(Void))){
        print("下载ZIP包")
        let url: String = handanURL + name + packTypeName
        let destination = DownloadRequest.suggestedDownloadDestination(for: .cachesDirectory, in: .userDomainMask)
        Alamofire.download(url,to: destination).response { (res) in
            callback(res)
        }
    }
    
    
    /// zip包解压
    ///
    /// - Parameter name: zip包名字
    func unpackZip(name:String){
        // 查看解压后文件是否存在
        let path:String = name+"/"
        let isExistUnpack:Bool =  checkFileIsReadyLoad(name: path)
        // 没有的话就进行解压
        if isExistUnpack == false {
            let zipURL:URL = cachesDirectory.appendingPathComponent(name+packTypeName)
            let destinationURL:URL = cachesDirectory.appendingPathComponent(path)
            SSZipArchive.unzipFile(atPath: zipURL.path, toDestination: destinationURL.path)
            print("zip包解压完成")
        }
        else{
            print("已经存在，不需解压")
        }
        loadHTML(zipName: name)
    }

    /// 加载HTML文件到webview去
    ///
    /// - Parameter zipName: zip包名
    func loadHTML(zipName:String){
        //读取解压后的HTML内容
        let htmlFileURL = cachesDirectory.appendingPathComponent(zipName + "/index.html")
        let htmlString:String = try! String.init(contentsOf: htmlFileURL)
        let baseURL:URL = cachesDirectory.appendingPathComponent(zipName)
        webView = MiniWebview.init(html: htmlString, url: baseURL)
//        print(UIApplication.shared.statusBarFrame)
//        print(self.navigationController?.navigationBar.frame)
        // 必需手动设置，否则首次解压加载的页面会显示错位。
        webView.frame = CGRect.init(x: 0, y: 64, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 64)
        webView.configuration.userContentController.add(self, name: "hmlapp")
        webView.navigationDelegate = self
        view.addSubview(webView)
    }
}

extension ViewController:WKScriptMessageHandler{
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let parames = message.body as! NSDictionary
        let name = parames["name"] as! String
        let key = parames["key"] as! Int
//        print(message.name)
//        print(message.body)
//        print(name)
//        print(key)
        let userInfo = [
            "name":"三月",
            "age":10,
            ] as [String : Any]
        let userName = userInfo["name"] as! String
        let userAge = userInfo["age"] as! Int
        let commandString = "hmlApp.getUserInfoCallback(\(key),{name:'\(userName)',age:\(userAge)})"
        print(commandString)
        if name == "getUserInfo" {
            webView.evaluateJavaScript(commandString) { (res,err) in
                //print(res)
            }
        }
    }
}
extension ViewController:WKNavigationDelegate{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        self.jsContext = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext
        print("加载完成")
    }
}
