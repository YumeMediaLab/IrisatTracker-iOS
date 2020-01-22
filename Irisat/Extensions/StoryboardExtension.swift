//
//  StoryboardExtension
//  NavigationBarPOC
//
//  Created by Rodrigo Najera Rivas on 2/23/19.
//  Copyright © 2019 RodrigoNajera. All rights reserved.
//

import UIKit

typealias CBStoryboardID = String

extension UIStoryboard {
  class func instanceofViewController(with storyboardID: String, from storyboardFileName: String) -> UIViewController? {
    let storyboard = UIStoryboard(
      name: storyboardFileName,
      bundle: nil
    )
    return storyboard.instantiateViewController(withIdentifier: storyboardID)
  }
}
