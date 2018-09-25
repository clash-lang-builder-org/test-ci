{-|
  Copyright   :  (C) 2012-2016, University of Twente,
                          2017, Google Inc.
  License     :  BSD2 (see the file LICENSE)
  Maintainer  :  Christiaan Baaij <christiaan.baaij@gmail.com>
-}

{-# LANGUAGE MultiParamTypeClasses #-}

{-# OPTIONS_GHC -fno-warn-missing-methods #-}

module Clash.Core.Type where

import Control.DeepSeq                  (NFData)
import Data.Binary                      (Binary)
import Data.Hashable                    (Hashable)
import GHC.Generics                     (Generic)
import Unbound.Generics.LocallyNameless (Alpha,Subst)

import                Clash.Core.Name
import {-# SOURCE #-} Clash.Core.Term
import {-# SOURCE #-} Clash.Core.TyCon

data Type

type Kind   = Type
type TyName = Name Type
type TyOccName = OccName Type
type KiName = Name Kind
type KiOccName = OccName Kind

instance Eq       Type
instance Generic  Type
instance Show     Type
instance Alpha    Type
instance Subst    Type Type
instance Subst    Term Type
instance NFData   Type
instance Hashable Type
instance Binary   Type

mkTyConTy :: TyConName -> Type