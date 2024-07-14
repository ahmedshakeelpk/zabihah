import UIKit


@discardableResult
func customActivityIndicatory(_ viewContainer: UIView, startAnimate:Bool? = true) -> UIActivityIndicatorView {
    
      let mainContainer: UIView = UIView(frame: viewContainer.frame)
      mainContainer.center = viewContainer.center
      mainContainer.backgroundColor = UIColor.clear//UIColor.init(netHex: 0xFFFFFF)
      mainContainer.alpha = 0.5
      mainContainer.tag = 789456123
      mainContainer.isUserInteractionEnabled = true
  
      let viewBackgroundLoading: UIView = UIView(frame: CGRect(x:0,y: 0,width: 80,height: 80))
      viewBackgroundLoading.center = viewContainer.center
      viewBackgroundLoading.backgroundColor = UIColor.black//UIColor.init(netHex: 0x444444)
      viewBackgroundLoading.alpha = 0.5
      viewBackgroundLoading.clipsToBounds = true
      viewBackgroundLoading.layer.cornerRadius = 15
  
      let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
      activityIndicatorView.frame = CGRect(x:0.0,y: 0.0,width: 40.0, height: 40.0)
    activityIndicatorView.style =
    UIActivityIndicatorView.Style.whiteLarge
      activityIndicatorView.center = CGPoint(x: viewBackgroundLoading.frame.size.width / 2, y: viewBackgroundLoading.frame.size.height / 2)
              if startAnimate!{
                   viewBackgroundLoading.addSubview(activityIndicatorView)
                    mainContainer.addSubview(viewBackgroundLoading)
                    viewContainer.addSubview(mainContainer)
                    activityIndicatorView.startAnimating()
              }else{
                     for subview in viewContainer.subviews{
                          if subview.tag == 789456123{
                            subview.removeFromSuperview()
                          }
                      }
              }
         return activityIndicatorView
}

