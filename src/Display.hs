module Display (idle, display) where
 
import qualified Graphics.Rendering.OpenGL as GL
import qualified Graphics.UI.GLUT as GLUT
import Control.Monad (forM)

-- Define $=! operator to simplify use
($=!) :: (GL.HasSetter s) => s a -> a -> IO ()
($=!) = (GL.$=!)

-- Render n points in a cirle
-- TODO: This could be more modular
points :: Int -> [(GL.GLfloat,GL.GLfloat,GL.GLfloat)]
points n' = let n = fromIntegral n' in
    map (\k -> let t = 2*pi*k/n in (sin(t),0,cos(t)))  [1..n]
 
-- Our GLUT display callback function
display angle = do 
    GL.clear [GL.DepthBuffer, GL.ColorBuffer]
    GL.loadIdentity -- I don't know what this does, but it makes stuff work...

    -- Rotate and scale stuff somehow... OpenGL magic
    -- how do I controle what models this effects?
    a <- GLUT.get angle
    GL.rotate a $ GL.Vector3 1 1 (1 :: GL.GLfloat)
    GL.scale 0.5 0.5 (0.5 :: GL.GLfloat)

    forM (points 17) (\(x,y,z) ->
            GL.preservingMatrix $ renderBoxAndWire x y z
        )
    GLUT.swapBuffers -- This makes things double buffer correctly

renderBoxAndWire x y z = do
    -- Create RenderLists for cubes and Wireframes.
    scube <- GL.defineNewList GL.Compile $ do
        GLUT.renderObject GLUT.Solid $ GLUT.Cube (0.1)
    lcube <- GLUT.defineNewList GLUT.Compile $ do
        GLUT.renderObject GLUT.Wireframe $ GLUT.Cube (0.1)

    -- How does this translate actually work? Does it make
    -- everything draw around this origin untill we set it
    -- again? I should probably write some tests to figure
    -- this out.
    GL.translate $ GL.Vector3 x y z
    GL.color $ GL.Color3 ((x+1.0)/2.0) ((y+1.0)/2.0) ((z+1.0)/2.0)
    GL.callList scube
    GL.color $ GL.Color3 0.0 0.0 (0.0 :: GL.GLfloat)
    GL.callList lcube
 
-- Our GLUT idle callback function
idle angle = do
    a <- GLUT.get angle
    angle $=! (a + 0.04)
    GLUT.postRedisplay Nothing
