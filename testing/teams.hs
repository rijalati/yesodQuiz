{-# LANGUAGE QuasiQuotes, TypeFamilies, GeneralizedNewtypeDeriving #-}
{-# LANGUAGE TemplateHaskell, OverloadedStrings, GADTs, MultiParamTypeClasses #-}
{-# LANGUAGE NamedFieldPuns, RecordWildCards #-}

import Database.Esqueleto
import qualified Database.Persist.Query as OldQuery
import Database.Persist.TH
import Database.Persist.Sqlite
import Control.Monad.IO.Class (liftIO)

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persist|
--Category
--	name String
--	deriving Eq Show
Team
	name String
	country String
	continent String
	deriving Eq Show
--Session
--	number Int default=1
--	deriving Eq Show
--Question
--	categoryId CategoryId
--	body String
--	choice1 String
--	choice2 String Maybe
--	choice3 String Maybe
--	choice4 String Maybe
--	answer Int default=1
--	points Int
--	deriving Eq Show
--Submission
--	categoryId CategoryId
--	questionId QuestionId
--	teamId TeamId
--	sessionId SessionId
--	choice Int
--	correct Bool
--	points Int
--	UniqueTeamQuestionSession teamId questionId sessionId
--	deriving Eq Show
|]


teams :: IO ()
teams = withSqliteConn ":memory:" $ runSqlConn $ do
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

--do teams <- select $
--		from $ \team -> do	
--		return team
liftIO $ print teams
