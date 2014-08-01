{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE CPP #-}

module Fixtures where

import Data.Aeson
import Data.Attoparsec.ByteString
import qualified Data.Text as T
import qualified Data.Text.Encoding as T
import qualified Data.Text.IO as T
import Data.Maybe
import Text.Shakespeare.Text
import System.Environment
import System.FilePath
import System.IO.Unsafe (unsafePerformIO)
import Control.Applicative

fj :: T.Text -> Value
fj = fromJust . maybeResult . parse json . T.encodeUtf8

fixturePath :: String
fixturePath = unsafePerformIO $ do
    fromMaybe defaultPath <$> lookupEnv "TWITTER_FIXTURE_PATH"
  where
    defaultPath = takeDirectory __FILE__ </> "fixtures"

loadFixture :: String -> IO Value
loadFixture filename = fj <$> T.readFile (fixturePath </> filename)

fixture :: String -> Value
fixture = unsafePerformIO . loadFixture

errorMsgJson :: Value
errorMsgJson = fj [st|{"request":"\/1\/statuses\/user_timeline.json","error":"Not authorized"}|]

statusJson :: Value
statusJson = fixture "status_object.json"

statusEntityJson :: Value
statusEntityJson = fixture "status_object_with_entity.json"

mediaEntityJson :: Value
mediaEntityJson = fixture "media_entity.json"

mediaExtendedEntityJson :: Value
mediaExtendedEntityJson = fixture "media_extended_entity.json"
