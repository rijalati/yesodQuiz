{-# LANGUAGE QuasiQuotes, TypeFamilies, GeneralizedNewtypeDeriving, FlexibleContexts #-}
{-# LANGUAGE TemplateHaskell, OverloadedStrings, GADTs, MultiParamTypeClasses #-}
{-# LANGUAGE NamedFieldPuns, RecordWildCards #-}

import Yesod
import Yesod.Form.Jquery
import Text.Blaze (preEscapedToMarkup)
import Data.Text
import Data.List (sortBy)
import Data.Ord (comparing)
import Data.Maybe (isJust)
import Database.Persist
import Database.Persist.Store
import Database.Persist.Sqlite
import Database.Persist.TH
import Control.Monad.Error
import Control.Monad (Join)
import Control.Applicative ((<$>), (<*>))

-- Our foundation type.
data Quiz = Quiz {dbPool :: ConnectionPool}

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persist|
Category
    name Text
	deriving Show
Team
    name Text
	deriving Show
Question
    category CategoryId
    body Text
    choice1 Text
    choice2 Text Maybe
    choice3 Text Maybe
    choice4 Text Maybe
    answer Int
    points Int
    deriving Show
Submission
    team teamId
    category CategoryId
    question QuestionId
    choice Int
    correct Bool
    points Int
|]


