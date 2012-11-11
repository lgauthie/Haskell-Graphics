module Bindings (reshape,keyboardMouse) where

import Graphics.Rendering.OpenGL
import Graphics.UI.GLUT
 
reshape s@(Size w h) = do 
    viewport $= (Position 0 0, s)
 
keyboardMouse key state modifiers position = return ()
