{-# LANGUAGE DeriveDataTypeable #-}

-- | The types types that we use in Ghcid
module Language.Haskell.Ghcid.Types(
    Ghci(..), GhciError(..),
    Load(..), Severity(..), isMessage
    ) where

import Data.Typeable
import Control.Exception.Base (Exception)
-- import System.Process (ProcessHandle)

-- | A GHCi session. Created with 'startGhci'.
data Ghci = Ghci (String -> ([String] -> IO ()) -> IO ())
                 (IO ())
                 (String -> IO [String])

-- | GHCi shut down
data GhciError = UnexpectedExit String String
    deriving (Show,Eq,Ord,Typeable)

-- | Make GhciError an exception
instance Exception GhciError

-- | Severity of messages
data Severity = Warning | Error
    deriving (Show,Eq,Ord,Bounded,Enum,Typeable)

-- | Load messages
data Load
    = Loading
        {loadModule :: String
        ,loadFile :: FilePath
        }
    | Message
        {loadSeverity :: Severity
        ,loadFile :: FilePath
        ,loadFilePos :: (Int,Int)
        ,loadMessage :: [String]
        }
    deriving (Show, Eq, Ord)

-- | Is a Load a message with severity?
isMessage :: Load -> Bool
isMessage Message{} = True
isMessage _ = False
