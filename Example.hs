{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE FlexibleContexts #-}
module Example where

import Data.ByteString.Char8 ()
import Data.Conduit
import qualified Data.Conduit.List as CL
import Control.Monad.IO.Class (liftIO)
import Control.Monad.Trans.Class (lift)
import Data.Text (Text)

import AWS.Credential
import AWS.EC2

imageIds :: [Text]
imageIds =
    [ "ami-e565ba8c"
    , "ami-6678da0f"
    , "ami-0067ca69"
    , "ami-f21aff9b"
    , "ami-03d37c6a"
    , "aki-f5c1219c"
    , "ari-f606f39f"
    , "ami-8a3cc9e3"
    ]

main :: IO ()
main = do
    cred <- loadCredential
    doc <- runResourceT $ do
        ctx <- liftIO $ newEC2Context cred
        runEC2 ctx $ do
--            setEndpoint ApNortheast1
--            response <- describeAvailabilityZones [] []
--            response <- describeRegions [] []
--            response <- describeImages imageIds [] [] []
--            response <- describeImages [] [] [] []
--            response <- describeAddresses [] [] []
            response <- describeInstances [] []
--            response <- describeInstanceStatus [] True []
            lift $ response $$ CL.consume
--            allocateAddress False
    print doc
    putStr "Length: "
    print $ length doc
