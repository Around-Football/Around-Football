//
//  AFIcon.swift
//  Around-Football
//
//  Created by Deokhun KIM on 12/18/23.
//

import UIKit

enum AFIcon {
    static let defaultFieldImage = UIImage(named: Self.fieldImage)
    static let defaultUserImage = UIImage(named: Self.userLogo)
    
    static let defaultImageURL = "https://firebasestorage.googleapis.com/v0/b/around-football.appspot.com/o/DefaultProfileImage.png?alt=media&token=9274520c-2134-489a-8665-59006714c8f2"
    //tab
    static let home = "AFHome"
    static let homeSelect = "AFHomeSelect"
    static let location = "AFLocation"
    static let locationSelect = "AFLocationSelect"
    static let chat = "AFChat"
    static let chatSelect = "AFChatSelect"
    static let user = "AFUser"
    static let userSelect = "AFUserSelect"
    
    //homeCell
    static let fieldImage = "AFFieldImage"
    static let bookmark = "AFBookmark"
    static let bookmarkSelect = "AFBookmarkSelect"

    //component
    static let downCaret = "AFDownCaret"
    static let leftArrow = "AFLeftArrow"
    static let minus = "AFMinus"
    static let plus = "AFPlus"
    static let imagePlaceholder = "AFImagePlaceholder"
    static let footballImage = "AFBallImage"
    
    //logo
    static let smallLogo = "AFSmallLogo"
    static let textLogo = "AFTextLogo"
    static let blackLlogo = "AFLogoBlack"
    static let greenLogo = "AFLogoGreen"
    static let userLogo = "AFUserDefaultImage"
    
    //button
    static let plusButton = "AFPlusButton"
    static let rightButton = "AFRightCaret"
    static let backButton = "AFBackButton"
    static let trackingButton = "AFTrackingButton"
    static let searchButton = "AFSearchButton"
    static let settingButton = "AFSettingButton"
    static let deleteButton = "AFDeleteButton"
    static let cameraButton = "AFCameraButton"
    
    //background
    static let loginBackgroundImage = "AFBackground"
    
    //Login
    static let closeButton = "AFClose"
    static let googleLogin = "AFGoogleLogin"
    static let appleLogin = "AFAppleLogin"
    static let kakaoLogin = "AFKakaoLogin"
    
    //Search
    static let searchItem = "AFSearchItem"
    
    //Map
    static let trackingPoint = "AFTrackingPoint"
    static let marker = "AFMarker"
}
