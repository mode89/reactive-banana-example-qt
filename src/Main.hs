module Main where

import Foreign.Hoppy.Runtime (withScopedPtr)
import qualified Graphics.UI.Qtah.Core.QCoreApplication as QCoreApplication
import qualified Graphics.UI.Qtah.Widgets.QAbstractButton as QAbstractButton
import qualified Graphics.UI.Qtah.Widgets.QApplication as QApplication
import qualified Graphics.UI.Qtah.Widgets.QBoxLayout as QBoxLayout
import qualified Graphics.UI.Qtah.Widgets.QHBoxLayout as QHBoxLayout
import qualified Graphics.UI.Qtah.Widgets.QLabel as QLabel
import qualified Graphics.UI.Qtah.Widgets.QMainWindow as QMainWindow
import qualified Graphics.UI.Qtah.Widgets.QPushButton as QPushButton
import qualified Graphics.UI.Qtah.Widgets.QVBoxLayout as QVBoxLayout
import qualified Graphics.UI.Qtah.Widgets.QWidget as QWidget
import Graphics.UI.Qtah.Signal (connect_)
import Reactive.Banana
import Reactive.Banana.Frameworks
import System.Environment (getArgs)

main :: IO ()
main = start $ do
    (up, down, counter) <- makeWidgets

    (addUpEvent, fireUp) <- newAddHandler
    (addDownEvent, fireDown) <- newAddHandler

    network <- compile $ do
        eUp <- fromAddHandler addUpEvent
        eDown <- fromAddHandler addDownEvent
        bCounter <- accumB 0 $ unions
            [ (+1) <$ eUp
            , subtract 1 <$ eDown ]
        eCounterChanged <- changes bCounter
        reactimate' $
            fmap (QLabel.setText counter . show) <$> eCounterChanged
    actuate network

    connect_ up QAbstractButton.clickedSignal $ \_ -> fireUp ()
    connect_ down QAbstractButton.clickedSignal $ \_ -> fireDown ()

makeWidgets :: IO ( QPushButton.QPushButton
                  , QPushButton.QPushButton
                  , QLabel.QLabel )
makeWidgets = do
    up <- QPushButton.newWithText "Up"
    down <- QPushButton.newWithText "Down"

    buttonsLayout <- QHBoxLayout.new
    QBoxLayout.addWidget buttonsLayout up
    QBoxLayout.addWidget buttonsLayout down

    counter <- QLabel.newWithText "Counter"

    centralWidgetLayout <- QVBoxLayout.new
    QBoxLayout.addWidget centralWidgetLayout counter
    QBoxLayout.addLayout centralWidgetLayout buttonsLayout

    centralWidget <- QWidget.new
    QWidget.setLayout centralWidget centralWidgetLayout

    mainWindow <- QMainWindow.new
    QWidget.setWindowTitle mainWindow "Counter"
    QMainWindow.setCentralWidget mainWindow centralWidget
    QWidget.show mainWindow

    return (up, down, counter)

start :: IO () -> IO ()
start app = withScopedPtr (getArgs >>= QApplication.new) $
    \_ -> app >> QCoreApplication.exec
