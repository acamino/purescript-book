module Test.Main where

import Prelude

import Control.Monad.Eff (Eff)

import Test.Data.AddressBook (testAddressBook)
import Test.Spec.Runner (RunnerEffects)

main :: Eff (RunnerEffects ()) Unit
main = do
  testAddressBook
