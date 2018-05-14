[%%raw
"import './style.scss'"]

open Tea

type route = Home | SpeakingQuiz | DictationQuiz | Settings

type model = {route: route; speaking: string option; dictation: string option}

type msg =
  | Speaking of string
  | Dictation of string
  | LocationChanged of Web.Location.location
  [@@bs.deriving accessors]

let route_of_location location =
  let route = Js.String.split "/" location.Web.Location.hash in
  match route with
  | [|"#!"; ""|] ->
      Home
  | [|"#!"; "speaking-quiz"|] ->
      SpeakingQuiz
  | [|"#!"; "dictation-quiz"|] ->
      DictationQuiz
  | [|"#!"; "settings"|] ->
      Settings
  | _ ->
      Home


let location_of_route = function
  | Home ->
      "#!/"
  | SpeakingQuiz ->
      "#!/speaking-quiz"
  | DictationQuiz ->
      "#!/dictation-quiz"
  | Settings ->
      "#!/settings"


let init_model = {route= Home; speaking= None; dictation= None}

let update_route model = function
  | route when model.route = route ->
      (model, Cmd.none)
  | route ->
      (model, location_of_route route |> Navigation.newUrl)


let update model = function
  | Speaking msg ->
      ({model with speaking= Some msg}, Cmd.none)
  | Dictation msg ->
      ({model with dictation= Some msg}, Cmd.none)
  | LocationChanged l ->
      ({model with route= route_of_location l}, Cmd.none)


let init () location = route_of_location location |> update_route init_model

let routing_view model =
  let open! Html in
  let color_box_class color =
    let color_class color = "siimple-box--" ^ color in
    let class_from_list classes = List.fold_left (fun a b -> a ^ " " ^ b) "" classes in
    class_from_list ["siimple-box"; color_class color]
  in
  let title_with_route title view color =
    [ div
        [class' @@ color_box_class color]
        [div [class' "siimple-box-title"] [text title]]
    ; div [class' "siimple-content"] [view] ]
  in
  let nodes =
    let open! View in
    match model.route with
    | Home ->
        title_with_route "home" Home.view "grey"
    | SpeakingQuiz ->
        title_with_route "speaking" (Speaking.view model) "pink"
    | DictationQuiz ->
        title_with_route "dictation" (Dictation.view model) "green"
    | Settings ->
        title_with_route "settings" (Settings.view model) "navy"
  in
  main [] nodes


let view model = div [] [routing_view model]

let main =
  Navigation.navigationProgram locationChanged
    { init
    ; update
    ; view
    ; subscriptions= (fun _ -> Sub.none)
    ; shutdown= (fun _ -> Cmd.none) }
