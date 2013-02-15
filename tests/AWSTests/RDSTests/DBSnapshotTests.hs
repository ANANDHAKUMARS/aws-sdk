module AWSTests.RDSTests.DBSnapshotTests
    ( runDBSnapshotTests
    )
    where

import Data.Text (Text)
import Test.Hspec
import qualified Control.Exception.Lifted as E

import AWS.RDS
import AWS.RDS.Types
import AWS.RDS.Util
import AWSTests.Util
import AWSTests.RDSTests.Util

region :: Text
region = "ap-northeast-1"

runDBSnapshotTests :: IO ()
runDBSnapshotTests = do
    hspec describeDBSnapshotsTest
    hspec createDBSnapshotTest

describeDBSnapshotsTest :: Spec
describeDBSnapshotsTest = do
    describe "describeDBSnapshots doesn't fail" $ do
        it "describeDBSnapshots doesn't throw any exception" $ do
            testRDS region (
                describeDBSnapshots Nothing Nothing Nothing Nothing Nothing
                ) `miss` anyConnectionException

createDBSnapshotTest :: Spec
createDBSnapshotTest = do
    describe "{create,delete}DBSnapshot doesn't fail" $ do
        it "{create,delete}DBSnapshot doesn't throw any exception" $ do
            testRDS region test `miss` anyConnectionException
  where
    dbsid = "hspec-test-snapshot"
    test = do
        dbis <- describeDBInstances Nothing Nothing Nothing
        let dbiid = dbInstanceIdentifier $ head dbis
        dbs <- createDBSnapshot dbiid dbsid
        wait
            (\dbs' -> dbSnapshotStatus dbs' == "available")
            (\dbsid' -> describeDBSnapshots Nothing (Just dbsid') Nothing Nothing Nothing) $
            dbSnapshotIdentifier dbs
      `E.finally` deleteDBSnapshot dbsid
