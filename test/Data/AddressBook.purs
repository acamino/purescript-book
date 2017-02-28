module Test.Data.AddressBook (testAddressBook) where

import Prelude (Unit, bind, (<$>))

import Control.Monad.Eff (Eff)
import Data.AddressBook
import Data.Maybe (Maybe(..))
import Data.List (length)

import Test.Spec (describe, it)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.Reporter.Console (consoleReporter)
import Test.Spec.Runner (RunnerEffects, run)

example :: Entry
example =
  { firstName: "John"
  , lastName: "Smith"
  , address: { street: "123 Fake St."
             , city: "Faketown"
             , state: "CA"
             }
  }

printEntry :: String -> String -> AddressBook -> Maybe String
printEntry firstName lastName book = showEntry <$> findEntry firstName lastName book

testAddressBook :: Eff (RunnerEffects ()) Unit
testAddressBook = run [consoleReporter] do
  describe "AddressBook" do
    let book = insertEntry example emptyBook

    describe "findEntry" do
      it "returns the found entry if it is present" do
        printEntry "John" "Smith" book `shouldEqual` Just "Smith, John: 123 Fake St., Faketown, CA"

      it "returns Nothing if the entry is not present" do
        printEntry "John" "Smith" emptyBook `shouldEqual` Nothing

    describe "findEntryByStreet" do
      it "returns the found entry if it is present" do
        (showEntry <$> findEntryByStreet "123 Fake St." book) `shouldEqual` Just "Smith, John: 123 Fake St., Faketown, CA"

    describe "removeDuplicates" do
      it "removes duplicates entries in an address book" do
        let bookWithDups = insertEntry example book
        length bookWithDups `shouldEqual` 2
        length (removeDuplicates bookWithDups) `shouldEqual` 1
