import Data.Ratio ((%))
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout
import XMonad.Layout.IM
import XMonad.Util.Loggers
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys, removeKeys)
import System.IO


main = do
  barproc <- spawnPipe myStatusBar
  xmonad $ defaultConfig
      { layoutHook = avoidStruts $ myLayout
      , logHook = dynamicLogWithPP $ myBarPP barproc
      , manageHook = manageDocks <+> myManagehook
      , modMask = myModMask
      , terminal = myTerminal
      --, workspaces = myWorkspaces
      }  `removeKeys`
      [ (myModMask, xK_p)
      , (myModMask .|. shiftMask, xK_p)
      ]`additionalKeys`
      [ ((controlMask .|. mod1Mask, xK_l), spawn "xautolock -locknow")
      ]

myBarPP h = defaultPP { ppOutput = hPutStrLn h
  , ppSep = " | "
  , ppWsSep = " "
  , ppCurrent = wrapFgBg myCurrentWsFgColor myCurrentWsBgColor
  , ppVisible = wrapFgBg myVisibleWsFgColor myVisibleWsBgColor
  , ppHidden = wrapFgBg myHiddenWsFgColor myHiddenWsBgColor
  , ppHiddenNoWindows = wrapFgBg myHiddenNoWsFgColor myHiddenNoWsBgColor
  , ppTitle = (\x -> wrapFgBg myTitleFgColor myTitleBgColor (" " ++ x))
  }
  where
    wrapFgBg fgColor bgColor content = wrap ("%{F" ++ fgColor ++ "}%{B" ++ bgColor ++ "}") ("%{F-}%{B" ++ bgColor ++ "}") content


-- PP information
myCurrentWsBgColor = "#FF222222"
myCurrentWsFgColor = "#FFf39d21"
myFont1 = "-*-stlarch-*-*-*-*-*-*-*-*-*-*-*-*"
myFont2 = "-*-terminus-medium-r-normal-*-12-*-*-*-*-60-iso10646-*"
myHiddenWsBgColor = "#FF222222"
myHiddenWsFgColor = "#FFffffff"
myHiddenNoWsBgColor = "#FF222222"
myHiddenNoWsFgColor = "#FF999999"
myTitleBgColor = "#FF769fec"
myTitleFgColor = "#FFffffff"
myVisibleWsBgColor = "#FF222222"
myVisibleWsFgColor = "#FFffffff"



-- Layout information
myLayout = withIM (1%7) myRoster (tiled ||| Mirror tiled ||| Full)
  where
    tiled = Tall nmaster delta ratio
    nmaster = 1
    ratio = 1/2
    delta = 3/100


-- manageHook information
myManagehook = composeAll
    [ isChatWindow --> doShift "3" ]

myIMclass = "Google-chrome"
isChatWindow = (className =? myIMclass <&&>
                stringProperty "WM_WINDOW_ROLE" =? "pop-up" <&&>
                appName =? "crx_nckgahadagoaajjgafhacjanaoiihapd")

myRoster = (Title "Hangouts") `And` (ClassName myIMclass)
myModMask = mod4Mask

myStatusBar = "bar -p -g 950x14 -B '#FF769fec' -f " ++ myFont1 ++ "," ++ myFont2
myTerminal = "tabbed urxvt -embed"
-- myWorkspaces = [
--   "term",
--   "web",
--   "chat",
--   "dashboard",
--   "5",
--   "6",
--   "7",
--   "8",
--   "personal",
--   "0"
--   ]
