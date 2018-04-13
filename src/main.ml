open Tea
open Tea.Html

type route =
  | Home
  | SpeakingQuiz
  | DictationQuiz
  | Settings

type model =
  { route: route
  ; speaking: string option
  ; dictation: string option
  }

type msg =
  | Speaking of string
  | Dictation of string
  | LocationChanged of Web.Location.location
  [@@bs.deriving accessors]
 
let route_of_location location =
  let route = Js.String.split "/" location.Web.Location.hash in
  match route with
  | [|"#!"; ""|]               -> Home
  | [|"#!"; "speaking-quiz"|]  -> SpeakingQuiz
  | [|"#!"; "dictation-quiz"|] -> DictationQuiz
  | [|"#!"; "settings"|]       -> Settings      
  | _                          -> Home

let location_of_route = function
  | Home          -> "#!/"
  | SpeakingQuiz  -> "#!/speaking-quiz"
  | DictationQuiz -> "#!/dictation-quiz"
  | Settings      -> "#!/settings"

external alert : (string -> unit) = "alert" [@@bs.val]

let init_model =
  { route = Home
  ; speaking = None
  ; dictation = None
  }

let update_route model = function
  | route when model.route = route -> model, Cmd.none
  | route -> model, location_of_route route |> Navigation.newUrl

let update model = function
  | Speaking msg -> { model with speaking = Some msg}, Cmd.none
  | Dictation msg -> { model with dictation = Some msg}, Cmd.none
  | LocationChanged l -> { model with route = route_of_location l }, Cmd.none

let init () location =
  route_of_location location |> update_route init_model

let home_link = a [href "#!/"] [text "Home"]
let speaking_link = a [href "#!/speaking-quiz"] [text "Speking Quiz"]
let dictation_link = a [href "#!/dictation-quiz"] [text "Dictation Quiz"]
let settings_link = a [href "#!/settings"] [text "Settings"]

let home_view =
  let open! Html in
  let item link = li [] [link] in
  nav []
    [ ul [] [ item home_link
            ; item speaking_link
            ; item dictation_link
            ; item settings_link
            ]] 

let speaking_view =
  let open! Html in
  div [] [ home_link
         ; input' [type' "text"; onChange speaking] []
         ]

let dictation_view =
  let open! Html in
  div [] [ home_link
         ; input' [type' "text"; onChange dictation] []
         ]

let settings_view =
  let open! Html in
  home_link

let routing_view model =
  let open! Html in
  let nodes = match model.route with
           | Home -> [text "home"; home_view]
           | SpeakingQuiz -> [text "speaking"; speaking_view]
           | DictationQuiz -> [text "dictation"; dictation_view]
           | Settings -> [text "settings"; settings_view]
  in main [] nodes

let view model =
  div
    []
    [ routing_view model
    ]

let main =
  Navigation.navigationProgram locationChanged
    { init
    ; update
    ; view
    ; subscriptions = (fun _ -> Sub.none)
    ; shutdown = (fun _ -> Cmd.none)
    }