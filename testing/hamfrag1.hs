--runDB f = do
--	master <- getYesod
--    let pool = dbPool master
--    runSqlPool f pool
     
getRootR :: Handler RepHtml
getRootR = do
toWidget [whamlet|$newline never
<div .container>
<div .row>
<h2>
Please select your team:
<form method=post enctype=#{enctype}>
^{formWidget}
<input type=submit .btn .btn-primary value="Save">
<h2>
Teams
<table .table>
<tr>
<th>
Team name
$forall ^{team} <- teams
<tr>
<td>
#{teamName}
|]

        
--    instance YesodAuth Quiz where
--       type AuthId Quiz = TeamId
--       loginDest _ = CategoryR
--       logoutDest _ = RootR
--       authHttpManager = httpManager
