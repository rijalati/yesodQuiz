{-# LANGUAGE QuasiQuotes, TypeFamilies, GeneralizedNewtypeDeriving, FlexibleContexts #-}
{-# LANGUAGE TemplateHaskell, OverloadedStrings, GADTs, MultiParamTypeClasses #-}
{-# LANGUAGE NamedFieldPuns, RecordWildCards #-}

import Yesod
import Yesod.Form.Jquery
import Yesod.Auth.BrowserId (authBrowserId)
import Network.HTTP.Conduit (Manager, newManager, def)
import Text.Blaze (preEscapedToMarkup)
import Data.Text
import Data.Maybe (isJust)
import Database.Esqueleto
import qualified Database.Persist.Query as OldQuery
import Database.Persist.Store
import Database.Persist.Sqlite
import Database.Persist.TH
import Control.Monad.IO.Class (liftIO)
import Control.Applicative (pure, (<$>), (<*>))
import Control.Monad (forM_, liftM)
import Data.Map.Utils
import Data.List (foldl', intersperse, sort)
import Data.Maybe (catMaybes)

-- Our foundation type.
data Quiz = Quiz {dbPool :: ConnectionPool, httpManager :: Manager}



mkYesod "Quiz" [parseRoutes|
/ RootR GET POST
/team TeamR GET
/categories CategoryR GET
/leaderboard LeaderboardR GET
/question/#CategoryId/#QuestionId QuestionR GET
/question/#CategoryId/#QuestionId/#Int SubmissionR POST
/admin AdminR GET POST
/static StaticR Static getStatic
|]

instance Yesod Quiz where
    approot = ApprootStatic "http://localhost:3000"

instance RenderMessage Quiz FormMessage where
    renderMessage _ _ = defaultFormMessage

instance YesodPersist Quiz where
	type YesodPersistBackend Quiz = SqlPersist

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persist|
Category
	name String
	deriving Eq Show
Team
	name String
	country String
	continent String
	deriving Eq Show
Session
	number Int default=1
	deriving Eq Show
Question
	categoryId CategoryId
	body Text
	choice1 Text
	choice2 Text Maybe
	choice3 Text Maybe
	choice4 Text Maybe
	answer Int default=1
	points Int
	deriving Eq Show
Submission
	categoryId CategoryId
	questionId QuestionId
	teamId TeamId
	sessionId SessionId
	choice Int
	correct Bool
	points Int
	UniqueTeamQuestionSession teamId questionId sessionId
	deriving Eq Show
|]

teamList :: IO ()
let teamList = withSqliteConn ":memory:" $ runSqlConn $ do
	runMigration migrateAll

	insert $ Team "Taj Mahal" "India" "Asia"
	insert $ Team "Great Wall" "China" "Asia"
	insert $ Team "Everest" "Tibet" "Asia"
	insert $ Team "Tokyo Tower" "Japan" "Asia"
	insert $ Team "Angkor Wat Temple" "Cambodia" "Asia"
	insert $ Team "Grand Palace" "Thailand" "Asia"
	insert $ Team "Niagara Falls" "Canada" "Americas"
	insert $ Team "Statue of Liberty" "USA" "Americas"
	insert $ Team "Machu Pichu" "Peru" "Americas"
	insert $ Team "Plaza de Mayo" "Argentina" "Americas"
	insert $ Team "Christ de Redeemer" "Brazil" "Americas"
	insert $ Team "Mayan Pyramids" "Mexico" "Americas"
	insert $ Team "Colosseum" "Italy" "Europe"
	insert $ Team "Sagrada Familia" "Spain" "Europe"
	insert $ Team "Kremlin" "Russia" "Europe"
	insert $ Team "Belem Tower" "Portugal" "Europe"
	insert $ Team "Acropolis" "Greece" "Europe"
	insert $ Team "Sydney Opera" "Australia" "Oceania"
	insert $ Team "12 Apostles Rocks" "Australia" "Oceania"
	insert $ Team "Ayer Rock" "Australia" "Oceania"
	insert $ Team "Great Barrier Reef" "Australia" "Oceania"
	insert $ Team "Mount Eden" "New Zealand" "Oceania"
	insert $ Team "NZ Glaciers" "New Zealand" "Oceania"
	insert $ Team "Giza Pyramid" "Egypt" "Africa"
	insert $ Team "Table Mountain" "South Africa" "Africa"
	insert $ Team "Kilimanjaro" "Tanzania" "Africa"
	insert $ Team "Hassan II Mosque" "Morocco" "Africa"
	insert $ Team "Victoria Falls" "Zimbabwe" "Africa"
	insert $ Team "Sousse Medina" "Tunisa" "Africa"

	do teams <- select $
		from $ \team -> do
		return team
	liftIO $ print teams
